//
//  EnterPasswordViewController.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class EnterPasswordViewController: NSViewController{
    var delegate: ImportDelegate?
    
    @IBOutlet weak var btnOK: NSButton!
    @IBOutlet weak var txtPassword: NSSecureTextField!
    
    @IBAction func OnOkAction(_ sender: Any) {
        let password = txtPassword.stringValue
        
        if password.characters.count < 5 {
            UserInteraction.alert(with: "Password is too short. Use more than 5 characters.", style: NSAlertStyle.warning)
        }
        else {
            if (CheckPassword(url: Utils.GetFileUrl(path: Safe.SafeFileName)!, password: password))
            {
                delegate?.FinishImported(password: password)
                dismiss(self)
            }
            else {
                UserInteraction.alert(with: "Wrong password to access the Safe. \n Please enter a correct password.", style: NSAlertStyle.warning)
            }
        }
        
    }
    
    override func viewDidLoad() {
        self.title = "Enter Password"
    }
    
    func CheckPassword(url: URL, password: String) -> Bool
    {
        var cryptedPass = try? String(contentsOf: url, encoding: String.Encoding.utf8)
        cryptedPass = String(cryptedPass!.characters.prefix(40))
        if cryptedPass == password.sha1() {
            return true
        }
        else {
            return false
        }
    }
    
}
