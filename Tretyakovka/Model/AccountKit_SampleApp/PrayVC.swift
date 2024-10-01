//
//  PrayVC.swift
//  AccountKit_SampleApp
//
//  Created by Александр Сабри on 31.10.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import CoreLocation


class PrayVC: UIViewController, UIWebViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
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
                if let url = URL(string: "\(currentURL)/exhibitions?device_id=\(UIDevice.current.identifierForVendor!.uuidString)") {
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                    print(url)
                }
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                let currentLocation = locationManager.location
                let lat = currentLocation?.coordinate.latitude
                let long = currentLocation?.coordinate.longitude
                let currentURL = BaseURL
                if let url = URL(string: "\(currentURL)/exhibitions?lat=\(lat!)&lng=\(long!)&device_id=\(UIDevice.current.identifierForVendor!.uuidString)") {
                    let request = URLRequest(url: url)
                    print(request)
                    webView.loadRequest(request)
                }
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            let currentURL = BaseURL
            if let url = URL(string: "\(currentURL)/exhibitions") {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }

}
