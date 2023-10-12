//
//  NAAuthHeaderVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class NAAuthHeaderVC: UIViewController {

    let titleLabel = NATitleLabel(textAlignment: .center, fontSize: 34)
    let secondaryTitleLabel = NASecondaryTitleLabel(textAlignment: .center, fontSize: 18)
    
    init(titleLabelText: String, secondaryTitleLabelText: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = titleLabelText
        self.secondaryTitleLabel.text = secondaryTitleLabelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
    }
    
    func layoutUI() {
        view.addSubview(titleLabel)
        view.addSubview(secondaryTitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),
            
            secondaryTitleLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            secondaryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondaryTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondaryTitleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
