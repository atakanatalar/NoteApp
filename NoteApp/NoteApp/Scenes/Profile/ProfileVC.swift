//
//  ProfileVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import UIKit

class ProfileVC: NADataLoadingVC {
    
    let headerView = UIView()
    let userInfoUpdateView = UIView()
    let userPasswordUpdateView = UIView()
    
    var profileHeaderVC: NAProfileHeaderVC!
    var userInfoUpdateVC: NAUserInfoUpdateVC!
    var userPasswordUpdateVC: NAUserPasswordUpdateVC!
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureScrollView()
        configureUIElements()
        layoutUI()
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationController?.setToolbarHidden(true, animated: true)
        
        let signOutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(signOutButtonTapped))
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        scrollView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 630),
        ])
    }
    
    func configureUIElements() {
        profileHeaderVC = NAProfileHeaderVC()
        userInfoUpdateVC = NAUserInfoUpdateVC(descriptionLabelText: "You can edit your user information", delegate: self)
        userPasswordUpdateVC = NAUserPasswordUpdateVC(descriptionLabelText: "You can edit your password", delegate: self)
        
        userInfoUpdateVC.inputViewOne.textField.delegate = self
        userInfoUpdateVC.inputViewTwo.textField.delegate = self
        
        userPasswordUpdateVC.inputViewOne.textField.delegate = self
        userPasswordUpdateVC.inputViewTwo.textField.delegate = self
        userPasswordUpdateVC.inputViewThree.textField.delegate = self
        
        self.add(childVC: profileHeaderVC, to: self.headerView)
        self.add(childVC: userInfoUpdateVC, to: self.userInfoUpdateView)
        self.add(childVC: userPasswordUpdateVC, to: self.userPasswordUpdateView)
    }
    
    func layoutUI() {
        contentView.addSubview(headerView)
        contentView.addSubview(userInfoUpdateView)
        contentView.addSubview(userPasswordUpdateView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        userInfoUpdateView.translatesAutoresizingMaskIntoConstraints = false
        userPasswordUpdateView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 66),
            
            userInfoUpdateView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            userInfoUpdateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userInfoUpdateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            userInfoUpdateView.heightAnchor.constraint(equalToConstant: 222),
            
            userPasswordUpdateView.topAnchor.constraint(equalTo: userInfoUpdateView.bottomAnchor, constant: padding),
            userPasswordUpdateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userPasswordUpdateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            userPasswordUpdateView.heightAnchor.constraint(equalToConstant: 282),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func getUserData() {
        showLoadingView()
        
        let getMeModel = GetMeModel()
        
        APIManager.sharedInstance.callingGetMeAPI(getMeModel: getMeModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.getMeResponse?.code
                let data = APIManager.sharedInstance.getMeResponse?.data
                let message = APIManager.sharedInstance.getMeResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    
                    profileHeaderVC.nameLabel.text = data?.name
                    profileHeaderVC.emailLabel.text = data?.email
                    
                    userInfoUpdateVC.inputViewOne.textField.placeholder = data?.name
                    userInfoUpdateVC.inputViewTwo.textField.placeholder = data?.email
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
    }
    
    @objc func signOutButtonTapped() {
        let destinationVC = LoginVC()
        navigationController?.pushViewController(destinationVC, animated: true)
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}

extension ProfileVC: NAUserInfoUpdateVCDelegate {
    func didTapInfoSaveButton() {
        showLoadingView()
        KeyboardHelper.closeKeyboard(view: view)
        
        guard let name = userInfoUpdateVC.inputViewOne.textField.text,
              let email = userInfoUpdateVC.inputViewTwo.textField.text else { return }
        
        let userUpdateMeModel = UserUpdateMeModel(name: name, email: email)
        
        APIManager.sharedInstance.callingUserUpdateMeAPI(userUpdateMeModel: userUpdateMeModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.userUpdateMeResponse?.code
                let message = APIManager.sharedInstance.userUpdateMeResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: message ?? "Success.")
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
    }
}

extension ProfileVC: NAUserPasswordUpdateVCDelegate {
    func didTapPasswordSaveButton() {
        showLoadingView()
        KeyboardHelper.closeKeyboard(view: view)
        
        guard let password = userPasswordUpdateVC.inputViewOne.textField.text,
              let newPassword = userPasswordUpdateVC.inputViewTwo.textField.text,
              let confirmPassword = userPasswordUpdateVC.inputViewThree.textField.text else { return }
        
        let updateMyPasswordModel = UpdateMyPasswordModel(password: password, newPassword: newPassword, confirmPassword: confirmPassword)
        
        APIManager.sharedInstance.callingUpdateMyPasswordAPI(updateMyPasswordModel: updateMyPasswordModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.updateMyPasswordResponse?.code
                let message = APIManager.sharedInstance.updateMyPasswordResponse?.message
                
                if code == "user.change-password" {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: message ?? "Success.")
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
    }
}

extension ProfileVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }

    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case userInfoUpdateVC.inputViewOne.textField:
            userInfoUpdateVC.inputViewTwo.textField.becomeFirstResponder()
        case userInfoUpdateVC.inputViewTwo.textField:
            userPasswordUpdateVC.inputViewOne.textField.becomeFirstResponder()
        case userPasswordUpdateVC.inputViewOne.textField:
            userPasswordUpdateVC.inputViewTwo.textField.becomeFirstResponder()
        case userPasswordUpdateVC.inputViewTwo.textField:
            userPasswordUpdateVC.inputViewThree.textField.becomeFirstResponder()
        default:
            KeyboardHelper.closeKeyboard(view: view)
        }
    }
}
