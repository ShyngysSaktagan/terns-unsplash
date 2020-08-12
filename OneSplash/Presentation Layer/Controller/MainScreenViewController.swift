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

class MainScreenViewController: PhotoShowerViewControllers {
    
    let mainViewViewModel : MainViewViewModel
    let photoViewModel : PhotoDetailViewModel
    let tableView = UITableView()
    let sectionTypes   = [ "Explore", "New" ]
    
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
//        print("start MainVC from -> \(indexPathToStart ?? 0)")
        onceOnly = false
        start(tableView: self.tableView)
//        print("end")
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if !photoViewModel.isRequestPerforming && offsetY > contentHeight - height {
            photoViewModel.page += 1
            showLoadingView()
            fetchPhotos()
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
            cell?.backgroundColor = UIColor( named: item.color ?? "")
            cell?.photoView.load(urlString: item.urls.thumb)
            cell?.authorLabel.text = item.user.name 
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else {
            let item = photoViewModel.photos[indexPath.row]
            let imageCrop = CGFloat( item.width) / CGFloat(item.height)
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
        let item = photoViewModel.photos[indexPath.row]
        let photoViewController = PhotoViewController()
        photoViewController.photos = photoViewModel.photos
        photoViewController.indexPathToScroll = indexPath.row
        photoViewController.modalPresentationStyle = .fullScreen
        photoViewController.photoStarterDelegate = self
        photoViewController.photoAuthor.text = item.user.name
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
        cell?.imageView.load(urlString: item.coverPhoto.urls.thumb)
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
