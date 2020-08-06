//
//  ExploreDetailViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    let viewModel: PhotoDetailViewModel
    var collection: Collection!
    var tablieView = UITableView()

    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureNaviationBar()
        configureTableView()
        fetchCollections()
        bindViewModel()
    }
    
    func configureNaviationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "hello", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.title = " "
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes                   = [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        navBarAppearance.titleTextAttributes                        = [.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        navBarAppearance.backgroundColor                            = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.75)
        
        navigationController?.navigationBar.standardAppearance      = navBarAppearance
        navigationController?.navigationBar.compactAppearance       = navBarAppearance
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tablieView.reloadData()
        }
    }
    
    func fetchCollections() {
        viewModel.getPhotos(id: collection.id, totalPhotos: collection.totalPhotos)
    }
    
    func configureTableView() {
        view.addSubview(tablieView)
        tablieView.backgroundColor = .darkGray
        tablieView.delegate = self
        tablieView.dataSource = self
        tablieView.register(PhotoCell.self, forCellReuseIdentifier: "cell")
        tablieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PhotoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoCell
        let item = viewModel.photos[indexPath.row]
        cell?.backgroundColor = UIColor( named: item.color!)
        cell?.photoView.load(urlString: item.urls.full)
        cell?.authorLabel.text = item.user.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.photos[indexPath.row]
        let imageCrop = CGFloat( item.width!) / CGFloat(item.height!)
        return tableView.frame.width / imageCrop
    }
}
