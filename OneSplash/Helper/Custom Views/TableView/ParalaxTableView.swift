//
//  ParalaxTableView.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/18/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class ParalaxTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let header = tableHeaderView else { return }
        let offsetY = contentOffset.y
        header.alpha = (100 - offsetY) / 100
    }
}
