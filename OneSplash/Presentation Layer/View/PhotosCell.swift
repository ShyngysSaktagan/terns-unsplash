//
//  PhotoCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class PhotosCell: UITableViewCell {
    
    var feedController1: MainScreenViewController?
    var feedController2: PhotoDetailViewController?
    
    @objc func animate() {
        print("hello2")
        guard feedController1 != nil else {
            feedController2?.animate(photoView: photoView)
            return
        }
        feedController1?.animate(photoView: photoView)
    }
    
    let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.isUserInteractionEnabled = true
        photoView.layer.masksToBounds = true
//        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
//        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(16)
        }
    }
}
