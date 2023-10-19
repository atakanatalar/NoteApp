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
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.tintColor = .systemPurple
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveNoteButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveNoteButton))
        setToolbarItems([spaceItem, saveNoteButton, spaceItem], animated: true)
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
            noteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func saveNoteButton() {
        guard let title = noteVC.noteItemViewOne.textView.text,
              let note = noteVC.noteItemViewTwo.textView.text else { return }
        
        let updateModel = UpdateNoteModel(title: title, note: note)
        
        APIManager.sharedInstance.callingUpdateNoteAPI(noteId: data.id, updateNoteModel: updateModel) { [weak self] isSucces in
            guard let self = self else { return }
            
            if isSucces {
                let code = APIManager.sharedInstance.updateNoteResponse?.code
                let message = APIManager.sharedInstance.updateNoteResponse?.message
                
                if let message = message, let code = code {
                    print("code: \(code), message: \(message)")
                }
                
                if code == "common.success" {
                    print("updated")
                } else {
                    print("alert")
                }
            } else {
                print("failure")
            }
        }
    }
}

extension NoteVC: NANoteVCDelegate {}
