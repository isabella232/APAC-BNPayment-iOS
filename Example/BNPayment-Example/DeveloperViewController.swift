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
    
    //registration form customisation.
    @IBOutlet weak var txtRegistrationFormTitle: UITextField!
    @IBOutlet weak var txtRegistrationCardHolderName: UITextField!
    @IBOutlet weak var txtRegistrationCardNumber: UITextField!
    @IBOutlet weak var txtRegistrationExpiryDate: UITextField!
    @IBOutlet weak var txtRegistrationSecurityCode: UITextField!
    @IBOutlet weak var txtRegistrationButtonColor: UITextField!
    @IBOutlet weak var txtRegistrationButtonText: UITextField!
    
    //submit single card payment form customisation.
    @IBOutlet weak var txtPaymentFormTitle: UITextField!
    @IBOutlet weak var txtPaymentCardHolderName: UITextField!
    @IBOutlet weak var txtPaymentCardNumber: UITextField!
    @IBOutlet weak var txtPaymentExpiryDate: UITextField!
    @IBOutlet weak var txtPaymentSecurityCode: UITextField!
    @IBOutlet weak var txtPaymentButtonColor: UITextField!
    @IBOutlet weak var txtPaymentButtonText: UITextField!
    @IBOutlet weak var txtPaymentSwitchButtonColor: UITextField!
   
    
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
        
        //init customisation settings.
        initCardRegistrationGuiSetting()
        initSubmitSinglePaymentSetting()
        
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
    
    
    @IBAction func btnSaveGuiCustomisation(_ sender: UIButton) {
        //Card registration customisation.
        saveCardRegistrationGuiCustomisation()
        //Submit single card payment customisation.
        saveSubmitSinglePaymentCustomisation()
        let alertTitle: String = "Gui Customisation Updated."
        let alertMessage: String = "Gui customisation updated.\nPlease go to the form to check the change"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        //Okay action.
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: { _ in })
        
    }
    
    func saveCardRegistrationGuiCustomisation()
    {
        let cardRegistrationGuiSetting: BNCardRegistrationGuiSetting = BNCardRegistrationGuiSetting()
        cardRegistrationGuiSetting.titleText = txtRegistrationFormTitle.text
        cardRegistrationGuiSetting.cardHolderWatermark = txtRegistrationCardHolderName.text
        cardRegistrationGuiSetting.cardNumberWatermark = txtRegistrationCardNumber.text
        cardRegistrationGuiSetting.expiryDateWatermark = txtRegistrationExpiryDate.text
        cardRegistrationGuiSetting.securityCodeWatermark = txtRegistrationSecurityCode.text
        cardRegistrationGuiSetting.registrationButtonColor = txtRegistrationButtonColor.text
        cardRegistrationGuiSetting.registerButtonText = txtRegistrationButtonText.text
        AppSettings.sharedInstance().setCardRegistrationGuiSetting(cardRegistrationGuiSetting)
    }

    func saveSubmitSinglePaymentCustomisation()
    {
        let submitSinglePaymentCardGuiSetting: BNSubmitSinglePaymentCardGuiSetting = BNSubmitSinglePaymentCardGuiSetting()
        submitSinglePaymentCardGuiSetting.titleText = txtPaymentFormTitle.text
        submitSinglePaymentCardGuiSetting.cardHolderWatermark = txtPaymentCardHolderName.text
        submitSinglePaymentCardGuiSetting.cardNumberWatermark = txtPaymentCardNumber.text
        submitSinglePaymentCardGuiSetting.expiryDateWatermark = txtPaymentExpiryDate.text
        submitSinglePaymentCardGuiSetting.payButtonColor = txtPaymentButtonColor.text
        submitSinglePaymentCardGuiSetting.payButtonText = txtPaymentButtonText.text
        submitSinglePaymentCardGuiSetting.securityCodeWatermark = txtPaymentSecurityCode.text
        submitSinglePaymentCardGuiSetting.switchButtonColor = txtPaymentSwitchButtonColor.text
        AppSettings.sharedInstance().setSubmitSinglePaymentCardGuiSetting(submitSinglePaymentCardGuiSetting)
    }
    
    
    func initCardRegistrationGuiSetting()
    {
        let cardRegistrationGuiSetting = AppSettings.sharedInstance().getCardRegistrationGuiSetting()
        txtRegistrationFormTitle.text = cardRegistrationGuiSetting?.titleText;
        txtRegistrationCardHolderName.text = cardRegistrationGuiSetting?.cardHolderWatermark
        txtRegistrationCardNumber.text = cardRegistrationGuiSetting?.cardNumberWatermark
        txtRegistrationExpiryDate.text = cardRegistrationGuiSetting?.expiryDateWatermark
        txtRegistrationSecurityCode.text = cardRegistrationGuiSetting?.securityCodeWatermark
        txtRegistrationButtonColor.text = cardRegistrationGuiSetting?.registrationButtonColor
        txtRegistrationButtonText.text = cardRegistrationGuiSetting?.registerButtonText
    }
    
    func initSubmitSinglePaymentSetting()
    {
        let submitSinglePaymentCardGuiSetting = AppSettings.sharedInstance().getSubmitSinglePaymentGuiSetting()
        txtPaymentFormTitle.text = submitSinglePaymentCardGuiSetting?.titleText
        txtPaymentCardHolderName.text = submitSinglePaymentCardGuiSetting?.cardHolderWatermark
        txtPaymentCardNumber.text = submitSinglePaymentCardGuiSetting?.cardNumberWatermark
        txtPaymentExpiryDate.text = submitSinglePaymentCardGuiSetting?.expiryDateWatermark
        txtPaymentButtonColor.text = submitSinglePaymentCardGuiSetting?.payButtonColor
        txtPaymentButtonText.text = submitSinglePaymentCardGuiSetting?.payButtonText
        txtPaymentSecurityCode.text = submitSinglePaymentCardGuiSetting?.securityCodeWatermark
        txtPaymentSwitchButtonColor.text = submitSinglePaymentCardGuiSetting?.switchButtonColor
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
