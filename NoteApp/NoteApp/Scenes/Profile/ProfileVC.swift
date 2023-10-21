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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
        getUserData()
        KeyboardHelper.createDismissKeyboardTapGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureUIElements() {
        profileHeaderVC = NAProfileHeaderVC()
        userInfoUpdateVC = NAUserInfoUpdateVC(descriptionLabelText: "You can edit your user information", delegate: self)
        userPasswordUpdateVC = NAUserPasswordUpdateVC(descriptionLabelText: "You can edit your password", delegate: self)
        
        self.add(childVC: profileHeaderVC, to: self.headerView)
        self.add(childVC: userInfoUpdateVC, to: self.userInfoUpdateView)
        self.add(childVC: userPasswordUpdateVC, to: self.userPasswordUpdateView)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(userInfoUpdateView)
        view.addSubview(userPasswordUpdateView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        userInfoUpdateView.translatesAutoresizingMaskIntoConstraints = false
        userPasswordUpdateView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
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
            userPasswordUpdateView.heightAnchor.constraint(equalToConstant: 382),
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
}

extension ProfileVC: NAUserInfoUpdateVCDelegate {
    func didTapInfoSaveButton() {
        showLoadingView()
        
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
