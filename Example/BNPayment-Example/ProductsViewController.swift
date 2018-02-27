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
    
    @IBAction func btnPayYourBillAction(_ sender: Any) {registerOrSelectCard(amount: 12000, comment:"Pay Your Bill")}
    @IBAction func btnPaySimcardAction(_ sender: Any) {registerOrSelectCard(amount: 5000, comment:"Pay Simcard")}
    @IBAction func btnOneYearPlanAction(_ sender: Any) {registerOrSelectCard(amount: 1200, comment:"One Year Plan")}
    @IBAction func btnTwoYearPlan(_ sender: Any) {registerOrSelectCard(amount: 1000, comment:"Two Year Plan")}
    
    func completeCardRegistration(p1:BNCCRegCompletion, p2:BNAuthorizedCreditCard?) ->Void
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func registerOrSelectCard(amount:NSNumber, comment:String) -> Void{
        if let _ = BNPaymentHandler.sharedInstance().authorizedCards()     {
            
            let parameters:[String:Any] = ["amount":amount, "comment":comment]
            
             self.performSegue(withIdentifier: "toCardView", sender: parameters)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCardView" {
            if let cardVC = segue.destination as? CardsViewController {
                let parameters = sender as! [String:Any]
                cardVC.amount = parameters["amount"] as! NSNumber
                cardVC.comment = parameters["comment"] as! String
            }
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
