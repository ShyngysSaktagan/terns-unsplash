//
//  ExploreDetailViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

var containerView: UIView!

class PhotoDetailViewController: UIViewController {
    
    let viewModel: PhotoDetailViewModel
    var collection: Collection!
    var tableView = UITableView()
    var onceOnly = false
    var indexPathToStart: Int?

    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bcc
        configureNavBar()
        configureTableView()
        fetchCollections()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("start \(indexPathToStart ?? 0)")
        onceOnly = false

        if !onceOnly {
            let indexPath = IndexPath(row: indexPathToStart ?? 0, section: 1)
            if (self.tableView.numberOfSections > indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >  indexPath.row ) {
                self.tableView.scrollToRow(at: IndexPath(row: indexPathToStart ?? 0, section: 1), at: .top, animated: false)
            }
        }

        print("end")
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func fetchCollections() {
        showLoadingView()
        viewModel.getCollectionPhotos(id: collection.id, totalPhotos: collection.totalPhotos)
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor   = .bcc
        containerView.alpha             = 0

        UIView.animate(withDuration: 0.2) {
            containerView.alpha = 0.5
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
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .bcc
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavBar() {
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .bcc, tintColor: .white, title: collection.title, preferredLargeTitle: false)
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroud = UIView()
    var photoView: UIImageView?
    let navBarCover = UIView()
    
    func animate(photoView: UIImageView) {
        self.photoView = photoView
        if let startingFrame = photoView.superview?.convert(photoView.frame, to: nil) {
            
            photoView.alpha = 0
            blackBackgroud.backgroundColor = .bcc
            blackBackgroud.frame = view.frame
            blackBackgroud.alpha = 0
            view.addSubview(blackBackgroud)
            
            navBarCover.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
            navBarCover.backgroundColor = .bcc
            navBarCover.alpha = 0
            view.addSubview(navBarCover)
            
            zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width, height:startingFrame.height)
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = photoView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            zoomImageView.backgroundColor = .red
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75) {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let yValue = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: yValue, width: self.view.frame.width, height: height)
                self.navBarCover.alpha = 1
                self.blackBackgroud.alpha = 1
            }
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = photoView!.superview?.convert(photoView!.frame, to: nil) {
            UIView.animate(withDuration: 0.75, animations: {
                self.zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width,height: startingFrame.height)
                self.blackBackgroud.alpha = 0
                self.navBarCover.alpha = 0
            }, completion: { _ in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroud.removeFromSuperview()
                self.navBarCover.removeFromSuperview()
                self.photoView?.alpha = 1
            })
        }
    }
}

extension PhotoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotosCell
        let item = viewModel.photos[indexPath.row]
        cell?.backgroundColor = UIColor( named: item.color!)
        cell?.photoView.load(urlString: item.urls.thumb)
        cell?.authorLabel.text = item.user.name
        cell?.feedController2 = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.photos[indexPath.row]
        let imageCrop = CGFloat( item.width!) / CGFloat(item.height!)
        return tableView.frame.width / imageCrop
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController()
        photoViewController.photos = viewModel.photos
        photoViewController.indexPathToScroll = indexPath.row
        photoViewController.modalPresentationStyle = .fullScreen
        photoViewController.photoStarterDelegate = self
        present(photoViewController, animated: true)
    }
}

extension PhotoDetailViewController: PhotoStarter {
    func startAt(indexPath: Int) {
        indexPathToStart = indexPath
    }
}
