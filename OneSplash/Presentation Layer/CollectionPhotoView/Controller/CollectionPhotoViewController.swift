//
//  ExploreDetailViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CollectionPhotoViewController: PhotoShowerViewControllers {
    
// MARK: - Class Properties
    
    let viewModel: CollectionPhotoViewModel
    var collection: Collection!
    private var tableView = UITableView()
    
    var didSelectPhoto: (([Photo], Int) -> Void)?
    var didSelectUser: ((String) -> Void)?
    
// MARK: - Init
    
    init(viewModel: CollectionPhotoViewModel) {
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
        configureTableView()
        fetchCollections()
        configureNavBar()
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
        navigationItem.rightBarButtonItem   = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor   = .bcc
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.register(CollectionPhotoCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchCollections() {
        showLoadingView()
        viewModel.getCollectionPhotos(id: collection.id, totalPhotos: collection.totalPhotos)
    }

    private func configureNavBar() {
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .bcc, tintColor: .white, title: collection.title, preferredLargeTitle: false)
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: @objc functions
    
    @objc private func didTapUsername(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        didSelectUser?(username)
    }

    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [collection.links?.html as Any], applicationActivities: [])
        present(actionVC, animated: true)
    }
}

// MARK: - extension TableView (Delegate, DataSource)

extension CollectionPhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CollectionPhotoCell
        let item = viewModel.photos[indexPath.row]
        cell?.backgroundColor = UIColor( named: item.color ?? "")
        cell?.photoView.load(urlString: item.urls.small)
        cell?.button.setTitle(item.user.username, for: .normal)
        cell?.button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.photos[indexPath.row]
        let imageCrop = CGFloat(item.width) / CGFloat(item.height)
        return tableView.frame.width / imageCrop
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectPhoto?(viewModel.photos, indexPath.row)
    }
}
