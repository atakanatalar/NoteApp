//
//  NARegisterInputVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

protocol NARegisterInputVCDelegate: AnyObject {
    func didTapSignUpButton()
    func didTapDescriptionButton()
}

class NARegisterInputVC: UIViewController {

    let inputStackView = UIStackView()
    let inputViewOne = NAAuthItemView()
    let inputViewTwo = NAAuthItemView()
    let inputViewThree = NAAuthItemView()
    let signUpButton = NAPrimaryButton(color: .systemPurple, title: "Sign Up", systemImageName: "")
    let descriptionStackView = UIStackView()
    let descriptionButton = NASecondaryButton(color: .systemPurple, title: "Sign in now", systemImageName: "")
    let descriptionLabel = NABodyLabel(textAlignment: .center)
    
    weak var delegate: NARegisterInputVCDelegate!
    
    init(descriptionLabelText: String, delegate: NARegisterInputVCDelegate) {
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
        inputStackView.addArrangedSubview(inputViewThree)
        inputStackView.axis = .vertical
        inputStackView.distribution = .fillProportionally
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionButton)
        descriptionStackView.axis = .horizontal
        descriptionStackView.distribution = .fill
        descriptionStackView.alignment = .center
    }
    
    private func configureItems() {
        inputViewOne.set(authItemType: .name)
        inputViewTwo.set(authItemType: .email)
        inputViewThree.set(authItemType: .password)
    }
    
    private func configureButtons() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
    }
    
    @objc func signUpButtonTapped() {
        delegate.didTapSignUpButton()
    }
    
    @objc func descriptionButtonTapped() {
        delegate.didTapDescriptionButton()
    }
    
    private func layoutUI() {
        view.addSubview(inputStackView)
        view.addSubview(signUpButton)
        view.addSubview(descriptionStackView)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: view.topAnchor),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStackView.heightAnchor.constraint(equalToConstant: 180),
            
            signUpButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 12),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            
            descriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionStackView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
