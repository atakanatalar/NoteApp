//
//  NANoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

protocol NANoteVCDelegate: AnyObject {}

class NANoteVC: UIViewController {
    
    let stackView = UIStackView()
    
    let noteItemViewOne = NANoteItemView()
    let noteItemViewTwo = NANoteItemView()
    
    weak var delegate: NANoteVCDelegate!
    
    init(delegate: NANoteVCDelegate) {
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
        layoutUI()
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(noteItemViewOne)
        stackView.addArrangedSubview(noteItemViewTwo)
        stackView.axis = .vertical
        stackView.distribution = .fill
    }
    
    private func configureItems() {
        noteItemViewOne.set(noteItemType: .title)
        noteItemViewTwo.set(noteItemType: .note)
    }
    
    private func layoutUI() {
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
