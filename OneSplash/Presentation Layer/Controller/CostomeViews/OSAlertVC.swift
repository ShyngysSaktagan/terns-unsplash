//
//  OSAlertVC.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class OSAlertVC: UINavigationController {
//    let ourNavigationController = UINavigationController()
    
    let containerView       = UIView()
    let titleLabel          = UILabel()
    let emailTextfield      = UITextField()
    let passwordTextfield   = UITextField()
    let loginButton         = UIButton()
    let messageLabel        = UILabel()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = title
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//        configureContainerView()
//        configureTitleLabel()
//        configureActionButton()
//        configureMessageLabel()
        
    }
    
    func configureContainerView() {
//        view.addSubview(ourNavigationController)
//        view.addSubview(containerView)
//        let containerView = UIContainerView()
//        view.addChild(containerView)
//        let navigationViewController = UINavigationController()
//        containerView.addViewController(navigationViewController)
//        containerView.backgroundColor       = .systemBackground
//        containerView.layer.cornerRadius    = 16
//        containerView.layer.borderColor     = UIColor.white.cgColor
//        containerView.layer.borderWidth     = 2
//    containerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.height.equalTo(UIScreen.main.bounds.width - 30)
//            make.width.equalTo(UIScreen.main.bounds.width - 30)
//        }
//
//        NSLayoutConstraint.activate([
//            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            containerView.heightAnchor.constraint(equalToConstant: 220),
//            containerView.widthAnchor.constraint(equalToConstant: 300)
//        ])
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text           = message ?? "Unable to complete request"
        messageLabel.numberOfLines  = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -12)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(loginButton)
        loginButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        loginButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
