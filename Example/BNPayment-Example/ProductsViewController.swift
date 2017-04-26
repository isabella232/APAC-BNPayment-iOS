//
//  ProductsViewController.swift
//  BNPayment-Example
//
//  Created by Max Mattini on 27/03/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnPayYourBill: UIButton!
    @IBOutlet weak var btnPaySimcard: UIButton!
    @IBOutlet weak var btnOneYearPlan: UIButton!
    @IBOutlet weak var btnTwoYearPlan: UIButton!
    
    @IBAction func btnPayYourBillAction(_ sender: Any) {registerOrSelectCard()}
    
    @IBAction func btnPaySimcardAction(_ sender: Any) {registerOrSelectCard()}
    
    @IBAction func btnOneYearPlanAction(_ sender: Any) {registerOrSelectCard()}
    
    @IBAction func btnTwoYearPlan(_ sender: Any) {registerOrSelectCard()}
    
    func completeCardRegistration(p1:BNCCRegCompletion, p2:BNAuthorizedCreditCard?) ->Void
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func registerOrSelectCard() -> Void{
        if let _ = BNPaymentHandler.sharedInstance().authorizedCards()     {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsViewController")
            if let nav = self.navigationController {
                 nav.pushViewController(vc, animated: true)
            }
        }
    }
    
    func OLD_registerOrSelectCard() -> Void{
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards(),  authorizedCards.count > 0      {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsViewController")
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            }
        } else {
            
            let alertController = UIAlertController(
                title: "No credit card registered",
                message: "Please press 'Add' to register a card.\n No credit card details will be saved on the device",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let addAction = UIAlertAction(
                title: "Add",
                style: UIAlertActionStyle.destructive) { (action) in
                    
                    let vc = BNCreditCardRegistrationVC()
                    vc.completionBlock = self.completeCardRegistration;
                    
                    if let nav = self.navigationController {
                        nav.pushViewController(vc, animated: true)
                    }
            }
            
            let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
