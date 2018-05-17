//
//  CardsViewController.swift
//  BNPayment-Example
//
//  Created by Max Mattini on 27/03/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit
import LocalAuthentication

class CardsViewController: UIViewController {

    
    @IBOutlet weak var lblSavedCreditCards: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnNonRecurringPayment: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    public var  amount:NSNumber = 100
    public var  comment:String = ""
    
    // Used in one-time payment
    private var tmpCard:BNAuthorizedCreditCard?
    let notificationName = Notification.Name("refreshCards")
    
    
    // MARK: - Life cycle
    
    
    @IBOutlet weak var addCardButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title=self.comment
        
        let btndAddCard = UIButton(type: .custom)
        btndAddCard.setImage(UIImage(named: "addcard"), for: .normal)
        btndAddCard.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btndAddCard.addTarget(self, action: #selector(CardsViewController.addCard), for: .touchUpInside)
        let containVew = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
        containVew.addSubview(btndAddCard)
        addCardButton.customView=containVew
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
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
        let guiSetting = AppSettings.sharedInstance().getCardRegistrationGuiSetting();
        vc.guiSetting = guiSetting;
        vc.completionBlock = self.completeCardRegistrationBlock;
        
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
        
    }
    


    
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
    
   
    @IBAction func btnAddCardPreAuth(_ sender: Any) {

        let vc = BNSubmitSinglePaymentCardVC()
        let guiSetting = AppSettings.sharedInstance().getSubmitSinglePaymentGuiSetting();
        vc.guiSetting = guiSetting;
        vc.paymentType = PreAuthCard;
        vc.isRequirePaymentAuthorization = AppSettings.sharedInstance().touchIDMode
        let paymentParams:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters(amount, comment:"This is a test preAuth!", token:"");
        
        vc.paymentParams = paymentParams;
        vc.completionBlock = self.completeNonRecurringPaymentBlock;
        
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - actions
    @IBAction func btnNonRecurringPaymentAction(_ sender: Any) {
        
     //   stopUI()
        
        let vc = BNSubmitSinglePaymentCardVC()
        let guiSetting = AppSettings.sharedInstance().getSubmitSinglePaymentGuiSetting();
        vc.guiSetting = guiSetting;
        vc.paymentType = SubmitPaymentCard;
        vc.isRequirePaymentAuthorization = AppSettings.sharedInstance().touchIDMode
        let paymentParams:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters(amount, comment:comment, token:"");
        
        vc.paymentParams = paymentParams;
        vc.completionBlock = self.completeNonRecurringPaymentBlock;
        vc.enableVisaCheckout = AppSettings.sharedInstance().getVisaCheckoutMode()
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    
    
    private func completeNonRecurringPaymentBlock(response:[String:String]?, authorizedCreditCard:BNAuthorizedCreditCard?,  result:BNPaymentResult, error :Error?) ->Void
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        
        tableView.reloadData()
        
        self.displayStatus(response: response, result:result ,
                           paymentType:SubmitPaymentCard, error:error);
        return
        
        
    }
    
    
    
    private func buildAuthorisationErrorMessage(error:Error?) -> String
    {
        var message =  ""
        if let error = error {
            switch error._code {
            case LAError.Code.systemCancel.rawValue:
                message +=  " Session cancelled. " +  error.localizedDescription
            case LAError.Code.userCancel.rawValue:
                message +=  " Please try again. " +  error.localizedDescription
            case LAError.Code.userFallback.rawValue:
                message += " Authentication" + " Password option selected"

            case LAError.Code.touchIDNotEnrolled.rawValue:
                message += "TouchID is not enrolled. " + error.localizedDescription
            case LAError.Code.passcodeNotSet.rawValue:
                message += "A passcode has not been set. " +  error.localizedDescription
            default:
                message += "Authentication failed. " +  error.localizedDescription
            }
        }
        return message
    }

    
    private func buildErrorMessage( paymentIsNotAuthorised: Bool ,paymentType: PaymentType, error:Error?) -> String
    {
        let paymentTypeText = BNPaymentType.getDisplayText(by: paymentType);
        
        var message =  paymentIsNotAuthorised ? "" : "The "+paymentTypeText!+" did not succeed: "
        if let error = error {
            if !paymentIsNotAuthorised {
                message = message + error.localizedDescription
            } else {
                
                switch error._code {
                case LAError.Code.systemCancel.rawValue:
                    message +=  " Session cancelled. " +  error.localizedDescription
                case LAError.Code.userCancel.rawValue:
                    message +=  " Please try again. " +  error.localizedDescription
                case LAError.Code.userFallback.rawValue:
                    message += " Authentication" + " Password option selected"
                
                case LAError.Code.touchIDNotEnrolled.rawValue:
                   message += "TouchID is not enrolled. " + error.localizedDescription
                case LAError.Code.passcodeNotSet.rawValue:
                    message += "A passcode has not been set. " +  error.localizedDescription
                default:
                    message += "Authentication failed. " +  error.localizedDescription
                }
            }
        }
        return message
    }
    
    
    public func displayStatus(response: [String:String]?, result:BNPaymentResult ,
                                         paymentType:PaymentType, error:Error?)
    {
        
        let success = (result == BNPaymentSuccess)
        let paymentNotAuthorised = (result == BNPaymentNotAuthorized)
        let paymentTypeText = BNPaymentType.getDisplayText(by: paymentType);
        let title = success ? "Success" : (paymentNotAuthorised ? (paymentTypeText!+" Not Authorised") : "Failure")
        var receipt = "?"
        if let response = response, let r = response["receipt"] {
            receipt = r
        }
        let message = success ? "The "+paymentTypeText!+" succeeded. Receipt:\(receipt)" : (paymentNotAuthorised ? buildAuthorisationErrorMessage(error: error) : BNHTTPResponseSerializer.buildBackendErrorMessage(error:error)
        )
        notifyUser(title, message: message)
    }
    
    private func notifyUser(_ title: String, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension CardsViewController: UITableViewDelegate
{
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let _cell = cell as! CardsTableViewCell
        _cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.lightGray : UIColor.gray
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        tableView.deselectRow(at: indexPath, animated: true)
        if let authorizedCards = BNPaymentHandler.sharedInstance().authorizedCards()  {
            
            let card =  authorizedCards[ indexPath.row]
            submitPaymentToken(card: card)
        }
    }
    
    private func submitPaymentToken(card: BNAuthorizedCreditCard)
    {
        
        let params:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters(amount, comment:comment, token:card.creditCardToken)
        
        stopUI()
        BNPaymentHandler.sharedInstance().makePaymentExt(with: params, requirePaymentValidation:AppSettings.sharedInstance().touchIDMode){
            (response: [String:String]?, result:BNPaymentResult , error:Error?) -> Void in
            
            self.startUI()
            self.displayStatus(response: response, result:result ,
                               paymentType:SubmitPaymentToken, error:error)
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
            let params:BNPaymentParams = AppSettings.sharedInstance().createMockPaymentParameters(amount, comment:comment, token:card.creditCardToken)
            
            cell.configure(card: card, paymentParam: params)

        }

        return cell
    }
}


public extension BNHTTPResponseSerializer
{
    public class func extractBackendErrorMessage(error:Error?) -> (NSNumber, String, String, String)
    {
        if let nserror = error as? NSError {
            
            let userInfo = nserror.userInfo
            
            if let jsonText = userInfo[BNResponseSerializationErrorDataString] as? String {
                
                if let data = jsonText.data(using: String.Encoding.utf8) {
                    
                    do {
                        let dict:[String:AnyObject]? = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        
                        let status = dict?["status"] as? NSNumber ?? NSNumber(value: 0)
                        let title = dict?["title"] as? String ?? ""
                        let type = dict?["type"] as? String ?? ""
                        let detail = dict?["detail"] as? String ?? ""
                        
                        return (status, title, type, detail)
                    } catch  {
                        return (0, "", "", "")
                    }
                }
            }
        }
        return (0, "", "", "")
    }
    
    public class func buildBackendErrorMessage(error:Error?) -> String
    {
        let (status, title, type, detail) = self.extractBackendErrorMessage(error:error)
        if (status != 0)
        {
            return "status:\(status) title:\(title) type:\(type)\ndetail:\(detail)"
        }
        return "?"
    }
    
    public class func extractBackendErrorDetails(error:Error?) -> String
    {
        if let nserror = error as? NSError {
            
            let userInfo = nserror.userInfo
            
            if let jsonText = userInfo[BNResponseSerializationErrorDataString] as? String {
                
                if let data = jsonText.data(using: String.Encoding.utf8) {
                    
                    do {
                        let dict:[String:AnyObject]? = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        let detail = dict?["Detail"] as? String ?? ""
                        
                        return (detail)
                    } catch  {
                        return ("")
                    }
                }
            }
        }
        return ("")
    }
    
}


