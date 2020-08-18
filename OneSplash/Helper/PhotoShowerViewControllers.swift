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

class PhotoShowerViewControllers: UIViewController {
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
    
    func showEmptyStateView(with message: String, image: String, in view: UIView, tag: Int) {
        let emptyStateView  = EmptyStateView(message: message, logoImage: image)
        emptyStateView.tag = tag
        emptyStateView.frame = CGRect(x: 0, y: 250, width: view.frame.width, height: view.frame.height - 350)
        emptyStateView.isUserInteractionEnabled = true
        view.addSubview(emptyStateView)
    }
    
    func removeSubViews(tags: [Int], for tableView: UITableView) {
        for tag in tags {
            if let viewWithTag = tableView.viewWithTag(tag) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
}
