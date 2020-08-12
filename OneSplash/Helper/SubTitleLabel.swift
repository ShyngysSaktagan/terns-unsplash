//
//  SubTitleLabel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/12/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class SubTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, text: String) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        textColor                   = .white
        font                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75
        lineBreakMode               = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
