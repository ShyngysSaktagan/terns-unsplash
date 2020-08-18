//
//  ExploreCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class ExploreCell: UICollectionViewCell {
    
    private let cover: UIView = {
        let cover                   = UIView()
        cover.backgroundColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        cover.layer.cornerRadius    = 12
        return cover
    }()
    
    var imageView: UIImageView = {
        let imageView                   = UIImageView()
        imageView.contentMode           = .scaleAspectFill
        imageView.clipsToBounds         = true
        imageView.layer.masksToBounds   = true
        imageView.layer.cornerRadius    = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label       = UILabel()
        label.font      = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
