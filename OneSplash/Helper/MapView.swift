//
//  MapView.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/14/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: MKMapView {
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        checkLocationServices()
    }
    
    func addLocation(photoLocation: Photo) {
        if let item = photoLocation.location {
            let annotation = MKPointAnnotation()
            annotation.title = item.city
            annotation.subtitle = item.country
            self.longitude = item.position?.longitude
            self.latitude = item.position?.latitude
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.position?.latitude ?? 0,
                                                           longitude: item.position?.longitude ?? 0)
            self.addAnnotation(annotation)
            self.mapType = .standard
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.setRegion(region, animated: true)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            let alert = UIAlertController(title: "У вас выключена служба геолокация", message: "Хотите включить?", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}
