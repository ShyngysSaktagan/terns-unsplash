//
//  SearchViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class SearchViewController: PhotoShowerViewControllers {

// MARK: - Class Properties

    let viewModel: SearchViewModel
    var searchText = ""
    
    var didSelectUser: ((String) -> Void)?
    var didSelectCollection: (([Collection], Int) -> Void)?
    var didSelectPhoto: (([Photo], Int) -> Void)?
    
    private var segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Photo", "Collections", "Users"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.selectedSegmentTintColor = .gray
        segmentController.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentController
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CollectionPhotoCell.self, forCellReuseIdentifier: "photos")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "collections")
        tableView.register(UserCell.self, forCellReuseIdentifier: "users")
        return tableView
    }()

// MARK: - Init

    init(viewModel: SearchViewModel,
         didSelectUser: @escaping (String) -> Void,
         didSelectPhoto: @escaping ([Photo], Int) -> Void,
         didSelectCollection: @escaping ([Collection], Int) -> Void) {
        self.viewModel = viewModel
        self.didSelectUser = didSelectUser
        self.didSelectPhoto = didSelectPhoto
        self.didSelectCollection = didSelectCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - UIViewController Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
// MARK: - Functions
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .bcc
        view.backgroundColor = .bcc
        [segmentController, tableView].forEach { view.addSubview($0) }
        segmentController.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) else {
            return
        }
        switch segmentController.selectedSegmentIndex {
        case 0:
            if viewModel.isPhotosRequestPerforming {
                viewModel.searchPhotos(query: searchText)
            }
        case 1:
            if viewModel.isCollectionRequestPerforming {
                viewModel.searchCollections(query: searchText)
            }
        case 2:
            if viewModel.isUserRequestPerforming {
                viewModel.searchUsers(query: searchText)
            }
        default:
            print("")
        }
    }
    
// MARK: @objc functions
    
    @objc func handleSegmentChange() {
        tableView.reloadData()
    }
    
    @objc private func didTapNumber(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        didSelectUser?(username)
    }
}

// MARK: - extension TableView (Delegate, DataSource)

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        removeSubViews(tags: [100,101,102], for: self.tableView)
        switch segmentController.selectedSegmentIndex {
        case 0:
            if viewModel.photos.isEmpty {
                let message = EmptyMessage.emptyPhoto
                self.showEmptyStateView(with: message, image: Symbols.emptyPhoto, in: self.tableView, tag: 100)
            }
            print(viewModel.photos.count)
            return viewModel.photos.count
        case 1:
            if viewModel.users.isEmpty {
                let message = EmptyMessage.emptyCollection
                self.showEmptyStateView(with: message, image: Symbols.emptyCollection, in: self.tableView, tag: 101)
            }
            print(viewModel.collections.count)
            return viewModel.collections.count
            
        case 2:
            if viewModel.collections.isEmpty {
                let message = EmptyMessage.emptyUser
                self.showEmptyStateView(with: message, image: Symbols.emptyUser, in: self.tableView, tag: 102)
            }
            print(viewModel.users.count)
            return viewModel.users.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentController.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? CollectionPhotoCell
            let item = viewModel.photos[indexPath.row]
            cell?.button.setTitle(item.user.username, for: .normal)
            cell?.button.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
            cell?.item = item
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "collections", for: indexPath) as? CollectionViewCell
            let item = viewModel.collections[indexPath.row]
            cell?.item = item
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? UserCell
            let item = viewModel.users[indexPath.row]
            cell?.item = item
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
        switch segmentController.selectedSegmentIndex {
        case 0:
            didSelectPhoto?(viewModel.photos, indexPath.row)
        case 1:
            didSelectCollection?(viewModel.collections, indexPath.row)
        case 2:
            didSelectUser?(viewModel.users[indexPath.row].username)
        default:
            print("")
        }
    }
}

// MARK: - extension SearchBar (Delegate)

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        print("\(text) - \(searchText)")
        if text == "" {
            viewModel.photos = []
            viewModel.collections = []
            viewModel.users = []
            tableView.reloadData()
        }
        if searchText != text {
            searchText = text
            viewModel.photos = []
            viewModel.collections = []
            viewModel.users = []
            viewModel.usersCurrentPage = 1
            viewModel.collectionsCurrentPage = 1
            viewModel.usersCurrentPage = 1
            viewModel.searchPhotos(query: searchText)
            viewModel.searchCollections(query: searchText)
            viewModel.searchUsers(query: searchText)
            tableView.reloadData()
        }
    }
}
