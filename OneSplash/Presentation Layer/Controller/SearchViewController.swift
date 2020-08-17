//
//  SearchViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class SearchViewController: PhotoShowerViewControllers {
    
    let viewModel: SearchViewModel
    
    private lazy var segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Photo", "Collections", "Users"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.selectedSegmentTintColor = .gray
        segmentController.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "photos")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "collections")
        tableView.register(UserCell.self, forCellReuseIdentifier: "users")
//        tableView.tableFooterView = UIView()
        return tableView
    }()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    @objc func handleSegmentChange() {
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .bcc
        view.backgroundColor = .bcc
        [segmentController, tableView].forEach { view.addSubview($0) }
        segmentController.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(8)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
//    func showEmptyStateView(with message: String, image: String, in view: UIView, tag: Int) {
//        let emptyStateView  = EmptyStateView(message: message, logoImage: image)
//        emptyStateView.tag = tag
//        emptyStateView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height)
//        emptyStateView.isUserInteractionEnabled = true
//        view.addSubview(emptyStateView)
//    }
//
//    func removeSubViews(tags: [Int]) {
//        for tag in tags {
//            if let viewWithTag = tableView.viewWithTag(tag) {
//                viewWithTag.removeFromSuperview()
//            }
//        }
//    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        removeSubViews(tags: [100,101,102])
        switch segmentController.selectedSegmentIndex {
        case 0:
//            if viewModel.photos.isEmpty {
//                let message = "No photos"
//                self.showEmptyStateView(with: message, image: Symbols.emptyPhoto, in: self.tableView, tag: 100)
//            }
            print(viewModel.photos.count)
            return viewModel.photos.count
        case 1:
//            if viewModel.users.isEmpty {
//                let message = "No Users"
//                self.showEmptyStateView(with: message, image: Symbols.emptyLike, in: self.tableView, tag: 101)
//            }
            print(viewModel.collections.count)
            return viewModel.collections.count
            
        case 2:
//            if viewModel.collections.isEmpty {
//                let message = "No collections"
//                self.showEmptyStateView(with: message, image: Symbols.emptyCollection, in: self.tableView, tag: 102)
//            }
            print(viewModel.users.count)
            return viewModel.users.count
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentController.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? PhotosCell
            let item = viewModel.photos[indexPath.row]
            cell?.photoView.load(urlString: item.urls.regular)
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor(hexString: item.color!)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "collections", for: indexPath) as? CollectionViewCell
            let item = viewModel.collections[indexPath.row]
            cell?.titleLabel.text = item.title
            cell?.backgroudImage.load(urlString: item.coverPhoto.urls.thumb)
            cell?.selectionStyle = .none
            cell?.backgroundColor = .clear
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? UserCell
            let item = viewModel.users[indexPath.row]
            cell?.profileImage.load(urlString: item.profileImage?.large ?? "")
            cell?.nameLabel.text = item.name
            cell?.usernameLabel.text = item.username
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segmentController.selectedSegmentIndex {
        case 0:
            let item = viewModel.photos[indexPath.row]
            let imageCrop = CGFloat( item.width) / CGFloat(item.height)
            return tableView.frame.width / imageCrop
        case 1:
            return 250
        case 2:
            return 100
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = UnsplashService()
        let photoViewModel = PhotoViewModel(service: service)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        switch segmentController.selectedSegmentIndex {
        case 0:
            let item = viewModel.photos[indexPath.row]
//            photoViewController.prifileName.setTitle(item.user.name, for: .normal)
            photoViewController.title = item.user.name
            photoViewController.photos = viewModel.photos
            photoViewController.indexPathToScroll = indexPath.row
            photoViewController.modalPresentationStyle = .fullScreen
//            photoViewController.photoStarterDelegate = self
            present(photoViewController, animated: true)
        case 1:
            let photoDetailViewModel = PhotoDetailViewModel(service: service)
            let photoDetailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
            let item = viewModel.collections[indexPath.row]
            photoDetailViewController.collection = item
            photoDetailViewController.title = item.title
            presentedViewController?.navigationController?.pushViewController(photoDetailViewController, animated: true)
//            presentingViewController.navigationController.p
//            navigationController?.pushViewController(photoDetailViewController, animated: true)
        case 2:
            let item        = viewModel.users[indexPath.row]
            let username    = item.username
            let service     = UnsplashService()
            let viewModel   = ProfileViewModel(service: service, username: username)
            let profileVC   = ProfileViewController(viewModel: viewModel)
            navigationController?.pushViewController(profileVC, animated: true)
        default:
            print("sd")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        tableView.reloadData()
        viewModel.searchText = text
        viewModel.searchPhotos(query: text)
        viewModel.searchCollections(query: text)
        viewModel.searchUsers(query: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        viewModel.searchPhotos(query: "Hello")
        viewModel.searchCollections(query: "Hello")
        viewModel.searchUsers(query: "Hello")
        tableView.reloadData()
//        return cell!
    }
}
