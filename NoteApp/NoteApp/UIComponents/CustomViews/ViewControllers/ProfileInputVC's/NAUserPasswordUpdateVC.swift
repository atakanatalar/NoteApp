//
//  NAUserPasswordUpdateVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import UIKit

protocol NAUserPasswordUpdateVCDelegate: AnyObject {
    func didTapPasswordSaveButton()
}

class NAUserPasswordUpdateVC: UIViewController {
    
    let inputStackView = UIStackView()
    let descriptionLabel = NABodyLabel(textAlignment: .center)
    let inputViewOne = NAAuthItemView()
    let inputViewTwo = NAAuthItemView()
    let inputViewThree = NAAuthItemView()
    let saveButton = NAPrimaryButton(color: .systemPurple, title: "Save Password", systemImageName: "")
    
    weak var delegate: NAUserPasswordUpdateVCDelegate!
    
    init(descriptionLabelText: String, delegate: NAUserPasswordUpdateVCDelegate) {
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
    }
    
    private func configureItems() {
        inputViewOne.set(authItemType: .password)
        inputViewTwo.set(authItemType: .password)
        inputViewThree.set(authItemType: .password)
        
        inputViewOne.textField.placeholder = "Password"
        inputViewTwo.textField.placeholder = "New Password"
        inputViewThree.textField.placeholder = "Confirm Password"
    }
    
    private func configureButtons() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        delegate.didTapPasswordSaveButton()
    }
    
    private func layoutUI() {
        view.addSubview(descriptionLabel)
        view.addSubview(inputStackView)
        view.addSubview(saveButton)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            inputStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputStackView.heightAnchor.constraint(equalToConstant: 180),
            
            saveButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: padding),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
