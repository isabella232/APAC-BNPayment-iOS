//
//  CardsTableViewCell.swift
//  BNPayment-Example
//
//  Created by Max Mattini on 28/03/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit

class CardsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblCvc: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    
    @IBOutlet weak var lblCardHolder: UILabel!
    @IBAction func btnDeleteAction(_ sender: Any) {
        BNPaymentHandler.sharedInstance().remove(card)
        NotificationCenter.default.post(name: .refreshCards, object: nil)
    }
    
    @IBAction func btnAliasAction(_ sender: Any) {
    }
    
    @IBOutlet weak var btnAlias: UIButton!
    
    var card:BNAuthorizedCreditCard? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(card: BNAuthorizedCreditCard)
    {
        self.card = card
        lblCardNumber.text = card.creditCardNumber
        
        if let mm = card.creditCardExpiryMonth, let yy = card.creditCardExpiryYear {
            lblExpiry.text = "\(mm)/\(yy)"
        }
        lblCvc.text = card.creditCardAlias
        
        if let cardHolder = card.creditCardHolder {
            lblCardHolder.text = cardHolder

        }
        
        
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Notification.Name {
    static let refreshCards = Notification.Name("refreshCards")
}

