//
//  NALoginInputVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

protocol NALoginInputVCDelegate: AnyObject {
    func didTapSignInButton()
    func didTapForgotPasswordButton()
    func didTapDescriptionButtonTapped()
}

class NALoginInputVC: UIViewController {

    let inputStackView = UIStackView()
    let inputViewOne = NAAuthItemView()
    let inputViewTwo = NAAuthItemView()
    let forgotPasswordButton = NASecondaryButton(color: .systemPurple, title: "Forgot Password?", systemImageName: "")
    let signInButton = NAPrimaryButton(color: .systemPurple, title: "Sign In", systemImageName: "")
    let descriptionStackView = UIStackView()
    let descriptionButton = NASecondaryButton(color: .systemPurple, title: "Sign up now", systemImageName: "")
    let descriptionLabel = NABodyLabel(textAlignment: .center)
    
    weak var delegate: NALoginInputVCDelegate!
    
    init(descriptionLabelText: String, delegate: NALoginInputVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.descriptionLabel.text = descriptionLabelText
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
        inputStackView.addArrangedSubview(inputViewTwo)
        inputStackView.axis = .vertical
        inputStackView.distribution = .fillProportionally
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionButton)
        descriptionStackView.axis = .horizontal
        descriptionStackView.distribution = .fill
        descriptionStackView.alignment = .center
    }
    
    private func configureItems() {
        inputViewOne.set(authItemType: .email)
        inputViewTwo.set(authItemType: .password)
    }
    
    private func configureButtons() {
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
    }
    
    @objc func forgotPasswordButtonTapped() {
        delegate.didTapForgotPasswordButton()
    }
    
    @objc func signInButtonTapped() {
        delegate.didTapSignInButton()
    }
    
    @objc func descriptionButtonTapped() {
        delegate.didTapDescriptionButtonTapped()
    }
    
    private func layoutUI() {
        view.addSubview(inputStackView)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(descriptionStackView)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: view.topAnchor),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStackView.heightAnchor.constraint(equalToConstant: 120),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 160),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 12),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            
            descriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionStackView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
