//
//  NAAuthItemView.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

enum AuthItemType {
    case name, email, password
}

class NAAuthItemView: UIView {

    let textField = NATextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    func set(authItemType: AuthItemType) {
        switch authItemType {
        case .name:
            textField.placeholder = "Name"
        case .email:
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        case .password:
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
    }
}
