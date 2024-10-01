//
//  LoyaltyCardsCVC.swift
//  TretGall
//
//  Created by Александр Сабри on 22.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import Foundation
import CoreData


struct CardInfo {
    var color: UIColor
    var icon: UIImage
}

class ExampleViewController : UICollectionViewController, HFCardCollectionViewLayoutDelegate {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    @IBOutlet weak var AddCard: UIBarButtonItem!
    @IBOutlet var backgroundView: UIView?
    @IBOutlet var backgroundNavigationBar: UINavigationBar?
    var label = UILabel()
    var container = UIView()
    
    var cardLayoutOptions: CardLayoutSetupOptions?
    var shouldSetupBackgroundView = false
    
    var cardArray: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupExample()
        
        
    }
    
    
    @IBAction func addCardAction(_ sender: Any) {
        
        checkCardNumber()
        
    }
    
    func checkCardNumber(){
        let cardsNumber = cardArray.count
        if cardsNumber >= 1 {
            let alert = UIAlertController(title: "Ошибка", message: "К сожалению, вы можете сохранять только одну карту клуба PRIME, остальные карты пока не поддерживаются", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "mySegueID", sender: nil)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()
        
        print(cardArray)
        
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
        
        
        
        func someEntityExists(id: Int) -> Bool {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            fetchRequest.includesSubentities = false
            
            var entitiesCount = 0
            
            do {
                entitiesCount = try managedContext.count(for: fetchRequest)
            }
            catch {
                print("error executing fetch request: \(error)")
            }
            
            return entitiesCount > 0
        }
        
        
        
        print(cardArray)
        
    
       labelText()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    func labelText(){
        
            container = UIView(frame: CGRect(x: 20, y: 0, width: 300, height: 200))
            
            label.text = "У вас пока нет сохраненных карт лояльности. Добавьте, нажав на плюс"
            label.textColor = .black
            label.numberOfLines = 3
            label.lineBreakMode = .byWordWrapping
            label.frame = container.frame
            label.center = container.center
        
        if cardArray.count == 0 {
            container.addSubview(label)
            self.view.addSubview(container)
        } else {
            container.removeFromSuperview()
            label.removeFromSuperview()
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
            cell.cardIsRevealed(true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(cardArray.count)
        return self.cardArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ExampleCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.backgroundColor = UIColor(red:0.31, green:0.25, blue:0.21, alpha:1.0)
        cell.labelText?.text = card.value(forKeyPath: "number") as? String
        cell.cardNUmber = card.value(forKeyPath: "number") as? String
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let card = cardArray[indexPath.row]
        let number = card.value(forKeyPath: "number") as? String
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
        let alertController = UIAlertController(title: "Prime Card", message: "Редактирование карты клуба Prime", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text!)
            self.updateTask(uuid: firstTextField.text! )


        })
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .default, handler: {
            alert -> Void in
            self.deleteTask(withUUID: number!)
            self.labelText()
        })
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
            textField.text = number
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func deleteTask(withUUID: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Cards>(entityName: "Cards")
        do {
            let searchResults = try managedContext.fetch(request)
            for task in searchResults {
                if task.number == withUUID {
                    // delete task
                    managedContext.delete(task)
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        cardArray.remove(at: 0)
        collectionView?.reloadData()
    }
    
    func updateTask(uuid: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Cards>(entityName: "Cards")
       
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Cards", in: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
             let result = try managedContext.fetch(fetchRequest)
            let person = result[0] as! NSManagedObject
            person.setValue(uuid, forKey: "number")
            
            try person.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        
        
        
        self.collectionView?.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = self.cardArray[sourceIndexPath.item]
        self.cardArray.remove(at: sourceIndexPath.item)
        self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }
    
    
    
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
