//
//  TitleLabel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/12/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight = .light,
         text: String = "", color: UIColor = .white) {
        super.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.text           = text
        self.font           = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor      = color
        configure()
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
