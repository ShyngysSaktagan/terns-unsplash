//
//  AppHeaderCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class AppsHeaderCell: UICollectionViewCell {

    let imageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configureImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
