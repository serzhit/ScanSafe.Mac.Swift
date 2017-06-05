//
//  ExportViewController.swift
//  ScanSafe.Mac
//
//  Created by Donald on 6/3/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class ExportViewController: NSViewController {
    @IBOutlet weak var jpegRadio: NSButton!
    @IBOutlet weak var jsonRadio: NSButton!
    
    @IBOutlet weak var totalCoins: NSTextField!
    @IBAction func OnCancelAction(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func JpegRadioAction(_ sender: Any) {
        jsonRadio.state = 0
    }
    
    @IBAction func JsonRadioAction(_ sender: Any) {
        jpegRadio.state = 0
    }
    
    @IBOutlet weak var txtNote: NSTextField!
    @IBOutlet weak var txtSum: NSTextField!
    @IBAction func OnExportAction(_ sender: Any) {
        var isJson: Bool = false
        let desiredSum = Int(txtSum.stringValue)
        
        if (jsonRadio.state != 0)
        {
            isJson = true
        }
        
        let isExported = Safe.Instance()?.SaveOutStack(desiredSum: desiredSum!, isJson: isJson, note: txtNote.stringValue)
        
        if isExported! {
            if isJson {
                UserInteraction.alert(with: "JSON stack of coins saved in Export dir", style: NSAlertStyle.informational)
            }
            else {
                UserInteraction.alert(with: "Pictures with coins saved in Export dir", style: NSAlertStyle.informational)
            }
        }
        else {
            UserInteraction.alert(with: "Nothing to export!", style: NSAlertStyle.informational)
        }
    }
    
    override func viewDidLoad() {
        totalCoins.stringValue = String(describing: Safe.Instance()!.Contents.SumInStack)
    }
}
