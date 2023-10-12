//
//  ForgotPasswordVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
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
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemPurple
    }
    
    func configureUIElements() {
        authHeaderVC = NAAuthHeaderVC(
            titleLabelText: "Forgot Password",
            secondaryTitleLabelText: "Confirm your email and we'll send the instructions"
        )
        
        forgotPasswordInputVC = NAForgotPasswordInputVC(delegate: self)
        
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
        let email = forgotPasswordInputVC.inputViewOne.textField.text
        
        if let email = email {
            print("email: \(email)")
        }
    }
}
