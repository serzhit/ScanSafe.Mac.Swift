//
//  NewPasswordViewController.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class NewPasswordViewController: NSViewController{
    @IBOutlet weak var lblExplain: NSScrollView!
    @IBOutlet weak var txtPassword: NSSecureTextField!
    @IBOutlet weak var txtVerifyPassword: NSSecureTextField!
    
    @IBAction func OnOkAction(_ sender: AnyObject) {
        if txtPassword.stringValue.characters.count < 5 {
            UserInteraction.alert(with: "Password is too short. Use more than 5 characters.", style: NSAlertStyle.warning)
        }
        else if txtPassword.stringValue != txtVerifyPassword.stringValue {
            UserInteraction.alert(with: "Passwords don't match.", style: NSAlertStyle.warning)
        }
        else {
            UserInteraction.password = txtPassword.stringValue
            
            let safeContentVC = self.storyboard?.instantiateController(withIdentifier: "SafeContentViewController") as? SafeContentViewController
            self.presentViewControllerAsModalWindow(safeContentVC!);
            
            dismiss(self)
        }
    }

    override func viewDidLoad() {
        lblExplain.layer?.borderWidth = 0.0
        lblExplain.layer?.masksToBounds = true
    }
}
