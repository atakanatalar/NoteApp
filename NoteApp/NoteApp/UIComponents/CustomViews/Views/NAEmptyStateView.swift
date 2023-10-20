//
//  NAEmptyStateView.swift
//  NoteApp
//
//  Created by Atakan Atalar on 20.10.2023.
//

import UIKit

class NAEmptyStateView: UIView {

    let messageLabel = NATitleLabel(textAlignment: .center, fontSize: 28)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    func configureMessageLabel() {
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
