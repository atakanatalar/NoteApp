//
//  NANotesListCell.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import UIKit

class NANotesListCell: UITableViewCell {

    static let reuseID = "NANotesListCell"
    let noteTitleLabel = NATitleLabel(textAlignment: .left, fontSize: 18)
    let noteTextLabel = NASecondaryTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNotes(data: Datum) {
        noteTitleLabel.text = data.title
        noteTextLabel.text = data.note
    }
    
    func setFavoriteNotes(data: GetNoteDataClass) {
        noteTitleLabel.text = data.title
        noteTextLabel.text = data.note
    }
    
    func configureLabels() {
        addSubview(noteTitleLabel)
        addSubview(noteTextLabel)
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            noteTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,  constant: 30),
            noteTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: -30),
            noteTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            noteTextLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 2),
            noteTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            noteTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            noteTextLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }

}
