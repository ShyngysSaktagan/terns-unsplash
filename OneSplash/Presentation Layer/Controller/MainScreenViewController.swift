//
//  MainScreenViewController.swift
//  OneSplash
//
//  Created by Terns on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    
    let viewModel : MainViewViewModel
    
    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchCollections()
        bindViewModel()
    }
    
    func fetchCollections() {
        viewModel.getCollections(page: viewModel.page)
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.width/2)
        }
    }

}

extension MainScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ExploreCell
        let item = viewModel.collections[indexPath.row]
        if (indexPath.row+1) / viewModel.counting == 1 {
            print("hello")
            viewModel.page += 1
            viewModel.getCollections(page: viewModel.page)
            viewModel.counting *= 2
        }
        cell?.backgroundColor = UIColor( named: item.coverPhoto.color!)
        cell?.imageView.load(urlString: item.coverPhoto.urls.full)
        cell?.titleLabel.text = item.title
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.collections[indexPath.row]
        let service = UnsplashService()
        let viewModel = PhotoDetailViewModel(service: service)
        let exploreDetailVC = PhotoDetailViewController(viewModel: viewModel)
        exploreDetailVC.collection = item
        exploreDetailVC.title = item.title
        navigationController?.pushViewController(exploreDetailVC, animated: true)
    }
}

//  4 -> 5 -> 6
