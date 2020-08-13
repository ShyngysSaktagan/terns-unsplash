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
    
    let viewModel: PhotoViewModel
    var photos: [Photo]!
    var indexPathToScroll: Int?
    var indexPathToEnd: Int?
    var photoStarterDelegate: PhotoStarter!
    var onceOnly = false
    var currentPhoto = UIImageView()
    let infoView = InfoView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 350))
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var blackBackgroundView : UIView = {
        let black = UIView()
        black.frame = UIScreen.main.bounds
        black.backgroundColor = UIColor.black
        return black
    }()
    
    let photoAuthor: UILabel = {
        let author = UILabel()
        author.font = .systemFont(ofSize: 20, weight: .black)
        author.textColor = .white
        author.textAlignment = .center
        return author
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Symbols.exit), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return button
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Symbols.share), for: .normal)
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
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.backgroundColor = .white
        button.tintColor = .black
        button.setImage(UIImage(systemName: Symbols.save), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height / 2.0
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(systemName: Symbols.info), for: .normal)
        return button
    }()
    
    @objc func showInfo() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.infoView.transform = CGAffineTransform(translationX: 0, y: -350)
            self?.animationss()
        }
    }
    
    @objc func save() {
        guard let imageToSave = currentPhoto.image else {return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
    
    @objc func exit() {
        self.photoStarterDelegate.startAt(indexPath: self.indexPathToEnd ?? 0)
        dismiss(animated: true) {
            print(self.indexPathToEnd ?? 0)
        }
    }
    
    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [currentPhoto.image!], applicationActivities: [])
        present(actionVC, animated: true)
    }
    
    let collectionView: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(60)
        }
    }
    
    func configureInfoButton() {
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(40)
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
        configureInfoButton()
        configureInfoView()
        
    }
    
    func configureInfoView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGasture(_:)))
        infoView.dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        infoView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.isPagingEnabled = true
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
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell
        let item = photos[indexPath.row]
        cell?.imageView.load(urlString: item.urls.thumb)
        infoView.addInfo(of: item)
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var currentIndex = 0
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                currentIndex = indexPath.dropFirst()[0]
            }
        }
        
        let item = photos[currentIndex]
        fetchPhotoData(id: item.id)
        guard let photoInfo = viewModel.photo else {
            return
        }
        infoView.addInfo(of: photoInfo)
        currentPhoto.load(urlString: item.urls.small)
        photoAuthor.text = item.user.name
        indexPathToEnd = currentIndex
    }
    
    func fetchPhotoData(id: String) {
        viewModel.getPhoto(id: id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: indexPathToScroll ?? 0, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
    
    @objc private func handlePanGasture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: infoView)
            let yPosition = infoView.center.y + translation.y
            if yPosition < UIScreen.main.bounds.height / 2 + 80 {
                infoView.center = CGPoint(x: infoView.center.x, y: yPosition)
            }
            sender.setTranslation(.zero, in: view)
        case .ended:
            if sender.velocity(in: view).y > 400 {
                didTapDismissButton()
            }
        default: break
        }
    }
    
    @objc private func didTapDismissButton() {

        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.infoView.transform = .identity
            self?.blackBackgroundView.alpha = 0
        }, completion: { _ in
            self.blackBackgroundView.removeFromSuperview()
            self.infoView.removeFromSuperview()
            self.view.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
        })
    }
    
    func animationss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
        blackBackgroundView.alpha = 0
        view.addSubview(blackBackgroundView)
        view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
            self.blackBackgroundView.alpha = 0.5
            }, completion: nil)
        
    }
    
    @objc func zoomOut() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.blackBackgroundView.alpha = 0
            self.infoView.transform = .identity
        }, completion: { _ in
            self.blackBackgroundView.removeFromSuperview()
            self.infoView.removeFromSuperview()
            self.view.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
        })
    }
}
