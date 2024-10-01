//
//  ReligionVC.swift
//  AccountKit_SampleApp
//
//  Created by Александр Сабри on 31.10.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//programs
//exhibitions

import UIKit
import CoreLocation


class ReligionVC: UIViewController, UIWebViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    override func viewWillAppear(_ animated: Bool) {
        loadURLRequest()
    }
    
    
    func loadURLRequest(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let currentURL = BaseURL
                if let url = URL(string: "\(currentURL)/programs?device_id=\(UIDevice.current.identifierForVendor!.uuidString)") {
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                }
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                let currentLocation = locationManager.location
                let lat = currentLocation?.coordinate.latitude
                let long = currentLocation?.coordinate.longitude
                let currentURL = BaseURL
                if let url = URL(string: "\(currentURL)/programs?lat=\(lat!)&lng=\(long!)&device_id=\(UIDevice.current.identifierForVendor!.uuidString)") {
                    let request = URLRequest(url: url)
                    print(request)
                    webView.loadRequest(request)
                }
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            let currentURL = BaseURL
            if let url = URL(string: "\(currentURL)/programs") {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }
    
}
