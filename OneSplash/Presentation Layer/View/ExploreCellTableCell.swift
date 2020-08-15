//
//  ExploreCellTableCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/8/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class ExploreCellTableCell: UITableViewCell {
    let collectionView: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bcc
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 8)
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: "cell")
        
//        collectionView.automaticallyAdjustsScrollViewInsets = false

        return collectionView
    }()
    
    let collectionView1: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bcc
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 8)
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
