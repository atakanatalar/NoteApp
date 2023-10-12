//
//  NAForgotPasswordInputVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

protocol NAForgotPasswordInputVCDelegate: AnyObject {
    func didTapResetPasswordButton()
}

class NAForgotPasswordInputVC: UIViewController {
    
    let inputStackView = UIStackView()
    let inputViewOne = NAAuthItemView()
    let resetPasswordButton = NAPrimaryButton(color: .systemPurple, title: "Reset Password", systemImageName: "")
    
    weak var delegate: NAForgotPasswordInputVCDelegate!

    init(delegate: NAForgotPasswordInputVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackgroundView()
        configureStackView()
        configureItems()
        configureButtons()
        layoutUI()
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureStackView() {
        inputStackView.addArrangedSubview(inputViewOne)
        inputStackView.axis = .vertical
        inputStackView.distribution = .fillProportionally
    }
    
    private func configureItems() {
        inputViewOne.set(authItemType: .email)
    }
    
    private func configureButtons() {
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    @objc func resetPasswordButtonTapped() {
        delegate.didTapResetPasswordButton()
    }
    
    private func layoutUI() {
        view.addSubview(inputStackView)
        view.addSubview(resetPasswordButton)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: view.topAnchor),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStackView.heightAnchor.constraint(equalToConstant: 60),
            
            resetPasswordButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 12),
            resetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
