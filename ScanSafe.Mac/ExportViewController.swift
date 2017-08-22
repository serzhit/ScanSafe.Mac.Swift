//
//  ExportViewController.swift
//  ScanSafe.Mac
//
//  Created by Gao on 6/3/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class ExportViewController: NSViewController {
    @IBOutlet weak var jpegRadio: NSButton!
    @IBOutlet weak var jsonRadio: NSButton!
  
    @IBOutlet weak var oneStep: NSStepper!
    @IBOutlet weak var fiveStepper: NSStepper!
    @IBOutlet weak var twentyFiveStepper: NSStepper!
    @IBOutlet weak var hundredStepper: NSStepper!
    @IBOutlet weak var twoFiveZeroStepper: NSStepper!
    
    
    @IBAction func oneValueChanged(_ sender: Any) {
        txtOnes.stringValue = oneStep.stringValue
    }
    
    
    @IBAction func fiveCountChanged(_ sender: Any) {
        txtFives.stringValue = fiveStepper.stringValue
        
    }
    
    @IBAction func twoFiveValueChanged(_ sender: Any) {
        txtTwentyFives.stringValue = twentyFiveStepper.stringValue
    }
    
    @IBAction func hundredValueChanged(_ sender: Any) {
        txtHundreds.stringValue = hundredStepper.stringValue
    }
    
    @IBAction func twoFiveZeroValueChanged(_ sender: Any) {
        txtTwoFiftys.stringValue = twoFiveZeroStepper.stringValue
    }
    @IBOutlet weak var txtOnes: NSTextField!
    @IBOutlet weak var txtFives: NSTextField!
    @IBOutlet weak var txtTwentyFives: NSTextField!
    @IBOutlet weak var txtHundreds: NSTextField!
    @IBOutlet weak var txtTwoFiftys: NSTextField!
    
    
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
        
        let safe = Safe.Instance()
        let stack = safe?.SaveOutStack(desiredSum: desiredSum!, isJson: isJson, note: txtNote.stringValue)
        
        if stack != nil {
            if isJson {
                UserInteraction.alert(with: "JSON stack of coins saved in Export dir", style: NSAlertStyle.informational)
            }
            else {
                UserInteraction.alert(with: "Pictures with coins saved in Export dir", style: NSAlertStyle.informational)
            }
            
            safe?.Contents.Remove(stack: stack!)
            safe?.Save()
            
        }
        else {
            UserInteraction.alert(with: "Nothing to export!", style: NSAlertStyle.informational)
        }
        
        //dismiss(self)
    }
    
    override func viewDidLoad() {
        totalCoins.stringValue = String(describing: Safe.Instance()!.Contents.SumInStack)
        txtOnes.stringValue = "0"
        txtTwoFiftys.stringValue = "0"
        txtHundreds.stringValue = "0"
        txtFives.stringValue = "5"
        txtTwentyFives.stringValue = "0"
    }
}
