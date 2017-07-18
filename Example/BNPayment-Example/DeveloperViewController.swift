//
//  File.swift
//  BNPayment-Example
//
//  This developer view is no longer the previous developer view.
//  The previous developer view now called CustomDataView.
//
//  Copyright © 2017 Bambora. All rights reserved.
//


import UIKit

class DeveloperViewController: UIViewController {
    
    
    @IBOutlet weak var segRunMode: UISegmentedControl!
    @IBOutlet weak var txtMerchantGuid: UITextField!
    
    @IBOutlet weak var rdTouchId: UISwitch!
    @IBOutlet weak var rdVelocity: UISwitch!
    @IBOutlet weak var lbVersion: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //load current mode.
        let currentRunMode: Int = AppSettings.sharedInstance().getRunMode();
        //init the segRunMode control.
        let segRunModeIndex: Int = currentRunMode - 1
        segRunMode.selectedSegmentIndex = segRunModeIndex
        //init the merchant guid text field.
        txtMerchantGuid.text = AppSettings.sharedInstance().getCurrentRunModeMerchantGuid();
        
        rdVelocity.isOn = AppSettings.sharedInstance().velocityMode;
        
        rdTouchId.isOn = AppSettings.sharedInstance().touchIDMode;
        
        let dictionary = Bundle.main.infoDictionary!;
        let version = dictionary["CFBundleShortVersionString"] as! String;
        let build = dictionary["CFBundleVersion"] as! String;
        
        lbVersion.text = "Version \(version)(\(build)) \(AppSettings.sharedInstance().getCompileDate())";
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
       
        let isValidMerchantGuid = isValidGuid(guid: txtMerchantGuid.text!)
        if(isValidMerchantGuid)
        {
            txtMerchantGuid.resignFirstResponder()
            //The segment button is the most accure source.
            let currentRunningMode: Int = segRunMode.selectedSegmentIndex + 1
            AppSettings.sharedInstance().setRunModeMerchantGuid(currentRunningMode, newMerchantGuid: txtMerchantGuid.text)
            //Alert pop up.
            let alertTitle: String = "Merchant Guid Updated."
            let alertMessage: String = "Merchant guid updated.\nPlease restart the app for the change to take effect"
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            //Okay action.
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: { _ in })
        }
        else{
            //Alert pop up.
            let alertTitle: String = "Invalid Format."
            let alertMessage: String = "Please enter valid guid format."
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            //Okay action.
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: { _ in })
        }
        
        
    }
    
    @IBAction func sgRunModeChange(_ sender: UISegmentedControl) {
        if (sender as? UISegmentedControl) == segRunMode {
            let changedRunMode: Int = segRunMode.selectedSegmentIndex + 1
            let currentMode: Int = AppSettings.sharedInstance().getRunMode()
            if changedRunMode != currentMode {
                
                
                //Alert pop up.
                let alertTitle: String = "Change Environment."
                let alertMessage: String = "All your saved cards will be deleted.\nPlease restart the app for the change to take effect"
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                //Okay action.
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.txtMerchantGuid.resignFirstResponder()
                    
                    let url1: String = AppSettings.sharedInstance().getRunModeUrl()
                    AppSettings.sharedInstance().setRunMode(changedRunMode)
                    self.txtMerchantGuid.text = AppSettings.sharedInstance().getMerchantGuid(changedRunMode)
                    let cards  = BNPaymentHandler.sharedInstance().authorizedCards()
                    for card: BNAuthorizedCreditCard in cards! {
                        BNPaymentHandler.sharedInstance().remove(card)
                        AppSettings.sharedInstance().decrementNumberOfSavedCard()
                    }
                    let url2: String = AppSettings.sharedInstance().getRunModeUrl()
                    print("New url '\(url2)' <- Old url '\(url1)'")
                })
                //Cancel action.
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.segRunMode.selectedSegmentIndex = currentMode - 1
                    
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: { _ in })
            }
        }
    }
 
   
    @IBAction func rdTouchIdChange(_ sender: Any) {
        AppSettings.sharedInstance().setTouchIDMode(rdTouchId.isOn, newRunMode: AppSettings.sharedInstance().getRunMode());
    }
    
   
    @IBAction func rdVelocityChange(_ sender: Any) {
         AppSettings.sharedInstance().setVelocityMode(rdVelocity.isOn, newRunMode: AppSettings.sharedInstance().getRunMode());
    }
    
    
    @discardableResult func isValidGuid(guid: String) -> Bool {
         let guidPred = NSPredicate(format: "SELF MATCHES %@", "((\\{|\\()?[0-9a-fA-F]{8}-?([0-9a-fA-F]{4}-?){3}[0-9a-fA-F]{12}(\\}|\\))?)|(\\{(0x[0-9a-fA-F]+,){3}\\{(0x[0-9a-fA-F]+,){7}0x[0-9a-fA-F]+\\}\\})")
        if(guidPred.evaluate(with: guid)){
            return true;
        }
        return false
    }
    
};
