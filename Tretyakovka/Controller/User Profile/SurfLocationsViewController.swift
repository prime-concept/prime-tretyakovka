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
import SwiftyJSON
import Alamofire

struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = 80
    var cardShouldExpandHeadHeight: Bool = true
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = 500
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
    @IBOutlet weak var ticketsLabel: UILabel!
    
    
    
    var profile: Profile!
    var hideNavigationBar = false
    var hideToolBar = false

    var defaults = CardLayoutSetupOptions()
    var numberFormatter = NumberFormatter()
    
    var tickets = [Tickets]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        tickets.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchtickets()
        
        //TODO check whose login type are avelable
        if (AccessToken.current) != nil {
            self.updateAccountButton()
            if !profile.isDataLoaded {
                profile.loadProfileData {
                    //                    Fetch the profile image now that we have an URL
                    self.updateAccountButton()
                }
            }
        } else if (VK.sessions.default.state).rawValue == 1 {
            self.usersGet()
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0)]
        
        self.ticketsLabel.isHidden = false
        self.tableView.isHidden = true

    }
    
    func usersGet() {
        VK.API.Users.get([
            .fields: "photo_100, contacts"
            ])
            .configure(with: Config.init(httpMethod: .POST))
            .onSuccess { print("SwiftyVK: users.get successed with \n \(JSON($0))")
                let name = defaults_user.object(forKey: defaultsKeys.username)
                if name == nil {
                    print("i am nill")
                    if let json = try? JSON($0) {
                        for item in json[].arrayValue {
                            let firstname = item["first_name"].stringValue
                            let lastname = item["last_name"].stringValue
                            defaults_user.set("\(firstname) \(lastname)", forKey: defaultsKeys.username)
                            let photourl = item["photo_100"].stringValue
                            defaults_user.set(photourl, forKey: defaultsKeys.useravatarURL)
                            let phone = item["mobile_phone"].stringValue
                            defaults_user.set(phone, forKey: defaultsKeys.userphone)
                            print("--------------------------finish with user data")
                            self.configurationVK()
                        }
                    }
                    
                } else {
                        print("--------------------------finish with user data")
                        self.configurationVK()
                    
                
                
            }
            
            }
            .onError { print("SwiftyVK: friends.get fail \n \(JSON($0))") }
            .send()
    }
    
    
    func configurationVK() {
        DispatchQueue.main.async { // Correct
            defaults_user.synchronize()
            let name = defaults_user.object(forKey: defaultsKeys.username)
            if name == nil {
                print("i am nill")
                self.nameLabel.setTitle(self.profile.facebookData?.name ?? "Unknown", for: .normal)
                
            } else {
                print(" i am not nill")
                let user_image = defaults_user.object(forKey: defaultsKeys.useravatarURL)
                print("-------------------------- user image fetched")
                print(user_image)
                let url = URL(string: user_image as! String)
                let data = try? Data(contentsOf: url!)
                self.accountButton.setImage(UIImage(data: data!), for: .normal)
                self.accountButton.contentMode = .scaleAspectFill

                self.nameLabel.setTitle(name as! String, for: .normal)
                print(name)
            }
        }
    }
    
    
    
     func configureForFacebookLogin() {
        DispatchQueue.main.async { // Correct
        defaults_user.synchronize()
        let name = defaults_user.object(forKey: defaultsKeys.username)
        if name == nil {
            print("i am nill")
            self.nameLabel.setTitle(self.profile.facebookData?.name ?? "Unknown", for: .normal)
            
            
        } else {
            print(" i am not nill")
            // If we have a profile image – use it and return
            if let image = self.profile.profileImage {
                self.accountButton.setImage(image, for: .normal)
                let email = self.profile.facebookData?.email
                print(email)
                defaults_user.set(email, forKey: defaultsKeys.useremail)
            } else {
                let email = self.profile.facebookData?.email
                print(email)
                defaults_user.set(email, forKey: defaultsKeys.useremail)
                
                self.accountButton.setImage(#imageLiteral(resourceName: "icon_profile-empty"), for: .normal)
                self.profile.loadProfileImage { [weak self] image in
                    if let image = image {
                        self?.accountButton.setImage(image, for: .normal)
                    }
                }
            }
            let email = self.profile.facebookData?.email
            print(email)
            defaults_user.set(email, forKey: defaultsKeys.useremail)
            self.nameLabel.setTitle(name as! String, for: .normal)
            print(name)
            }
    }
    }
    
     func configureForNoLogin() {
        nameLabel.titleLabel?.text = "Unknown"
    }
//    \(UIDevice.current.identifierForVendor!.uuidString)
    
    func fetchtickets() {
        Alamofire.request("https://primepass.ru/api/public/v1/order/get_orders_by_device_id?device_id=\(UIDevice.current.identifierForVendor!.uuidString)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)

                
                 guard let data = json["data"][0]["Tickets"].array else {
                    print("Нет билетов")
                    return
                }
                for ticket in data {
                    let names = ticket["name"].string
                    let adress = ticket["event_annotation_short"].string
                    let image = ticket["img_url"].string
                    let date = ticket["date"].string
                    let tiket = ticket["ticket_pdf"].string
                    
                    var userName = names
                    if userName == nil{
                        userName = "null"
                    }
                    
                    var useradress = adress
                    if useradress == nil{
                        useradress = "null"
                    }
                    
                    var userimage = image
                    if userimage == nil{
                        userimage = "null"
                    }
                    
                    var userdate = date
                    if userdate == nil{
                        userdate = "null"
                    }
                    
                    var usertiket = tiket
                    if usertiket == nil{
                        usertiket = "null"
                    }
                    
                    
                    let thisTicket = Tickets(names: userName!, adress: useradress!, image: userimage!, date: userdate!, ticket: usertiket!)
                    
                    self.tickets.append(thisTicket)
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("--------------------------self.tickets.count")
                    self.ticketsLabel.isHidden = true
                    self.tableView.isHidden = false

                    print(self.tickets.count)
                }
                print(self.tickets)
            case .failure(let error):
                print(error)
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketcell", for: indexPath) as! TicketsTableViewCell
        let ticket = tickets
        cell.TiketsDetail = ticket[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketcell", for: indexPath) as! TicketsTableViewCell
        let ticket = tickets
        cell.TiketsDetail = ticket[indexPath.row]
        let url = cell.TiketsDetail?.ticket
        print(url)
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
        cell.removeFromSuperview()
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
            let email = self.profile.facebookData?.email
            print(email)
            defaults_user.set(email, forKey: defaultsKeys.useremail)
            
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


