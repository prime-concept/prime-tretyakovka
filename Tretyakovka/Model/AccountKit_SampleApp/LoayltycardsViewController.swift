//
//  LoayltycardsViewController.swift
//  TretGall
//
//  Created by Александр Сабри on 26.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class LoayltycardsViewController: UIViewController {

    @IBOutlet weak var CardFrontFaceView: UIView!
    @IBOutlet var CardBackFaceView: UIView!
    @IBOutlet weak var CardBumberTextFieldInput: UITextField!
    @IBOutlet weak var CardNUmberLabel: UILabel!
    
    var isOpen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func flipToBack(_ sender: Any) {
        if isOpen{
            UIView.transition(from: CardFrontFaceView, to: CardBackFaceView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            isOpen = true
        }else{
            UIView.transition(from: CardBackFaceView, to: CardFrontFaceView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
            isOpen = false
        }
        
        
    }
    
}
