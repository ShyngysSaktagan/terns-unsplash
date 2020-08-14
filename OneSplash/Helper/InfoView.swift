//
//  InfoView.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/12/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    static var height: CGFloat = 350
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureInfoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .bcc
    }
    
    let mapView = MapView()
     
    let makeLabel           = TitleLabel(textAlignment: .right, fontSize: 15, text: "Make")
    let modelLabel          = TitleLabel(textAlignment: .right, fontSize: 15, text: "Model")
    let shutterSpeedLabel   = TitleLabel(textAlignment: .right, fontSize: 15, text: "Shutter Speed")
    let apertureLabel       = TitleLabel(textAlignment: .right, fontSize: 15, text: "Aperture")
    
    let makeSubLabel            = SubTitleLabel(textAlignment: .right, text: "...")
    let modelSubLabel           = SubTitleLabel(textAlignment: .right, text: "...")
    let shutterSpeedSubLabel    = SubTitleLabel(textAlignment: .right, text: "...")
    let apertureSubLabel        = SubTitleLabel(textAlignment: .right, text: "...")
    
    let focalLength = TitleLabel(textAlignment: .right, fontSize: 15, text: "Focal Length")
    let iso         = TitleLabel(textAlignment: .right, fontSize: 15, text: "ISO")
    let dimensions  = TitleLabel(textAlignment: .right, fontSize: 15, text: "Dimensions")
    let published   = TitleLabel(textAlignment: .right, fontSize: 15, text: "Published")
    
    let focalLengthSubLabel = SubTitleLabel(textAlignment: .right, text: "... 2")
    let isoSubLabel         = SubTitleLabel(textAlignment: .right, text: "... 2")
    let dimensionsSubLabel  = SubTitleLabel(textAlignment: .right, text: "... 2")
    let publishedSubLabel   = SubTitleLabel(textAlignment: .right, text: "... 2")
    
    lazy var stackView1 = VerticalStackView(title: makeLabel, subTitle: makeSubLabel)
    lazy var stackView2 = VerticalStackView(title: modelLabel, subTitle: modelSubLabel)
    lazy var stackView3 = VerticalStackView(title: shutterSpeedLabel, subTitle: shutterSpeedSubLabel)
    lazy var stackView4 = VerticalStackView(title: apertureLabel, subTitle: apertureSubLabel)
    
    lazy var stackView5 = VerticalStackView(title: focalLength, subTitle: focalLengthSubLabel)
    lazy var stackView6 = VerticalStackView(title: iso, subTitle: isoSubLabel)
    lazy var stackView7 = VerticalStackView(title: dimensions, subTitle: dimensionsSubLabel)
    lazy var stackView8 = VerticalStackView(title: published, subTitle: publishedSubLabel)
    
    lazy var mainVertivalStackView1 : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView1, stackView2, stackView3, stackView4, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = .blue
        return stackView
    }()
    
    lazy var mainVertivalStackView2 : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackView5, stackView6, stackView7, stackView8, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = .red
        return stackView
    }()
    
    lazy var mainVertivalStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainVertivalStackView1, mainVertivalStackView2])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()

    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    private var infoLabel = TitleLabel(textAlignment: .center, fontSize: 16, weight: .bold ,text: "Info")
    private var descriptionLabel = SubTitleLabel(textAlignment: .left, text: "Description")
    
    private var line : UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()
    
    private var line2 : UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()

    func configureInfoView() {
        self.addSubview(dismissButton)
        self.addSubview(infoLabel)
        self.addSubview(line)
        self.addSubview(descriptionLabel)
        self.addSubview(line2)
        self.addSubview(mainVertivalStackView)
        self.addSubview(mapView)
        self.layoutIfNeeded()
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        line2.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }
    
    func addInfo(of photo: Photo) {
        self.makeSubLabel.text          = photo.exif?.make ?? "-"
        self.modelSubLabel.text         = photo.exif?.model ?? "-"
        if let shutter = photo.exif?.exposureTime {
            self.shutterSpeedSubLabel.text  = "\(shutter)s"
        } else { self.shutterSpeedSubLabel.text = "-" }
        
        if let aperture = photo.exif?.aperture {
            self.apertureSubLabel.text  = "f/\(aperture)s"
        } else { self.apertureSubLabel.text = "-" }
        
        if let focalLength = photo.exif?.focalLength {
            self.focalLengthSubLabel.text  = "\(focalLength)"
        } else { self.focalLengthSubLabel.text = "-" }
        
        if let aperture = photo.exif?.iso {
            self.isoSubLabel.text  = "\(aperture)"
        } else { self.isoSubLabel.text = "-" }
        
        self.descriptionLabel.text      = photo.description ?? "none"
        self.dimensionsSubLabel.text    = "\(photo.width) x \(photo.height)"
        self.publishedSubLabel.text     = photo.createdAt.convertToDisplayFormat()
        self.mapView.addLocation(photoLocation: photo)
        
        print("asdadasdasdadasdasdasd")
        print("asdadasdasdadasdasdasd")
        print("asdadasdasdadasdasdasd")
        print("asdadasdasdadasdasdasd")
        print("\(mapView.latitude)       \(mapView.longitude)")
        
        if descriptionLabel.text == "none" {
            line2.removeFromSuperview()
            descriptionLabel.removeFromSuperview()
            mainVertivalStackView.removeFromSuperview()
            if mapView.latitude == nil && mapView.longitude == nil {
                mapView.removeFromSuperview()
                addSubview(mainVertivalStackView)
                mainVertivalStackView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.top.equalTo(line.snp.bottom).offset(20)
                    make.height.equalToSuperview().offset(-70)
                }
                InfoView.height = 350
            } else {
                mapView.removeFromSuperview()
                addSubview(mapView)
                addSubview(mainVertivalStackView)
                addSubview(line2)
                mapView.snp.makeConstraints { make in
                    make.top.equalTo(line.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(200)
                }
                line2.snp.makeConstraints { make in
                    make.top.equalTo(mapView.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(1)
                }
                mainVertivalStackView.snp.makeConstraints { make in
                    make.top.equalTo(line2.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalToSuperview().offset(-70)
                }
                InfoView.height = 550
            }
            
        } else {
            for view in [line2, descriptionLabel, mainVertivalStackView] {
                view.removeFromSuperview()
                addSubview(view)
            }
            if mapView.latitude == nil && mapView.longitude == nil {
                mapView.removeFromSuperview()
                descriptionLabel.snp.makeConstraints { make in
                    make.top.equalTo(line.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
                line2.snp.makeConstraints { make in
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(1)
                }
                mainVertivalStackView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.top.equalTo(line2.snp.bottom).offset(20)
                    make.height.equalToSuperview().offset(-70)
                }
                InfoView.height = 400
            } else {
                mapView.removeFromSuperview()
                addSubview(mapView)
                descriptionLabel.snp.makeConstraints { make in
                    make.top.equalTo(line.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
                mapView.snp.makeConstraints { make in
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(200)
                }
                line2.snp.makeConstraints { make in
                    make.top.equalTo(mapView.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(1)
                }
                mainVertivalStackView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.top.equalTo(line2.snp.bottom).offset(20)
                    make.height.equalToSuperview().offset(-70)
                }
                InfoView.height = 600
            }
           
        }
    }
    
}
