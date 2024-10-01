//
//  MainTabBar.swift
//  AccountKit_SampleApp
//
//  Created by Александр Сабри on 30.10.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import AccountKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainTabBar: UITabBarController {
    
    var profile: Profile!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = 2
        self.tabBar.barTintColor = UIColor.white
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[2].title = nil
        tabBarItems[2].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(String(describing: tabBar.items?.index(of: item)))")
        let selectedItem = tabBar.items?.index(of: item)
        print(selectedItem!)
        if selectedItem == 4 {
      
                if  let arrayOfTabBarItems = tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
                    tabBarItem.isEnabled = false
                }
                

            
        } else {
            if  let arrayOfTabBarItems = tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
                tabBarItem.isEnabled = true
            }
            print("Вообще по хуй что происходит")
        }
    }

}

extension MainTabBar {
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? SurfLocationsViewController {
            vc.profile = profile
        }
    }
    
    ///
    fileprivate enum SegueIdentifier: String {
        case showAccount = "ShowAccount"
        case showSurfLocations = "ShowSurfLocations"
    }
    ///
    fileprivate func showAccountViewController() {
        presentWithSegueIdentifier(.showAccount, animated: false)
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
