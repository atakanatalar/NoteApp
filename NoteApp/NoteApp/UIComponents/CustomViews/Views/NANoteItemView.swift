//
//  NANoteItemView.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

enum NoteItemType {
    case title, note
}

class NANoteItemView: UIView {

    let textView = NATextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func set(noteItemType: NoteItemType) {
        switch noteItemType {
        case .title:
            textView.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            textView.textColor = .label
            
            textView.isScrollEnabled = false
            textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        case .note:
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            textView.textColor = .label
            
            textView.isScrollEnabled = true
            textView.setContentHuggingPriority(.defaultLow, for: .vertical)
            textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
        }
    }

}
