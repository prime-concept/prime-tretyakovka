//
//  AddCardVC.swift
//  TretGall
//
//  Created by Александр Сабри on 29.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//
import CoreData
import UIKit

class AddCardVC: UIViewController {
    
    var cardArray: [NSManagedObject] = []

    @IBOutlet weak var card_number: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func card_type(_ sender: Any) {
        
        let alert = UIAlertController(title: "Типы карт",
                                      message: "К сожалению, приложение пока поддерживает только карты членов клуба PRIME Concept",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    
    func validate(value: String) -> Bool {
        print("validate emilId: \(value)")
        print(value.characters.count)
        if value.characters.count >= 9 && value.characters.count <= 16{
            return true
        }
        else{
            return false
        }
    }
    
    
    @IBAction func Exitbutton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save_button(_ sender: Any) {
         let name = card_number.text ?? "0000"
        
        if validate(value: name){
            print(name)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Cards",
                                                    in: managedContext)!
            
            let cardnum = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
            
            
            
            cardnum.setValue(name, forKeyPath: "number")
            
            do {
                try managedContext.save()
                cardArray.append(cardnum)
                self.dismiss(animated: true, completion: nil)
                print(cardArray)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else{
            card_number.text = ""
            print("invalide EmailID")
            let alert = UIAlertController(title: "Ошибка", message: "Некорректный номер карты", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
