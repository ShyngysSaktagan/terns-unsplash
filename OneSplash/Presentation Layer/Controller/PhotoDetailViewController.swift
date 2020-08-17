//
//  ExploreDetailViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PhotoDetailViewController: PhotoShowerViewControllers {
    
    let viewModel: PhotoDetailViewModel
    var collection: Collection!
    var tableView = UITableView()
    
    var didSelectPhoto: (([Photo], Int) -> Void)?
    var didSelectUser: ((String) -> Void)?
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
        view.backgroundColor                = .bcc
        navigationItem.rightBarButtonItem   = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        configureNavBar()
        configureTableView()
        fetchCollections()
        bindViewModel()
    }

    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [collection.links?.html as Any], applicationActivities: [])
        present(actionVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onceOnly = false
        start(tableView: self.tableView, section: 0)
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

    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor   = .bcc
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavBar() {
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .bcc, tintColor: .white, title: collection.title, preferredLargeTitle: false)
    }
}

extension PhotoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotosCell
        let item = viewModel.photos[indexPath.row]
        cell?.backgroundColor = UIColor( named: item.color ?? "")
        cell?.photoView.load(urlString: item.urls.thumb)
        cell?.button.setTitle(item.user.username, for: .normal)
        cell?.button.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
        return cell!
    }
    
    @objc private func didTapNumber(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        didSelectUser?(username)
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
