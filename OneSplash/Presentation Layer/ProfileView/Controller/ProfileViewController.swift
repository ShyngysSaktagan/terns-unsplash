//
//  ProfileViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/15/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class ProfileViewController: PhotoShowerViewControllers {
    
    // MARK: - Class Properties
    
    let viewModel: ProfileViewModel
    private let tableView           = ParalaxTableView()
    private let tableViewHeader     = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 145))
    private let usernameLabel       = TitleLabel(textAlignment: .left, fontSize: 25, weight: .bold)
    private let userlocationLabel   = TitleLabel(textAlignment: .left, fontSize: 16, weight: .medium, color: .gray)
    private let userURL             = TitleLabel(textAlignment: .left, fontSize: 16, weight: .medium, color: .gray)
    
    var didSelectUser: ((String) -> Void)?
    var didSelectLike: (([Photo], Int) -> Void)?
    var didSelectCollection: (([Collection], Int) -> Void)?
    var didSelectPhoto: (([Photo], Int) -> Void)?
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Photo", "Likes", "Collections"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.selectedSegmentTintColor = .gray
        segmentController.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentController
    }()
        
    private let userPicture : UIImageView = {
        let imageView = UIImageView(cornerRadius: 16)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Symbols.pin)
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var userLocationStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [locationImageView, userlocationLabel, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bcc
        configureNavigationItem()
        configureHeaderView()
        fetchViewModelDatas()
        configureTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onceOnly = false
        start(tableView: self.tableView, section: 0)
    }
    
    // MARK: - Functions
    
    private func configureNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    private func configureHeaderView() {
        tableViewHeader.backgroundColor = .bcc
        [usernameLabel, userLocationStackView, userPicture].forEach { tableViewHeader.addSubview($0) }
        userPicture.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.height.width.equalTo(60)
        }
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(userPicture.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        userLocationStackView.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(15)
        }
    }
    
    private func fetchViewModelDatas() {
        viewModel.getUser()
        viewModel.getUserLikes()
        viewModel.getUserPhotos()
        viewModel.getUserCollections()
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CollectionPhotoCell.self, forCellReuseIdentifier: "photos")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "collections")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.tableHeaderView = tableViewHeader
    }
    
    func checkLabels() {
        if userlocationLabel.text == nil {
            userLocationStackView.removeArrangedSubview(userlocationLabel)
            userLocationStackView.removeArrangedSubview(locationImageView)
            userlocationLabel.isHidden = true
            locationImageView.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) else {
            return
        }
        switch segmentController.selectedSegmentIndex {
        case 0:
            if viewModel.isPhotosRequestPerforming {
                viewModel.getUserPhotos()
            }
        case 1:
            if viewModel.isCollectionRequestPerforming {
                viewModel.getUserCollections()
            }
        case 2:
            if viewModel.isLikesRequestPerforming {
                viewModel.getUserLikes()
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
    
    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [viewModel.user?.links?.html as Any], applicationActivities: [])
        present(actionVC, animated: true)
    }
}

// MARK: - extension TableView (Delegate, DataSource)

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        removeSubViews(tags: [100,101,102], for: self.tableView)
        switch segmentController.selectedSegmentIndex {
        case 0:
            if viewModel.photos.isEmpty {
                let message = EmptyMessage.emptyPhoto
                self.showEmptyStateView(with: message, image: Symbols.emptyPhoto, in: self.tableView, tag: 100)
            }
            return viewModel.photos.count
        case 1:
            if viewModel.likes.isEmpty {
                let message = EmptyMessage.emptyLike
                self.showEmptyStateView(with: message, image: Symbols.emptyLike, in: self.tableView, tag: 101)
            }
            return viewModel.likes.count
        case 2:
            if viewModel.collections.isEmpty {
                let message = EmptyMessage.emptyCollection
                self.showEmptyStateView(with: message, image: Symbols.emptyCollection, in: self.tableView, tag: 102)
            }
            return viewModel.collections.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        userPicture.load(urlString: viewModel.user?.profileImage?.medium ?? "")
        usernameLabel.text = viewModel.user?.name
        userlocationLabel.text = viewModel.user?.location
        checkLabels()
        switch segmentController.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? CollectionPhotoCell
            let item = viewModel.photos[indexPath.row]
            cell?.item = item
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? CollectionPhotoCell
            let item = viewModel.likes[indexPath.row]
            cell?.item = item
            cell?.button.setTitle(item.user.username, for: .normal)
            cell?.button.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "collections", for: indexPath) as? CollectionViewCell
            let item = viewModel.collections[indexPath.row]
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
            let item = viewModel.likes[indexPath.row]
            let imageCrop = CGFloat( item.width) / CGFloat(item.height)
            return tableView.frame.width / imageCrop
        case 2:
            return 250
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        headerView.addSubview(segmentController)
        
        segmentController.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            didSelectPhoto?(viewModel.photos, indexPath.row)
        case 1:
            didSelectLike?(viewModel.likes, indexPath.row)
        case 2:
            didSelectCollection?(viewModel.collections, indexPath.row)
        default:
            print("")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
