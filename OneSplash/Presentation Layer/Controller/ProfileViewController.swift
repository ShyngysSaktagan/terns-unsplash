//
//  ProfileViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/15/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class ProfileViewController: PhotoShowerViewControllers {
    
    let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    func fetchViewModelDatas() {
//        showTableLoadView(in: self.tableView)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onceOnly = false
        start(tableView: self.tableView, section: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userPicture : UIImageView = {
        let imageView = UIImageView(cornerRadius: 16)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let usernameLabel = TitleLabel(textAlignment: .left, fontSize: 25, weight: .bold)
    let userlocationLabel = TitleLabel(textAlignment: .left, fontSize: 16, weight: .medium, color: .gray)
    let userURL = TitleLabel(textAlignment: .left, fontSize: 16, weight: .medium, color: .gray)
    
    let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Photo", "Likes", "Collections"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.selectedSegmentTintColor = .gray
        segmentController.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentController
    }()
    
    lazy var userLocationStackView: UIStackView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Symbols.pin)
        imageView.tintColor = .gray
        let stackView = UIStackView(arrangedSubviews: [imageView, userlocationLabel, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    @objc func handleSegmentChange() {
        tableView.reloadData()
    }
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bcc
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        configureUserLabels()
        configureTableView()
        fetchViewModelDatas()
        bindViewModel()
    }
    
    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [viewModel.user?.links?.html as Any], applicationActivities: [])
        present(actionVC, animated: true)
    }
    
    func configureUserLabels() {
        [userPicture, usernameLabel, userLocationStackView].forEach { view.addSubview($0) }
        
        userPicture.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
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

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "photos")
//        tableView.register(PhotosCell.self, forCellReuseIdentifier: "photos")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "collections")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userLocationStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func showEmptyStateView(with message: String, image: String, in view: UIView, tag: Int) {
        let emptyStateView  = EmptyStateView(message: message, logoImage: image)
        emptyStateView.tag = tag
        emptyStateView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height)
        emptyStateView.isUserInteractionEnabled = true
        view.addSubview(emptyStateView)
    }
    
    func removeSubViews(tags: [Int]) {
        for tag in tags {
            if let viewWithTag = tableView.viewWithTag(tag) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        removeSubViews(tags: [100,101,102])
        switch segmentController.selectedSegmentIndex {
        case 0:
            if viewModel.photos.isEmpty {
                let message = "No photos"
                self.showEmptyStateView(with: message, image: Symbols.emptyPhoto, in: self.tableView, tag: 100)
            }
            return viewModel.photos.count
        case 1:
            if viewModel.likes.isEmpty {
                let message = "No likes"
                self.showEmptyStateView(with: message, image: Symbols.emptyLike, in: self.tableView, tag: 101)
            }
            return viewModel.likes.count
        case 2:
            if viewModel.collections.isEmpty {
                let message = "No collections"
//                removeSubViews(tags: [0,1,2])
                self.showEmptyStateView(with: message, image: Symbols.emptyCollection, in: self.tableView, tag: 102)
            }
            return viewModel.collections.count
        default:
            return 0
        }
    }
    
    func checkLabels() {
        if userlocationLabel.text == nil {
            userLocationStackView.removeFromSuperview()
            tableView.removeFromSuperview()
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.equalTo(usernameLabel.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        userPicture.load(urlString: viewModel.user?.profileImage?.medium ?? "")
        usernameLabel.text = viewModel.user?.name
        userlocationLabel.text = viewModel.user?.location
//        userURL.text = viewModel.user?.portfolioUrl
        checkLabels()
        switch segmentController.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? PhotosCell
            let item = viewModel.photos[indexPath.row]
            cell?.photoView.load(urlString: item.urls.regular)
//            cell?.imageView?.contentMode = .scaleAspectFill
//            cell?.imageView?.image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: -10, right: 0))
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor(hexString: item.color!)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photos", for: indexPath) as? PhotosCell
            let item = viewModel.likes[indexPath.row]
            cell?.photoView.load(urlString: item.urls.regular)
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor(hexString: item.color!)
            cell?.button.setTitle(item.user.username, for: .normal)
            cell?.button.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
            tableContainerView = nil
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "collections", for: indexPath) as? CollectionViewCell
            let item = viewModel.collections[indexPath.row]
            cell?.titleLabel.text = item.title
            cell?.backgroudImage.load(urlString: item.coverPhoto.urls.regular)
            cell?.selectionStyle = .none
            cell?.backgroundColor = .clear
            tableContainerView = nil
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    @objc private func didTapNumber(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        let service = UnsplashService()
        let viewModel = ProfileViewModel(service: service, username: username)
        let profileVC = ProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(profileVC, animated: true)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
        let service = UnsplashService()
        let photoViewModel = PhotoViewModel(service: service)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        switch segmentController.selectedSegmentIndex {
        case 0:
            let item = viewModel.photos[indexPath.row]
            photoViewController.prifileName.setTitle(item.user.name, for: .normal)
            photoViewController.photos = viewModel.photos
            photoViewController.indexPathToScroll = indexPath.row
            photoViewController.modalPresentationStyle = .fullScreen
            photoViewController.photoStarterDelegate = self
            present(photoViewController, animated: true)
        case 1:
            let item = viewModel.likes[indexPath.row]
            photoViewController.prifileName.setTitle(item.user.name, for: .normal)
            photoViewController.photos = viewModel.likes
            photoViewController.indexPathToScroll = indexPath.row
            photoViewController.modalPresentationStyle = .fullScreen
            photoViewController.photoStarterDelegate = self
            present(photoViewController, animated: true)
        case 2:
            let photoDetailViewModel = PhotoDetailViewModel(service: service)
            let photoDetailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
            let item = viewModel.collections[indexPath.row]
            photoDetailViewController.collection = item
            photoDetailViewController.title = item.title
            navigationController?.pushViewController(photoDetailViewController, animated: true)
        default:
            print("sd")
        }
    }
}
