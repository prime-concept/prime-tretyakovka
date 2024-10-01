//
//  LoyaltyCardsCVC.swift
//  TretGall
//
//  Created by Александр Сабри on 22.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import CoreData


struct CardInfo {
    var color: UIColor
    var icon: UIImage
}

class ExampleViewController : UICollectionViewController, HFCardCollectionViewLayoutDelegate {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    @IBOutlet var backgroundView: UIView?
    @IBOutlet var backgroundNavigationBar: UINavigationBar?
    
    var cardLayoutOptions: CardLayoutSetupOptions?
    var shouldSetupBackgroundView = false
    
    var cardArray: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        self.setupExample()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.collectionView?.reloadData()

            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext

            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "Cards")
  
            do {
                cardArray = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        
        
        }
    
    
    // MARK: CollectionView
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(false)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ExampleCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.backgroundColor = UIColor(red:0.31, green:0.25, blue:0.21, alpha:1.0)
        cell.labelText?.text = card.value(forKeyPath: "number") as? String
        
//        cell.deleteButton?.layer.setValue(indexPath.row, forKey: "index")
//        cell.deleteButton?.addTarget(self,action: "deleteUser:", for: UIControlEvents.touchUpInside)
//        
//        // Remove the button from the first cell
//        if (indexPath.row == 0){
//            let close : UIButton = cell.viewWithTag(11) as! UIButton
//            close.isHidden = true
//        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = self.cardArray[sourceIndexPath.item]
        self.cardArray.remove(at: sourceIndexPath.item)
        self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }
    
    // MARK: Actions
    
//    func deleteUser(sender:UIButton) {
//
//        let i : Int = (sender.layer.valueForKey("index")) as! Int
//        userNames.removeAtIndex(i)
//        UserSelectCollection.reloadData()
//    }

    
    @IBAction func goBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editCardAction() {
        
        

    }
    
    @IBAction func deleteCardAtIndex0orSelected() {
        var index = 0
        if(self.cardCollectionViewLayout!.revealedIndex >= 0) {
            index = self.cardCollectionViewLayout!.revealedIndex
        }
        self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
            self.cardArray.remove(at: index)
            self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        })
    }
    
    // MARK: Private Functions
    
    private func setupExample() {
        if let cardCollectionViewLayout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardCollectionViewLayout
        }
        if(self.shouldSetupBackgroundView == true) {
            self.setupBackgroundView()
        }
        if let cardLayoutOptions = self.cardLayoutOptions {
            self.cardCollectionViewLayout?.firstMovableIndex = cardLayoutOptions.firstMovableIndex
            self.cardCollectionViewLayout?.cardHeadHeight = cardLayoutOptions.cardHeadHeight
            self.cardCollectionViewLayout?.cardShouldExpandHeadHeight = cardLayoutOptions.cardShouldExpandHeadHeight
            self.cardCollectionViewLayout?.cardShouldStretchAtScrollTop = cardLayoutOptions.cardShouldStretchAtScrollTop
            self.cardCollectionViewLayout?.cardMaximumHeight = cardLayoutOptions.cardMaximumHeight
            self.cardCollectionViewLayout?.bottomNumberOfStackedCards = cardLayoutOptions.bottomNumberOfStackedCards
            self.cardCollectionViewLayout?.bottomStackedCardsShouldScale = cardLayoutOptions.bottomStackedCardsShouldScale
            self.cardCollectionViewLayout?.bottomCardLookoutMargin = cardLayoutOptions.bottomCardLookoutMargin
            self.cardCollectionViewLayout?.spaceAtTopForBackgroundView = cardLayoutOptions.spaceAtTopForBackgroundView
            self.cardCollectionViewLayout?.spaceAtTopShouldSnap = cardLayoutOptions.spaceAtTopShouldSnap
            self.cardCollectionViewLayout?.spaceAtBottom = cardLayoutOptions.spaceAtBottom
            self.cardCollectionViewLayout?.scrollAreaTop = cardLayoutOptions.scrollAreaTop
            self.cardCollectionViewLayout?.scrollAreaBottom = cardLayoutOptions.scrollAreaBottom
            self.cardCollectionViewLayout?.scrollShouldSnapCardHead = cardLayoutOptions.scrollShouldSnapCardHead
            self.cardCollectionViewLayout?.scrollStopCardsAtTop = cardLayoutOptions.scrollStopCardsAtTop
            self.cardCollectionViewLayout?.bottomStackedCardsMinimumScale = cardLayoutOptions.bottomStackedCardsMinimumScale
            self.cardCollectionViewLayout?.bottomStackedCardsMaximumScale = cardLayoutOptions.bottomStackedCardsMaximumScale

        }
        self.collectionView?.reloadData()
    }
    
    
    private func setupBackgroundView() {
        if(self.cardLayoutOptions?.spaceAtTopForBackgroundView == 0) {
            self.cardLayoutOptions?.spaceAtTopForBackgroundView = 44 // Height of the NavigationBar in the BackgroundView
        }
        if let collectionView = self.collectionView {
            collectionView.backgroundView = self.backgroundView
            self.backgroundNavigationBar?.shadowImage = UIImage()
            self.backgroundNavigationBar?.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    private func getRandomColor() -> UIColor{
        return UIColor(red:0.31, green:0.25, blue:0.21, alpha:1.0)
    }
}
