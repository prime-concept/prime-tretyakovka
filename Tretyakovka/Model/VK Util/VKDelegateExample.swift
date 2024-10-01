//
//  VKDelegateExample.swift
//  TretGall
//
//  Created by Александр Сабри on 27.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import SwiftyVK
import UIKit

class VKDelegateExample: SwiftyVKDelegate {
    let appId = "6310512"
    let scopes: Scopes = [.offline,.friends,.email]
    
    init() {
        VK.setUp(appId: appId, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                rootController.present(viewController, animated: true, completion: nil)
            }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
        print()
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
}

