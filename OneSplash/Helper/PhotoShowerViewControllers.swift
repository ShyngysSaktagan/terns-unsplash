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

var tableContainerView: UIView!

class PhotoShowerViewControllers: UIViewController, PhotoStarter {
    func startAt(indexPath: Int) {
        indexPathToStart = indexPath
    }
    
    var onceOnly = false
    var indexPathToStart: Int?

    func start(tableView: UITableView, section: Int) {
        if !onceOnly {
            let indexPath = IndexPath(row: indexPathToStart ?? 0, section: section)
            if (tableView.numberOfSections > indexPath.section && tableView.numberOfRows(inSection: indexPath.section) > indexPath.row ) {
                tableView.scrollToRow(at: IndexPath(row: indexPathToStart ?? 0, section: section), at: .top, animated:false)
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
    
    func showTableLoadView(in table: UIView) {
        tableContainerView = UIView(frame: CGRect(x: 0, y: 50, width: table.frame.width, height: table.frame.height))
        table.addSubview(tableContainerView)
        tableContainerView.backgroundColor   = .bcc
        tableContainerView.alpha             = 0

        UIView.animate(withDuration: 0.2) {
            tableContainerView.alpha = 1
        }

        let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballRotate, color: .gray, padding: 0)
        tableContainerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-110)
            make.width.height.equalTo(60)
        }
        activityIndicator.startAnimating()
    }
    
    //    func showEmptyStateView(with message: String, image: String, in view: UIView) {
    //        let emptyStateView  = EmptyStateView(message: message, logoImage: image)
    //        emptyStateView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height)
    //        view.addSubview(emptyStateView)
    //    }
}
