//
//  NoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import UIKit
import IQKeyboardManagerSwift

class NoteVC: NADataLoadingVC {
    
    let noteView = UIView()
    
    var noteVC: NANoteVC!
    
    var data: GetNoteDataClass!
    
    var favoriteNotes: [GetNoteDataClass]!
    var isFavoriteNote: Bool!
    
    var favoriteNoteButton : UIBarButtonItem!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureAppearNavigationController()
        favoriteNoteCheck()
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureAppearNavigationController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        favoriteNoteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteNoteButtonTapped))
        let saveNoteButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveNoteButtonTapped))
        
        navigationItem.rightBarButtonItems = [saveNoteButton, favoriteNoteButton]
    }
    
    func configureUIElements() {
        noteVC = NANoteVC(delegate: self)
        
        noteVC.noteItemViewOne.textView.delegate = self
        noteVC.noteItemViewTwo.textView.delegate = self
        
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
    
    func favoriteNoteCheck() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favoriteNotes):
                self.favoriteNotes = favoriteNotes
                
                for noteData in favoriteNotes {
                    if noteData.id == data.id {
                        isFavoriteNote = true
                        favoriteNoteButton.image = UIImage(systemName: "star.fill")
                        return
                    } else {
                        isFavoriteNote = false
                        favoriteNoteButton.image = UIImage(systemName: "star")
                    }
                }
            case .failure(let error):
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
            }
            
            if self.favoriteNotes.isEmpty {
                isFavoriteNote = false
                favoriteNoteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    @objc func favoriteNoteButtonTapped() {
        if isFavoriteNote {
            let favoriteNote = GetNoteDataClass(title: data.title, note: data.note, id: data.id)
            
            PersistenceManager.updateWith(favoriteNote: favoriteNote, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                
                guard let error = error else {
                    favoriteNoteButton.image = UIImage(systemName: "star")
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Successfully removed from favorites 🫡")
                    isFavoriteNote = false
                    return
                }
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
            }
        } else {
            let favoriteNote = GetNoteDataClass(title: data.title, note: data.note, id: data.id)
            
            PersistenceManager.updateWith(favoriteNote: favoriteNote, actionType: .add) { [weak self] error in
                guard let self = self else { return }
                
                guard let error = error else {
                    favoriteNoteButton.image = UIImage(systemName: "star.fill")
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Succesfully added to favorites 🤩")
                    isFavoriteNote = true
                    return
                }
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
            }
        }
    }
    
    @objc func saveNoteButtonTapped() {
        KeyboardHelper.closeKeyboard(view: view)
        
        guard let title = noteVC.noteItemViewOne.textView.text,
              let note = noteVC.noteItemViewTwo.textView.text else { return }
        
        if noteVC.noteItemViewOne.textView.textColor == .secondaryLabel || noteVC.noteItemViewTwo.textView.textColor == .secondaryLabel {
            ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "The fields are required.")
            return
        }
        
        showLoadingView()
        
        let updateModel = UpdateNoteModel(title: title, note: note)
        
        APIManager.sharedInstance.callingUpdateNoteAPI(noteId: data.id, updateNoteModel: updateModel) { [weak self] isSucces in
            guard let self = self else { return }
            
            if isSucces {
                let code = APIManager.sharedInstance.updateNoteResponse?.code
                let message = APIManager.sharedInstance.updateNoteResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Succesfully updated your note 🎉")
                    
                    if isFavoriteNote {
                        let favoriteNote = GetNoteDataClass(title: title, note: note, id: data.id)
                        
                        PersistenceManager.updateWith(favoriteNote: favoriteNote, actionType: .update) { [weak self] error in
                            guard let self = self else { return }
                            guard let error = error else { return }
                            ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
                        }
                    } else {}
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
    }
}

extension NoteVC: NANoteVCDelegate {}

extension NoteVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == noteVC.noteItemViewOne.textView {
                textView.text = "Enter your note title"
            } else {
                textView.text = "Enter your note"
            }
            textView.textColor = .secondaryLabel
        }
        textView.resignFirstResponder()
    }
}
