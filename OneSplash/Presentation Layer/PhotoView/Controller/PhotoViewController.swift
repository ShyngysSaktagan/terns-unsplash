//
//  PhotoViewController.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/9/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class PhotoViewController: UIViewController {
    
// MARK: - Class Properties
    
    let viewModel: PhotoViewModel
    var photos: [Photo]!
    var indexPathToScroll: Int?
    var indexPathToEnd: Int?
    private var onceOnly        = false
    private var currentPhoto    = UIImageView()
    
    var didExitClicked: ((Int) -> Void)?
    var didSelectUser: ((String) -> Void)?
    
    let titleButton = CustomButton(backgroundColor: .bcc, title: "", tintColor: .white)
    private let infoButton  = CustomButton(backgroundColor: .clear, title: "", tintColor: .white)
    private let saveButton  = CustomButton(backgroundColor: .white, title: "", tintColor: .black)
    private let infoView    = InfoView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 800))
    
    private var blackBackgroundView : UIView = {
        let black = UIView()
        black.frame = UIScreen.main.bounds
        black.backgroundColor = UIColor.black
        return black
    }()
    
    private let collectionView: UICollectionView = {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
// MARK: - Init
    
    init(viewModel: PhotoViewModel) {
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
        configureCollectionView()
        configureInfoView()
        configureButtons()
    }
    
// MARK: - Functions
    
    private func configureNavigationItem() {
        navigationItem.titleView = titleButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(
            systemName: Symbols.exit), style: .plain, target: self, action: #selector(exit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configureInfoView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGasture(_:)))
        infoView.dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        infoView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func configureButtons() {
        [infoButton, saveButton].forEach { view.addSubview($0) }
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        infoButton.setImage(UIImage(systemName: Symbols.info), for: .normal)
        
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.setImage(UIImage(systemName: Symbols.save), for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(60)
        }
        
        infoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(40)
        }
    }
    
    private func fetchPhotoData(id: String) {
        viewModel.getPhoto(id: id)
    }
    
    // MARK: @objc functions
    
    @objc func showInfo() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.infoView.transform = CGAffineTransform(translationX: 0, y: -InfoView.height)
            self?.animations()
        }
    }
    
    @objc func save() {
        guard let imageToSave = currentPhoto.image else {return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
    
    @objc func exit() {
        print(self.indexPathToEnd ?? 0)
        didExitClicked?(self.indexPathToEnd ?? 0)
    }
    
    @objc func share() {
        let actionVC = UIActivityViewController(activityItems: [viewModel.photo?.links?.html ?? ""], applicationActivities: [])
        present(actionVC, animated: true)
    }
    
    @objc private func didTapNumber(_ sender: UIButton) {
        let username = (sender.titleLabel?.text ?? "").lowercased()
        print(username)
        didSelectUser?(username)
    }
}

// MARK: - extension CollectionView (DataSource, ViewDelegateFlowLayout)

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        titleButton.addTarget(self, action: #selector(didTapNumber), for: .touchUpInside)
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
        titleButton.setTitle(item.user.username, for: .normal)
        currentPhoto.load(urlString: item.urls.thumb)
        indexPathToEnd = currentIndex
        fetchPhotoData(id: item.id)
        guard let photoInfo = viewModel.photo else {
            return
        }
        infoView.addInfo(of: photoInfo)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: indexPathToScroll ?? 0, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
    
// MARK: - Animations
    
// MARK: Drag down animation
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
    
// MARK: Dissmiss if tap animation
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
    
// MARK: animate dark background
    func animations() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
        blackBackgroundView.alpha = 0
        view.addSubview(blackBackgroundView)
        view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                        self.blackBackgroundView.alpha = 0.5
        }, completion: nil)
    }
    
// MARK: dismiss InfoView
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
