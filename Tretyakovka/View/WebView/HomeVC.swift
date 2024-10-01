//
//  HomeVC.swift
//  AccountKit_SampleApp
//
//  Created by Александр Сабри on 31.10.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import CoreLocation


class HomeVC: UIViewController, UIWebViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        webView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadURLRequest()
    }
    
    
    func loadURLRequest(){
        let phone = defaults_user.object(forKey: defaultsKeys.userphone) ?? "nil"
        let email = defaults_user.object(forKey: defaultsKeys.useremail) ?? "nil"
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let currentURL = BaseURL
                if let url = URL(string: "\(currentURL)?device_id=\(UIDevice.current.identifierForVendor!.uuidString)&phone=\(phone)&email=\(email)") {
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                }
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                let currentLocation = locationManager.location
                let lat = currentLocation?.coordinate.latitude ?? 0
                let long = currentLocation?.coordinate.longitude ?? 0
                let currentURL = BaseURL
                if let url = URL(string: "\(currentURL)?lat=\(lat)&lng=\(long)&device_id=\(UIDevice.current.identifierForVendor!.uuidString)&phone=\(phone)&email=\(email)") {
                    let request = URLRequest(url: url)
                    print(request)
                    webView.loadRequest(request)
                }
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            let currentURL = BaseURL
            if let url = URL(string: "\(currentURL)") {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }
    

    
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("------------log---------")
        print(webView.request?.mainDocumentURL! ?? String.self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("i am gone")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
