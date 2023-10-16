//
//  NoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import UIKit

class NoteVC: UIViewController {
    
    let noteView = UIView()
    
    var noteVC: NANoteVC!
    
    var data: GetNoteDataClass!
    
    init(data: GetNoteDataClass) {
        super.init(nibName: nil, bundle: nil)
        
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
        KeyboardHelper.createDismissKeyboardTapGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureUIElements() {
        noteVC = NANoteVC(delegate: self)
        
        self.add(childVC: noteVC, to: self.noteView)
        
        noteVC.noteItemViewOne.textView.text = data.title
        noteVC.noteItemViewTwo.textView.text = data.note
    }
    
    func layoutUI() {
        view.addSubview(noteView)
        
        noteView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            noteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            noteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            noteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension NoteVC: NANoteVCDelegate {
    func didTapSaveNoteButton() {
        print("Save button tapped")
    }
}
