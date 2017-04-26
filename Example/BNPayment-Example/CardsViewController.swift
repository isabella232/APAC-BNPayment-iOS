//
//  CardsViewController.swift
//  BNPayment-Example
//
//  Created by Max Mattini on 27/03/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit


class CardsViewController: UIViewController {

    let notificationName = Notification.Name("refreshCards")
    
    @IBOutlet weak var lblSavedCreditCards: UILabel!
    // Used in one-time payment
    private var tmpCard:BNAuthorizedCreditCard?
    

   
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnNonRecurringPayment: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btndAddCard = UIButton(type: .custom)
        btndAddCard.setImage(UIImage(named: "addcard"), for: .normal)
        btndAddCard.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btndAddCard.addTarget(self, action: #selector(CardsViewController.addCard), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btndAddCard)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        let contentInsets = UIEdgeInsets(top: -64.0, left: 0.0, bottom: 0, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.estimatedRowHeight = 200.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.reloadData()
        
        activityIndicator.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func updateMessage() {
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards()  {
            
            if authorizedCards.count > 0 {
                lblSavedCreditCards.text = "Click any of the saved cards below to pay."
            }
            else {
                lblSavedCreditCards.text = "No saved cards. Press + to register a card"
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(CardsViewController.refreshCards), name: notificationName, object: nil)
        
        updateMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    // MARK: - Start/top UI
    func stopUI()
    {
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func startUI()
    {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func inProgress() -> Bool
    {
        return activityIndicator.isAnimating
    }
    
    // MARK: - selectors
    
    public func refreshCards(notification:Notification) {
        tableView.reloadData()
        updateMessage()
    }
    
    public func addCard() {
        let vc = BNCreditCardRegistrationVC()
        vc.completionBlock = self.completeCardRegistrationBlock;
        
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    // MARK : - completion blocks
    
    private func completeCardRegistrationBlock(p1:BNCCRegCompletion, card:BNAuthorizedCreditCard?) ->Void
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        tableView.reloadData()
        guard let _ = card else {
            let title = "No card"
            let message = "No credit card was registered!"
            
            let alertController = UIAlertController(
                title: title,
                message:message,
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
    }
    
    private func temporaryCardRegistrationBlock(p1:BNCCRegCompletion, card:BNAuthorizedCreditCard?) ->Void
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        if let temporaryCard = card {
            makeOnePaymentWithCard(card: temporaryCard)
        } else {
            startUI()
            let title = "Card"
            let message = "Card was not accepted!"
            
            let alertController = UIAlertController(
                title: title,
                message:message,
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    // MARK: - actions
    @IBAction func btnNonRecurringPaymentAction(_ sender: Any) {
        
        stopUI()
        
        let vc = BNCreditCardRegistrationVC()
        vc.completionBlock = self.temporaryCardRegistrationBlock;
        
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    private func sampleObject(card: BNAuthorizedCreditCard) -> BNPaymentParams
    {
        
      let param = BNPaymentParams.init(id: "id", currency: "AUD", amount: 100, token: card.creditCardToken, comment: "Test")
      return param!
    }
   
    
    private func makeOnePaymentWithCard(card: BNAuthorizedCreditCard)
    {
        let params:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters()
        params.token = card.creditCardToken
        
        tmpCard = card
        
        BNPaymentHandler.sharedInstance().makePaymentExt(with: params) {
            (response: [String:String]?, result:BNPaymentResult , error:Error?) -> Void in
            
            self.startUI()
            let success = (result == BNPaymentSuccess)
            
            // unregister card
            if let theCard = self.tmpCard {
                
                BNPaymentHandler.sharedInstance().remove(theCard)
                self.tmpCard = nil
            }
            
            let title = success ? "Success" : "Failure"
            var receipt = "?"
            if let response = response, let r = response["receipt"] {
               receipt = r
            }
            let message = success ? "The one time payment succeeded. Receipt:\(receipt)":"The payment did not succeed."
            
            let alertController = UIAlertController(
                title: title,
                message:message,
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    let kApiSecret = "m6XiK8LIstRbW8m3h8f+OR4hYqaOCi6TydBN05K2/EM="
    let kApiKey = "1091f5106b7e43f18d2e5a1c611c0953"
    let customerNumber = "customer123"
    let customerReference = "customerRef123"
    
    let kSupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let kApplePayMerchantID = "merchant.com.ippayments.winkwink"
    
}



extension CardsViewController: UITableViewDelegate
{
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let _cell = cell as! CardsTableViewCell
        _cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.lightGray : UIColor.white
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        tableView.deselectRow(at: indexPath, animated: true)
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards()  {
            
            let card =  authorizedCards[ indexPath.row]
            makePaymentWithCard(card: card)
        }
    }
    
    private func makePaymentWithCard(card: BNAuthorizedCreditCard)
    {
        let params:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters()
        params.token = card.creditCardToken

        stopUI()
        BNPaymentHandler.sharedInstance().makePaymentExt(with: params){
            (response: [String:String]?, result:BNPaymentResult , error:Error?) -> Void in
            
            
            self.startUI()
            let success = (result == BNPaymentSuccess)
            let title = success ? "Success" : "Failure"
            var receipt = "?"
            if let response = response, let r = response["receipt"] {
                receipt = r
            }
            let message = success ? "The one time payment succeeded. Receipt:\(receipt)":"The payment did not succeed."
            
            let alertController = UIAlertController(
                title: title,
                message:message,
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension CardsViewController: UITableViewDataSource
{
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards()      {
           return   authorizedCards.count
        }
        return 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CardsTableViewCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
            as! CardsTableViewCell
 
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards()  {
 
            let card =  authorizedCards[ indexPath.row]
            cell.configure(card: card)

        }
 
        return cell
    }
}

