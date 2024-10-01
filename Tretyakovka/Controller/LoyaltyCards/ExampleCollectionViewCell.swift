//
//  LoyaltycardCell.swift
//  TretGall
//
//  Created by Александр Сабри on 22.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import QuartzCore

class ExampleCollectionViewCell: HFCardCollectionViewCell {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    var cardNUmber: String?
    
    
    @IBOutlet var buttonFlip: UIButton?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var labelText: UILabel?
    @IBOutlet var imageIcon: UIImageView?
    @IBOutlet var deleteButton: UIButton?
    
    @IBOutlet var backView: UIView?
    @IBOutlet var buttonFlipBack: UIButton?

    @IBOutlet weak var btnDemo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    func cardIsRevealed(_ isRevealed: Bool) {
        self.buttonFlip?.isHidden = !isRevealed
        self.tableView?.scrollsToTop = isRevealed
    }
    
    @IBAction func buttonFlipAction() {
        if let backView = self.backView {
            // Same Corner radius like the contentview of the HFCardCollectionViewCell
            backView.layer.cornerRadius = self.cornerRadius
            backView.layer.masksToBounds = true
            
            self.cardCollectionViewLayout?.flipRevealedCard(toView: backView)
        }
    }
    
    
}

