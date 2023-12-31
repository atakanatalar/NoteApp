//
//  ForgotPasswordVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class ForgotPasswordVC: NADataLoadingVC {
    
    let headerView = UIView()
    let forgotPasswordInputView = UIView()
    
    var authHeaderVC: NAAuthHeaderVC!
    var forgotPasswordInputVC: NAForgotPasswordInputVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemPurple
    }
    
    func configureUIElements() {
        authHeaderVC = NAAuthHeaderVC(
            titleLabelText: "Forgot Password",
            secondaryTitleLabelText: "We will send the instructions to your email"
        )
        
        forgotPasswordInputVC = NAForgotPasswordInputVC(delegate: self)
        
        forgotPasswordInputVC.inputViewOne.textField.delegate = self
        
        self.add(childVC: authHeaderVC, to: self.headerView)
        self.add(childVC: forgotPasswordInputVC, to: self.forgotPasswordInputView)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(forgotPasswordInputView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordInputView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 66),
            
            forgotPasswordInputView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            forgotPasswordInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            forgotPasswordInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            forgotPasswordInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension ForgotPasswordVC: NAForgotPasswordInputVCDelegate {
    func didTapResetPasswordButton() {
        showLoadingView()
        KeyboardHelper.closeKeyboard(view: view)
        
        guard let email = forgotPasswordInputVC.inputViewOne.textField.text else { return }
        
        let forgotPasswordModel = ForgotPasswordModel(email: email)
        
        APIManager.sharedInstance.callingForgotPasswordAPI(forgotPasswordModel: forgotPasswordModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.forgotPasswordResponse?.code
                let message = APIManager.sharedInstance.forgotPasswordResponse?.message
                
                if code == "auth.forgot-password" {
                    dismissLoadingView()
                    
                    let destinationVC = LoginVC()
                    navigationController?.pushViewController(destinationVC, animated: true)
                    
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Check your email 📨")
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

extension ForgotPasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }

    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case forgotPasswordInputVC.inputViewOne.textField:
            KeyboardHelper.closeKeyboard(view: view)
        default:
            KeyboardHelper.closeKeyboard(view: view)
        }
    }
}
