//
//  SetPasswordViewController.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 20.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class SetPasswordViewController: NSViewController {

    var setPasswordDelegate: SetPasswordDelegate?
    var Password: String
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBOutlet weak var SetPasswordTextLabel: NSTextField!
    @IBOutlet weak var EnterPasswordLabel: NSTextField!
    @IBOutlet weak var VerifyPasswordLabel: NSTextField!
    @IBOutlet weak var SetPasswordField: NSSecureTextField!
    @IBOutlet weak var VerifyPasswordField: NSSecureTextField!
    @IBAction func OKButtonPressed(_ sender: Any) {
        if VerifyPasswordField.stringValue != SetPasswordField.stringValue {
            UserInteraction.alert(with: "Passwords do not much", style: NSAlertStyle.warning)
        }
        if SetPasswordField.stringValue.lengthOfBytes(using: String.Encoding.utf8) < 5 {
            UserInteraction.alert(with: "Password is too short", style: NSAlertStyle.warning)
        }
        
        self.dismiss(sender)
    }
    
}
