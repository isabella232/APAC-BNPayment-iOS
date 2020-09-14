//
//  CardsTableViewCell.swift
//  BNPayment-Example
//
//  Created by Max Mattini on 28/03/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit
import BNPayment

class CardsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnPreAuth: UIButton!
    
    @IBOutlet weak var lblCardHolder: UILabel!
    @IBAction func btnDeleteAction(_ sender: Any) {
        BNPaymentHandler.sharedInstance().remove(card)
        NotificationCenter.default.post(name: .refreshCards, object: nil)
    }
    
    @IBAction func btnAliasAction(_ sender: Any) {
    }
    
    @IBOutlet weak var btnAlias: UIButton!
    
    var card:BNAuthorizedCreditCard? = nil
    var paymentParams: BNPaymentParams? = nil
    var cardViewContoller: CardsViewController? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Define parent view controller.
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    public func configure(card: BNAuthorizedCreditCard, paymentParam: BNPaymentParams)
    {
        self.card = card
        self.paymentParams = paymentParam
        lblCardNumber.text = card.creditCardNumber
        
        
        if let mm = card.creditCardExpiryMonth, let yy = card.creditCardExpiryYear {
            lblExpiry.text = "\(mm)/\(yy)"
        }
        lblType.text = card.creditCardType
        lblType.isHidden = false
        
        if let cardHolder = card.creditCardHolder {
            lblCardHolder.text = cardHolder

        }
    }
    
    //PreAuth button click handler.
    @IBAction func btnPreAuthAction(_ sender: Any) {
        //submit PreAuth token.
        BNPaymentHandler.sharedInstance().submitPreAuthToken(paymentParams, requirePaymentValidation:AppSettings.sharedInstance().touchIDMode){
            (response: [String:String]?, result:BNPaymentResult , error:Error?) -> Void in
            //display message.
            if let cardsViewController = self.parentViewController as? CardsViewController {
               cardsViewController.displayStatus(response: response, result:result ,
                                              paymentType:PreAuthToken,  error:error)
            }
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

