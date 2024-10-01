//
//  TicketsTableViewCell.swift
//  TretGall
//
//  Created by Александр Сабри on 27.11.2017.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

struct  Tickets {
    var names: String
    var adress: String
    var image: String
    var date: String
    var ticket: String
}


class TicketsTableViewCell: UITableViewCell {
    
    var TiketsDetail: Tickets? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(){
        if let name = TiketsDetail?.names {
            nameLabel.setTitle(name, for: .normal)
        }
        if let date_from = TiketsDetail?.date {
            
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "ru") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let date = dateFormatter.date(from: date_from)!
            dateFormatter.dateFormat = "d MMM yyyy"
//            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)

            dateLabel.text = dateString
        }
        if let adress = TiketsDetail?.adress{
            if adress == "null"{
                adressLabel.text = " "
            } else {
                adressLabel.text = adress
            }
            
        }
        
        if let image = TiketsDetail?.image{
            if image == "null" {
                imageview.image = #imageLiteral(resourceName: "T_ticket_plug-1")
            } else {
                let image_url = image
                let baseurl = "https://primepass.ru/p/450x620/"
                let full_url = "\(baseurl)\(image_url)"
                let url = URL(string: full_url)
                let data = try? Data(contentsOf: url!)
                imageview.image = UIImage(data: data!)
            }
            
    }
    

}
}
 // convert date to string with userdefined format.

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
