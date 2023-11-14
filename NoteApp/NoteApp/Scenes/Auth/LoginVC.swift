//
//  LoginVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class LoginVC: NADataLoadingVC {

    let headerView = UIView()
    let loginInputView = UIView()
    
    var authHeaderVC: NAAuthHeaderVC!
    var loginInputVC: NALoginInputVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureAppearNavigationController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureAppearNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        loginInputVC.inputViewOne.textField.delegate = self
        loginInputVC.inputViewTwo.textField.delegate = self
        
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
        let destinationVC = ForgotPasswordVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func didTapSignInButton() {
        showLoadingView()
        KeyboardHelper.closeKeyboard(view: view)
        
        guard let email = loginInputVC.inputViewOne.textField.text,
              let password = loginInputVC.inputViewTwo.textField.text else { return }
        
        let loginModel = LoginModel(email: email, password: password)
        
        APIManager.sharedInstance.callingLoginAPI(loginModel: loginModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.loginResponse?.code
                let message = APIManager.sharedInstance.loginResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    
                    let destinationVC = NotesVC()
                    navigationController?.pushViewController(destinationVC, animated: true)
                    
                    setRootVC(destinationVC: destinationVC)
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Welcome back my friend 🥳")
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
    
    func didTapDescriptionButtonTapped() {
        let destinationVC = RegisterVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setRootVC(destinationVC: UIViewController) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        let navController: UINavigationController?
        
        navController = UINavigationController(rootViewController: destinationVC)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }

    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case loginInputVC.inputViewOne.textField:
            loginInputVC.inputViewTwo.textField.becomeFirstResponder()
        default:
            KeyboardHelper.closeKeyboard(view: view)
        }
    }
}
