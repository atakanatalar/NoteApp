//
//  RegisterVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class RegisterVC: UIViewController {
    
    let headerView = UIView()
    let registerInputView = UIView()
    
    var authHeaderVC: NAAuthHeaderVC!
    var registerInputVC: NARegisterInputVC!

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
            titleLabelText: "Register",
            secondaryTitleLabelText: "Sign up to continue using our app"
        )
        
        registerInputVC = NARegisterInputVC(
            descriptionLabelText: "Already have an account?",
            delegate: self
        )
        
        self.add(childVC: authHeaderVC, to: self.headerView)
        self.add(childVC: registerInputVC, to: self.registerInputView)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(registerInputView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        registerInputView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 66),
            
            registerInputView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            registerInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            registerInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            registerInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension RegisterVC: NARegisterInputVCDelegate {
    
    func didTapSignUpButton() {
        let name = registerInputVC.inputViewOne.textField.text
        let email = registerInputVC.inputViewTwo.textField.text
        let password = registerInputVC.inputViewThree.textField.text
        
        if let name = name, let email = email, let password = password {
            print("name: \(name)\nemail: \(email)\npassword: \(password)")
        }
    }
    
    func didTapDescriptionButton() {
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
