//
//  MainScreenViewController.swift
//  OneSplash
//
//  Created by Terns on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class MainScreenViewController: UIViewController {
    
    let mainViewViewModel : MainViewViewModel
    let photoViewModel : PhotoDetailViewModel
    let tableView = UITableView()
    let sectionTypes   = [
        "Explore",
        "New"
    ]
    var onceOnly = false
    var indexPathToStart: Int?
    
    init(mainViewViewModel: MainViewViewModel, photoViewModel: PhotoDetailViewModel) {
        self.mainViewViewModel = mainViewViewModel
        self.photoViewModel = photoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        mainViewViewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
        photoViewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("start MainVC from -> \(indexPathToStart ?? 0)")
        
        onceOnly = false

        if !onceOnly {
            let indexPath = IndexPath(row: indexPathToStart ?? 0, section: 1)
            if (self.tableView.numberOfSections > indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >  indexPath.row ) {
                self.tableView.scrollToRow(at: IndexPath(row: indexPathToStart ?? 0, section: 1), at: .top, animated: false)
            }
        }

        print("end")
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
    
    func configureTableView() {
        view.addSubview(tableView)
        configureNavigationBar(largeTitleColor: .bcc, backgoundColor: .bcc, tintColor: .white, title: "", preferredLargeTitle: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ExploreCellTableCell.self, forCellReuseIdentifier: "exploreCell")
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "newCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .bcc
        super.viewDidLoad()
        
        configureTableView()
        fetchAll()
        bindViewModel()
    }
    
    func fetchAll() {
        showLoadingView()
        fetchCollections()
        fetchPhotos()
    }
    
    func fetchCollections() {
        mainViewViewModel.getCollections(page: mainViewViewModel.page)
    }
    
    func fetchPhotos() {
        photoViewModel.getNewPhotos(page: photoViewModel.page)
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
            
            zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width, height: startingFrame.height)
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = photoView.image
            zoomImageView.contentMode = .scaleAspectFill
//            zoomImageView.alpha = 0.4
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
                self.zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width, height: startingFrame.height)
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

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = {
            let label   = UILabel()
            label.text  = sectionTypes[section]
            label.font  = .systemFont(ofSize: 24)
            label.textColor = .white
            return label
        }()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .bcc
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return photoViewModel.photos.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as? ExploreCellTableCell
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as? PhotosCell
            let item = photoViewModel.photos[indexPath.row]
            cell?.backgroundColor = UIColor( named: item.color!)
            cell?.photoView.load(urlString: item.urls.small)
            cell?.authorLabel.text = item.user.name
            cell?.feedController1 = self 
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else {
            let item = photoViewModel.photos[indexPath.row]
            let imageCrop = CGFloat( item.width!) / CGFloat(item.height!)
            return tableView.frame.width / imageCrop
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = cell as? ExploreCellTableCell {
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected indexPath to PhotoVC ->\(indexPath.row)")
        let photoViewController = PhotoViewController()
        photoViewController.photos = photoViewModel.photos
        photoViewController.indexPathToScroll = indexPath.row
        photoViewController.modalPresentationStyle = .fullScreen
        photoViewController.photoStarterDelegate = self
        present(photoViewController, animated: true)
    }
}

extension MainScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewViewModel.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExploreCell
        let item = mainViewViewModel.collections[indexPath.row]
        if (indexPath.row+1) / mainViewViewModel.counting == 1 {
            print("hello")
            mainViewViewModel.page += 1
            mainViewViewModel.getCollections(page: mainViewViewModel.page)
            mainViewViewModel.counting += mainViewViewModel.constantCount
        }
        cell?.backgroundColor = UIColor( named: item.coverPhoto.color!)
        cell?.imageView.load(urlString: item.coverPhoto.urls.small)
        cell?.titleLabel.text = item.title
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = mainViewViewModel.collections[indexPath.row]
        let service = UnsplashService()
        let viewModel = PhotoDetailViewModel(service: service)
        let exploreDetailVC = PhotoDetailViewController(viewModel: viewModel)
        exploreDetailVC.collection = item
        exploreDetailVC.title = item.title
        navigationController?.pushViewController(exploreDetailVC, animated: true)
    }
}

extension MainScreenViewController: PhotoStarter {
    func startAt(indexPath: Int) {
        indexPathToStart = indexPath
    }
}

//  4 -> 5 -> 6
