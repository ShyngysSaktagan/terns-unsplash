//
//  PhotoViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/9/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

protocol PhotoStarter {
    func startAt(indexPath: Int)
}

class PhotoViewController: UIViewController {
    
    var photos: [Photo]!
    var onceOnly = false
    var indexPathToScroll: Int?
    var indexPathToEnd: Int?
    var photoStarterDelegate: PhotoStarter!
    var photoForShare : UIImageView?
    
    let photoAuthor: UILabel = {
        let author = UILabel()
        author.text = "Hello"
        author.font = .systemFont(ofSize: 20, weight: .black)
        author.textColor = .white
        author.textAlignment = .center
        return author
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return button
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [exitButton, photoAuthor, actionButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        button.backgroundColor = .white
        button.tintColor = .black
        button.titleLabel?.textAlignment = .center
        
        button.translatesAutoresizingMaskIntoConstraints = true
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    @objc func save() {
    }
    
    @objc func exit() {
        self.photoStarterDelegate.startAt(indexPath: self.indexPathToEnd ?? 0)
        dismiss(animated: true) {
            print(self.indexPathToEnd ?? 0)
        }
    }
    
    @objc func share() {
        print("share")
        let actionVC = UIActivityViewController(activityItems: [photoForShare?.image ?? ""], applicationActivities: [])
        present(actionVC, animated: true)
    }
    
    let collectionView: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(80)
        }
        
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 2.0
        saveButton.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bcc
        configureStackView()
        configureCollectionView()
        configureSaveButton()
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("current index scrolled -> \(indexPath.row), start photoVC from -> \(indexPathToScroll ?? 0)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell
        let item = photos[indexPath.row]
        photoForShare?.load(urlString: item.urls.thumb)
        cell?.imageView.load(urlString: item.urls.thumb)
        photoAuthor.text = item.user.name
        indexPathToEnd = indexPath.row
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: indexPathToScroll ?? 0, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
}
