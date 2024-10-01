//
//  SurfLocationsViewController.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import Foundation
import FBSDKShareKit
import MapKit
import SwiftyVK

struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = 80
    var cardShouldExpandHeadHeight: Bool = true
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = 300
    var bottomNumberOfStackedCards: Int = 5
    var bottomStackedCardsShouldScale: Bool = true
    var bottomCardLookoutMargin: CGFloat = 10
    var bottomStackedCardsMaximumScale: CGFloat = 1.0
    var bottomStackedCardsMinimumScale: CGFloat = 0.94
    var spaceAtTopForBackgroundView: CGFloat = 20
    var spaceAtTopShouldSnap: Bool = false
    var spaceAtBottom: CGFloat = 0
    var scrollAreaTop: CGFloat = 120
    var scrollAreaBottom: CGFloat = 120
    var scrollShouldSnapCardHead: Bool = false
    var scrollStopCardsAtTop: Bool = true
    
    var numberOfCards: Int = 0
}

internal final class SurfLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var profile: Profile!
    var hideNavigationBar = false
    var hideToolBar = false
    
    var defaults = CardLayoutSetupOptions()
    var numberFormatter = NumberFormatter()
    
    let tickets:[String:[String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facebook guard let if using only FB login type uncoment
//        guard profile != nil else {
//            fatalError("profile must be set on SurfLocationsViewController before it is presented")
//        }

        //TODO check whose login type are avelable
        if let fbToken = FBSDKAccessToken.current() {
            if !profile.isDataLoaded {
                profile.loadProfileData {
//                    Fetch the profile image now that we have an URL
                    self.updateAccountButton()
                }
            }
         } else if (VK.sessions?.default.state)!.rawValue == 1 {
         self.usersGet()
            }
         
         
        
        

       
        let ticketsNumber = tickets.count
        if ticketsNumber == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 16.0)]

    }
    
    func usersGet() {
        VK.API.Users.get([
            .fields: "photo_200_orig, contacts"
            ])
            .configure(with: Config.init(httpMethod: .POST))
            .onSuccess { print("SwiftyVK: users.get successed with \n \(JSON($0))")
                if let json = try? JSON($0) {
                    for item in json[].arrayValue {
                        let firstname = item["first_name"].stringValue
                        let lastname = item["last_name"].stringValue
                        defaults_user.set("\(firstname) \(lastname)", forKey: defaultsKeys.username)
                        let photourl = item["photo_200_orig"].stringValue
                        defaults_user.set(photourl, forKey: defaultsKeys.useravatarURL)
                        let phone = item["mobile_phone"].stringValue
                        defaults_user.set(phone, forKey: defaultsKeys.userphone)
                        print("--------------------------finish with user data")
                        self.configureForFacebookLogin()
                    }
                }
                
            }
            .onError { print("SwiftyVK: friends.get fail \n \(JSON($0))") }
            .send()
    }
    
    
    
     func configureForFacebookLogin() {
        DispatchQueue.main.async { // Correct
        let name = defaults_user.object(forKey: defaultsKeys.username)
        if name == nil {
            self.nameLabel.setTitle(self.profile.facebookData?.name ?? "Unknown", for: .normal)
        } else {
            let user_image = defaults_user.object(forKey: defaultsKeys.useravatarURL)
            print("-------------------------- user image fetched")
            print(user_image)
            let url = URL(string: user_image as! String)
            let data = try? Data(contentsOf: url!)
            self.accountButton.setImage(UIImage(data: data!), for: .normal)
            self.nameLabel.setTitle(name as? String, for: .normal)
            }
        }
    }
    
     func configureForNoLogin() {
        nameLabel.titleLabel?.text = "Unknown"
    }
    
// -----------------------------------------------------------------------------
// MARK: - TableView
    
    func numberOfSectionsInTableview(_ tableview: UITableView)-> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ExampleViewController {
            
            var layoutOptions = CardLayoutSetupOptions()
            layoutOptions.numberOfCards                  = 0
            layoutOptions.firstMovableIndex              = 0
            layoutOptions.cardHeadHeight                 = 50
            layoutOptions.cardShouldExpandHeadHeight     = false
            layoutOptions.cardShouldStretchAtScrollTop   = false
            layoutOptions.cardMaximumHeight              = 200
            layoutOptions.bottomNumberOfStackedCards     = 5
            layoutOptions.bottomStackedCardsShouldScale  = false
            layoutOptions.bottomCardLookoutMargin        = 10
            layoutOptions.spaceAtTopForBackgroundView    = 10
            layoutOptions.spaceAtTopShouldSnap           = false
            layoutOptions.spaceAtBottom                  = 0
            layoutOptions.scrollAreaTop                  = 80
            layoutOptions.scrollAreaBottom               = 80
            layoutOptions.scrollShouldSnapCardHead       = false
            layoutOptions.scrollStopCardsAtTop           = true
            layoutOptions.bottomStackedCardsMinimumScale = 1.0
            layoutOptions.bottomStackedCardsMaximumScale = 0.94
            
            controller.cardLayoutOptions = layoutOptions
            
            if(segue.identifier == "WithinNavigationController") {
                self.hideNavigationBar = false
                self.hideToolBar = true
            }
        }
        if let vc = segue.destination as? AccountViewController {
            vc.profile = profile
        } else if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? FollowFriendsViewController {
            vc.profile = profile
        }
    }
    
    // MARK: Private functions
    
    private func getIntFromTextfield(_ textfield: UITextField) -> Int {
        if let n = self.numberFormatter.number(from: (textfield.text)!) {
            return n.intValue
        }
        return 0
    }
    
    private func getFloatFromTextfield(_ textfield: UITextField) -> CGFloat {
        if let n = self.numberFormatter.number(from: (textfield.text)!) {
            return CGFloat(truncating: n)
        }
        return 0
    }
    
    private func stringFromFloat(_ float: CGFloat) -> String {
        return String(Int(float))
    }
    
}

// -----------------------------------------------------------------------------
// MARK: - IBActions


// -----------------------------------------------------------------------------
// MARK: - Updating navigation bar buttons

internal extension SurfLocationsViewController {
    func updateAccountButton() {
        // If we have a profile image – use it and return
        if let image = profile.profileImage {
            accountButton.setImage(image, for: .normal)
        } else {
            accountButton.setImage(#imageLiteral(resourceName: "icon_profile-empty"), for: .normal)
            profile.loadProfileImage { [weak self] image in
                if let image = image {
                    self?.accountButton.setImage(image, for: .normal)
                }
            }
        }
        switch profile.loginType {
        case .accountKit: configureForFacebookLogin()
        case .facebook: configureForFacebookLogin()
        case .none: configureForNoLogin()
        }
        
    }
    
    }
    


// -----------------------------------------------------------------------------
// MARK: - Segues

//extension SurfLocationsViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? AccountViewController {
//            vc.profile = profile
//        } else if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? FollowFriendsViewController {
//            vc.profile = profile
//        }
//    }
//}

