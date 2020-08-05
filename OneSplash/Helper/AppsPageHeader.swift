//
//  AppsPageHeader.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class AppsPageHeader: UICollectionReusableView {

    let appHeaderHorizontalController = AppsHeaderHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(appHeaderHorizontalController.view)
        appHeaderHorizontalController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
