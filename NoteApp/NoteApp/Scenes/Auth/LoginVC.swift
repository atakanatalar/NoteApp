//
//  LoginVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class LoginVC: UIViewController {

    let headerView = UIView()
    let loginInputView = UIView()
    
    var authHeaderVC: NAAuthHeaderVC!
    var loginInputVC: NALoginInputVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
        KeyboardHelper.createDismissKeyboardTapGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureUIElements() {
        authHeaderVC = NAAuthHeaderVC(
            titleLabelText: "Login",
            secondaryTitleLabelText: "Sign in to continue using our app"
        )
        
        loginInputVC = NALoginInputVC(
            descriptionLabelText: "New user?",
            delegate: self
        )
        
        self.add(childVC: authHeaderVC, to: self.headerView)
        self.add(childVC: loginInputVC, to: self.loginInputView)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(loginInputView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        loginInputView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 66),
            
            loginInputView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            loginInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension LoginVC: NALoginInputVCDelegate {
    
    func didTapForgotPasswordButton() {
        let forgotPasswordVC = ForgotPasswordVC()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func didTapSignInButton() {
        let email = loginInputVC.inputViewOne.textField.text
        let password = loginInputVC.inputViewTwo.textField.text
        
        if let email = email, let password = password {
            print("email: \(email)\npassword: \(password)")
        }
    }
    
    func didTapDescriptionButtonTapped() {
        let registerVC = RegisterVC()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

