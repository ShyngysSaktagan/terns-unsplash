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
    
    let mainViewViewModel: MainScreenViewModel
    let photoViewModel: CollectionPhotoViewModel
    let searchViewModel: SearchViewModel
    var searchViewController: SearchViewController
    
    let tableView       = UITableView()
    let sectionTypes    = [ "Explore", "New" ]
    
    var didSelectUser: ((String) -> Void)?
    var didSelectCollection: (([Collection], Int) -> Void)?
    var didSelectPhoto: (([Photo], Int) -> Void)?
    
    init(mainViewViewModel: MainScreenViewModel,
         photoViewModel: CollectionPhotoViewModel,
         searchViewModel: SearchViewModel,
         didSelectUser: @escaping (String) -> Void,
         didSelectPhoto: @escaping (([Photo], Int) -> Void),
         didSelectCollection: @escaping (([Collection], Int) -> Void)) {
        self.mainViewViewModel  = mainViewViewModel
        self.photoViewModel     = photoViewModel
        self.searchViewModel    = searchViewModel
        self.didSelectUser      = didSelectUser
        self.didSelectPhoto     = didSelectPhoto
        self.didSelectCollection = didSelectCollection
        self.searchViewController    = SearchViewController(viewModel: searchViewModel,
                                        didSelectUser: didSelectUser, didSelectPhoto: didSelectPhoto, didSelectCollection: didSelectCollection)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        let searchController                = UISearchController(searchResultsController: searchViewController)
        searchController.searchBar.delegate = searchViewController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.showsSearchResultsController = true
        return searchController
    }()
    
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
        onceOnly = false
        start(tableView: self.tableView, section: 1)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        configureNavigationBar(largeTitleColor: .bcc, backgoundColor: .bcc, tintColor: .white, title: "", preferredLargeTitle: false)
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.backgroundColor   = .clear
        tableView.register(ExploreCellTableCell.self, forCellReuseIdentifier: "exploreCell")
        tableView.register(CollectionPhotoCell.self, forCellReuseIdentifier: "newCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .bcc
        super.viewDidLoad()
        setupNavigationBar()
        configureTableView()
        fetchAll()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        definesPresentationContext      = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func fetchAll() {
        showLoadingView()
        fetchCollections()
        fetchPhotos()
    }
    
    func fetchCollections() {
        mainViewViewModel.getCollections()
    }
    
    func fetchPhotos() {
        photoViewModel.getNewPhotos()
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
        let label = TitleLabel(textAlignment: .right, fontSize: 24, weight: .regular, color: .white)
        let headerView              = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor  = .bcc
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
            let cell                = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as? CollectionPhotoCell
            let item                = photoViewModel.photos[indexPath.row]
            
            cell?.photoView.load(urlString: item.urls.thumb)
            cell?.button.setTitle(item.user.username, for: .normal)
            cell?.backgroundColor   = UIColor(hexString: item.color!)
            cell?.button.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
            return cell!
        }
    }
    
    @objc private func didTapNumber(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        didSelectUser?(username)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else {
            let item        = photoViewModel.photos[indexPath.row]
            let imageCrop   = CGFloat( item.width) / CGFloat(item.height)
            return tableView.frame.width / imageCrop
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = cell as? ExploreCellTableCell {
                cell.collectionView.dataSource  = self
                cell.collectionView.delegate    = self
                cell.collectionView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectPhoto?(photoViewModel.photos, indexPath.row)
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
            mainViewViewModel.page += 1
            mainViewViewModel.getCollections()
            mainViewViewModel.counting += mainViewViewModel.constantCount
        }
        
        cell?.backgroundColor = UIColor(hexString: item.coverPhoto.color!)
        cell?.layer.cornerRadius = 12
        cell?.imageView.load(urlString: item.coverPhoto.urls.thumb)
        cell?.titleLabel.text = item.title
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectCollection?(mainViewViewModel.collections, indexPath.row)
    }
}
