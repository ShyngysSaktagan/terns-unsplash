//
//  PhotoShowerViewControllers.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/11/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class PhotoShowerViewControllers: UIViewController, PhotoStarter {
    func startAt(indexPath: Int) {
        indexPathToStart = indexPath
    }
    
    var onceOnly = false
    var indexPathToStart: Int?

    func start(tableView: UITableView) {
        if !onceOnly {
            let indexPath = IndexPath(row: indexPathToStart ?? 0, section: 1)
            if (tableView.numberOfSections > indexPath.section && tableView.numberOfRows(inSection: indexPath.section) > indexPath.row ) {
                tableView.scrollToRow(at: IndexPath(row: indexPathToStart ?? 0, section: 1), at: .top, animated:false)
            }
        }
    }
}
