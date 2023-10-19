//
//  NAProfileHeaderVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import UIKit

class NAProfileHeaderVC: UIViewController {
    
    let nameLabel = NATitleLabel(textAlignment: .left, fontSize: 34)
    let emailLabel = NASecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        layoutUI()
    }
    
    func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
    }
    
    func layoutUI() {
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
