//
//  NATextView.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

class NATextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func configure() {
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}
