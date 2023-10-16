//
//  NAAddNoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

protocol NAAddNoteVCDelegate: AnyObject {
    func didTapAddNoteButton()
}

class NAAddNoteVC: UIViewController {
    
    let stackView = UIStackView()
    
    let noteItemViewOne = NANoteItemView()
    let noteItemViewTwo = NANoteItemView()
    
    let addNoteButton = NAPrimaryButton(color: .systemPurple, title: "Add Note", systemImageName: "plus")
    
    weak var delegate: NAAddNoteVCDelegate!
    
    init(delegate: NAAddNoteVCDelegate) {
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
        configureButton()
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
        
        noteItemViewOne.textView.text = "Enter your note title"
        noteItemViewTwo.textView.text = "Enter your note"
    }
    
    private func configureButton() {
        addNoteButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
    }
    
    @objc func addNoteButtonTapped() {
        delegate.didTapAddNoteButton()
    }
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(addNoteButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNoteButton.widthAnchor.constraint(equalToConstant: 200),
            addNoteButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
