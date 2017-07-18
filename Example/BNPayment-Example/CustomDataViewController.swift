//
//  DeveloperViewController.swift
//  BNPayment-Example
//
//  Created by Chen LIN on 1/6/17.
//  Copyright © 2017 Bambora. All rights reserved.
//

import UIKit

class CustomDataViewController: UIViewController {
   
   
    @IBOutlet weak var btnSaveData: UIButton!
    @IBOutlet weak var tvEditor: UITextView!
    
    
    @IBOutlet weak var scType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let json = AppSettings.sharedInstance().retrieveJsonDataforKey(kRegistrationData), JSONSerialization.isValidJSONObject(json) {
            
            tvEditor.text = stringify(json: json)
        }
    }
    
    @IBAction func scTypeChanged(_ sender: Any) {
        let sc = sender as! UISegmentedControl
        
        tvEditor.resignFirstResponder()
        
        if let json = AppSettings.sharedInstance().retrieveJsonDataforKey( sc.selectedSegmentIndex == 0 ? kRegistrationData : kPaymentData), JSONSerialization.isValidJSONObject(json) {
            
            tvEditor.text = stringify(json: json)
        }
    }

    
    @IBAction func saveData(_ sender: Any) {
        if scType.selectedSegmentIndex == 0 {
            validateThenSave(tf:tvEditor, key:kRegistrationData);
            
            if let json = AppSettings.sharedInstance().retrieveJsonDataforKey( kRegistrationData), JSONSerialization.isValidJSONObject(json) {
                
                BNRegisterCCParams.setRegistrationJsonData(json)
            }
            
          } else {
            validateThenSave(tf:tvEditor, key:kPaymentData);
        }
    }
    
    func stringify(json: Any) -> String
    {
        if JSONSerialization.isValidJSONObject(json) {
            
            do {
                let prettyJsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                let prettyPrintedJson = NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)!
                
                return prettyPrintedJson as String
            } catch {
                print("json error: \(error)")
            }
        }
        return ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func validateThenSave(tf:UITextView, key:String) {
        let jsonText = tf.text
        
        print("\(key) data:\n \(jsonText)")
        
        tf.resignFirstResponder()
        
        if let data = jsonText?.data(using: String.Encoding.utf8) {
            
            do {
                let _:[String:AnyObject]? = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                
                AppSettings.sharedInstance().persistJsonDataRegistration(jsonText, forKey: key)
                
            } catch let error as NSError {
                print(error)
                let title = "JSON Error"
                let message = error.localizedDescription
                
                let alertController = UIAlertController(
                    title: title,
                    message:message,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                
                let cancelAction = UIAlertAction(
                title: "OK", style: UIAlertActionStyle.default) { (action) in
                    if let json = AppSettings.sharedInstance().retrieveJsonDataforKey(key), JSONSerialization.isValidJSONObject(json) {
                        
                        tf.text = self.stringify(json: json)
                    }                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
