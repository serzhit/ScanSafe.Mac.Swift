//
//  UserInteraction.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 08.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class UserInteraction: NSObject {
    static let mainWin = NSApplication.shared().mainWindow
    
    
    static func alert(with: String, style: NSAlertStyle) {
        let alert = NSAlert()
        alert.alertStyle = style
        alert.messageText = "\(with)"
        alert.icon = NSImage(byReferencingFile: "Assets.xcassets/Appicon")
        alert.informativeText = "The Easy eCurrency for Everyone!"
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: mainWin!) { (returnCode: NSModalResponse) -> Void in
            print ("returnCode: ", returnCode)
        }
    }
    static func YesNoAlert(with: String, style: NSAlertStyle) -> NSModalResponse {
        let alert = NSAlert()
        alert.alertStyle = style
        alert.messageText = "\(with)"
        alert.icon = NSImage(byReferencingFile: "Assets.xcassets/Appicon")
        alert.informativeText = "The Easy eCurrency for Everyone!"
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        return alert.runModal()
    }
}

class SetPassword: SetPasswordDelegate {
    let mainWin = NSApplication.shared().mainWindow
    let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SetPassword") as! SetPasswordViewController
    var isPasswordSet:Bool = false
    var Password: String = ""
    
    init() {
        mainWin!.contentViewController!.presentViewControllerAsSheet(viewController)
        viewController.viewWillDisappear()
    }
    
    func PasswordHasBeenSet() {
        isPasswordSet = true
        Password = viewController.SetPasswordField.stringValue
    }
}
