//
//  PhotoShowerViewControllers.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/11/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

var containerView: UIView!
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
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor   = .bcc
        containerView.alpha             = 0

        UIView.animate(withDuration: 0.2) {
            containerView.alpha = 1
        }

        let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballRotate, color: .gray, padding: 0)
        containerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-110)
            make.width.height.equalTo(60)
        }
        activityIndicator.startAnimating()
    }
}
