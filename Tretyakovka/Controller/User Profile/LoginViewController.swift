// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MapKit
import MessageUI
import SwiftyVK
import SwiftyJSON




// MARK: - LoginViewController: UIViewController

final class LoginViewController: UIViewController {

    // MARK: Properties
    
    fileprivate var showAccountOnAppear = true

    fileprivate var profile = Profile(loginType: .none)
    @IBOutlet weak var FaceBookView: UIView!
    @IBOutlet weak var VkView: UIView!
    @IBOutlet weak var loginView: UIStackView!
//    @IBOutlet weak var fakeview: UIView!
    

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Account Kit
        restoreExistingLoginState()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // Facebook Login
        // Check if user is logged in
        if let fbToken = AccessToken.current {
            profile = Profile(token: fbToken)
            showSurfLocations()
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func getDirections(_ sender: Any) {
       
    }
    
    @IBAction func vktapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://vk.com/tretyakovgallery")!, options: [:], completionHandler: nil)

    }
    
    @IBAction func fbtapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/tretyakovgallery")!, options: [:], completionHandler: nil)

    }
    
    @IBAction func instatappped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/tretyakov_gallery/")!, options: [:], completionHandler: nil)

    }
    
    @IBAction func youtubetapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/user/stg")!, options: [:], completionHandler: nil)

    }
    
    @IBAction func tripadviser(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.tripadvisor.ru/Attraction_Review-g298484-d300237-Reviews-The_State_Tretyakov_Gallery-Moscow_Central_Russia.html")!, options: [:], completionHandler: nil)

    }
    
    @IBAction func mailtotapped(_ sender: Any) {
        let subject = "Мобильное приложение Третьяковки"
        let body = "Вопросы, пожелания и заявки на возврат билетов присылайте  в нашу Службу поддержки support@primepass.ru."
        let coded = "mailto:support@primepass.ru?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL: NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                 UIApplication.shared.open(emailURL as URL, options: [:], completionHandler: nil)
                
            }
        }
    }
    @IBAction func useragreemanttapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://tretyakovka.primepass.ru/offer")!, options: [:], completionHandler: nil)

    }
    
    
    // Facebook Login
    
    @IBAction func logoutVK(_ sender: Any) {
        logout()
    }
    
    @IBAction func loginWithVK(_ sender: Any) {
        print("loginVK Tapped")
        authorize()
        
    }
    func logout() {
        VK.sessions.default.logOut()
        print("SwiftyVK: LogOut")
    }
    
    func authorize() {
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("SwiftyVK: success authorize with", JSON(info))
                if let json = try? JSON(info) {
                        let email = json["email"].stringValue
                        defaults_user.set("\(email)", forKey: defaultsKeys.useremail)
                        print("--------------------------")
                        print("\(email)")
                    
                }
                DispatchQueue.main.async { // Correct
                    self.showSurfLocations()
                }

        },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
        }
        )
    }

    
    
    // MARK: Helper Functions

    private func restoreExistingLoginState() {
        // Check for a Facebook token
        if let fbToken = AccessToken.current {
            profile = Profile(token: fbToken)
            showSurfLocations()
        
        } else if (VK.sessions.default.state).rawValue == 1 {
//            fakeview.isHidden = false
            DispatchQueue.main.async { // Correct
                self.showSurfLocations()
            }
        }
    }
    


}

// MARK: - Segues

extension LoginViewController {
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? SurfLocationsViewController {
            vc.profile = profile        }
    }

    ///
    fileprivate enum SegueIdentifier: String {
        case showAccount = "ShowAccount"
        case showSurfLocations = "ShowSurfLocations"
    }
    /// 
    fileprivate func showAccountViewController() {
        presentWithSegueIdentifier(.showAccount, animated: true)
    }

    ///
    fileprivate func showSurfLocations() {
        presentWithSegueIdentifier(.showSurfLocations, animated: false)
    }

    fileprivate func presentWithSegueIdentifier(_ segueIdentifier: SegueIdentifier, animated: Bool) {
        if animated {
                performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
        } else {
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
            }
        }
    }
    
}

extension CALayer {
    var UIShadowColor: UIColor? {
        get {
            guard let shadowColor = shadowColor else { return nil }
            return UIColor(cgColor: shadowColor)
        }
        set {
            shadowColor = newValue?.cgColor
        }
    }
    var UIBorderColor: UIColor? {
        get {
            guard let borderColor = borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}

