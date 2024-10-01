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
import AccountKit
import FBSDKLoginKit
import SwiftyVK


// MARK: - AccountViewController: UIViewController

class AccountViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextField!
    @IBOutlet weak var myTextField: UITextField!
    
    
    // MARK: Properties
    
    var profile: Profile!

    // MARK: View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        myTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard
//        nameLabel.inputAccessoryView = ViewForDoneButtonOnKeyboard
        
        let ViewForDoneButtonOnKeyboardEmail = UIToolbar()
        ViewForDoneButtonOnKeyboardEmail.sizeToFit()
        let btnDoneOnKeyboardEmail = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClickedEmail))
        ViewForDoneButtonOnKeyboardEmail.items = [btnDoneOnKeyboardEmail]
        valueLabel.inputAccessoryView = ViewForDoneButtonOnKeyboardEmail
        
        let ViewForDoneButtonOnKeyboardName = UIToolbar()
        ViewForDoneButtonOnKeyboardName.sizeToFit()
        let btnDoneOnKeyboardName = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClickedName))
        ViewForDoneButtonOnKeyboardName.items = [btnDoneOnKeyboardName]
        nameLabel.inputAccessoryView = ViewForDoneButtonOnKeyboardName
        
        
        
        
        if (VK.sessions.default.state).rawValue == 1 {
            
            let name = defaults_user.object(forKey: defaultsKeys.username)
            nameLabel.text = name as? String
            
            let email = defaults_user.object(forKey: defaultsKeys.useremail)
            valueLabel.text = email as? String
            
            let phone = defaults_user.object(forKey: defaultsKeys.userphone)
            myTextField.text = phone as? String
            
            let user_image = defaults_user.object(forKey: defaultsKeys.useravatarURL)
            print("--------------------------user_image")
            print(user_image)
            let url = URL(string: user_image as! String)
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        } else {
                    if let image = profile.profileImage {
                        imageView.image = image
                    } else {
                        imageView.image = #imageLiteral(resourceName: "icon_profile-empty")
                        profile.loadProfileImage { [weak self] image in
                            self?.imageView.image = image
                        }
                    }
            
                    switch profile.loginType {
                    case .accountKit: configureForAccountKitLogin()
                    case .facebook: configureForFacebookLogin()
                    case .none: configureForNoLogin()
                    }
        }
        
        func textFieldDidBeginEditing(myTextField: UITextField!) {    //delegate method
            
        }
        
        
//        if let fbToken = FBSDKAccessToken.current() {
//            if !profile.isDataLoaded {
//                profile.loadProfileData {
//                    
//                    if let image = self.profile.profileImage {
//                        self.imageView.image = image
//                    } else {
//                        self.imageView.image = #imageLiteral(resourceName: "icon_profile-empty")
//                        self.profile.loadProfileImage { [weak self] image in
//                            self?.imageView.image = image
//                        }
//                    }
//                    
//                    switch self.profile.loginType {
//                    case .accountKit: self.configureForAccountKitLogin()
//                    case .facebook: self.configureForFacebookLogin()
//                    case .none: self.configureForNoLogin()
//                    }
//                }
//            }
//        } else if (VK.sessions?.default.state)!.rawValue == 1 {
//            
//            let name = defaults_user.object(forKey: defaultsKeys.username)
//            nameLabel.text = name as? String
//            
//            let email = defaults_user.object(forKey: defaultsKeys.useremail)
//            valueLabel.text = email as? String
//            
//            let phone = defaults_user.object(forKey: defaultsKeys.userphone)
//            myTextField.text = phone as? String
//            
//            let user_image = defaults_user.object(forKey: defaultsKeys.useravatarURL)
//            print("--------------------------")
//            print(user_image)
//            let url = URL(string: user_image as! String)
//            let data = try? Data(contentsOf: url!)
//            self.imageView.image = UIImage(data: data!)
//        }



        imageView.layer.cornerRadius = imageView.bounds.width / 2
//
//        if let image = profile.profileImage {
//            imageView.image = image
//        } else {
//            imageView.image = #imageLiteral(resourceName: "icon_profile-empty")
//            profile.loadProfileImage { [weak self] image in
//                self?.imageView.image = image
//            }
//        }
//
//        switch profile.loginType {
//        case .accountKit: configureForAccountKitLogin()
//        case .facebook: configureForFacebookLogin()
//        case .none: configureForNoLogin()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func validate(value: String) -> Bool {
        print("validate emilId: \(value)")
        if value.characters.count >= 9 && value.characters.count <= 19 {
            return true
        }
        else{
            return false
        }
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    

    private func configureForAccountKitLogin() {
        setBottomLabelsHidden(false)
        nameLabel.text = profile.accountKitData?.name ?? "Unknown"
//        accountIDLabel.text = profile.accountKitData?.id ?? "Unknown"

        // If we have email, show that. If not, use phone number. If neither,
        // hide the fields.
        if let email = profile.accountKitData?.email {
            titleLabel.text = "Email"
            valueLabel.text = email
        } else if let phone = profile.accountKitData?.phone {
            titleLabel.text = "Phone"
            valueLabel.text = phone
        } else {
            titleLabel.isHidden = true
            valueLabel.isHidden = true
        }
    }

    private func configureForFacebookLogin() {
        setBottomLabelsHidden(false)
//        nameLabel.text = profile.facebookData?.name ?? ""
        titleLabel.text = "Email"
        let email = defaults_user.object(forKey: defaultsKeys.useremail)
        let name = defaults_user.object(forKey: defaultsKeys.username)
        if email == nil {
            valueLabel.text = profile.facebookData?.email ?? ""
        } else {
            valueLabel.text = email as? String
        }
        if name == nil {
            nameLabel.text = profile.facebookData?.name ?? ""
        } else {
            nameLabel.text = name as? String
        }
        
        myTextField.text = defaults_user.object(forKey: defaultsKeys.userphone) as? String
        
    }

    private func configureForNoLogin() {
        setBottomLabelsHidden(true)
        nameLabel.text = ""
    }

    private func setBottomLabelsHidden(_ hidden: Bool) {
//        accountIDTitleLabel.isHidden = hidden
//        accountIDLabel.isHidden = hidden
        titleLabel.isHidden = hidden
        valueLabel.isHidden = hidden
    }

    // MARK: Actions
    @IBAction func logOut(_ sender: Any) {
        profile.logOut()
        logout()
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func logout() {
        VK.sessions.default.logOut()
        print("SwiftyVK: LogOut")
    }
    @IBAction func doneBtnFromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        let text: String = myTextField.text!
//
        print(text)
//        defaults_user.set(text, forKey: defaultsKeys.userphone)
//        defaults_user.synchronize()
//        //Hide Keyboard by endEditing or Anything you want.
//        self.view.endEditing(true)
//
//
        if validate(value: text){
            print(text)
            defaults_user.set(text, forKey: defaultsKeys.userphone)
            defaults_user.synchronize()
        }else{
            myTextField.text = " "
            print("invalide EmailID")
            let alert = UIAlertController(title: "Ошибка", message: "Некорректный номер телефона", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //Hide Keyboard by endEditing or Anything you want.
        self.view.endEditing(true)
        
        
        
        
    }
    @IBAction func doneBtnFromKeyboardClickedEmail (sender: Any) {
        let text: String = valueLabel.text!
        if isValidEmail(testStr: text){
            print("Validate EmailID")
            print("Done Button Clicked.")
            print(text)
            defaults_user.set(text, forKey: defaultsKeys.useremail)
            defaults_user.synchronize()
        }else{
            valueLabel.text = " "
            print("invalide EmailID")
            let alert = UIAlertController(title: "Ошибка", message: "Некорректный email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //Hide Keyboard by endEditing or Anything you want.
        self.view.endEditing(true)
    }
    @IBAction func doneBtnFromKeyboardClickedName (sender: Any) {
        print("Done Button Clicked.")
        let text: String = nameLabel.text!
        print(text)
        defaults_user.set(text, forKey: defaultsKeys.username)
        defaults_user.synchronize()
        //Hide Keyboard by endEditing or Anything you want.
        self.view.endEditing(true)
    }
}
