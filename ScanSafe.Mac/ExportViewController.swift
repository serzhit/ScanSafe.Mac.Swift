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
    
    @IBOutlet weak var lblTotalExport: NSTextField!
    
    @IBAction func oneValueChanged(_ sender: Any) {
        txtOnes.stringValue = oneStep.stringValue
        calcExportTotal()
    }
    
    
    @IBAction func fiveCountChanged(_ sender: Any) {
        txtFives.stringValue = fiveStepper.stringValue
        calcExportTotal()
        
    }
    
    @IBAction func twoFiveValueChanged(_ sender: Any) {
        txtTwentyFives.stringValue = twentyFiveStepper.stringValue
        calcExportTotal()
    }
    
    @IBAction func hundredValueChanged(_ sender: Any) {
        txtHundreds.stringValue = hundredStepper.stringValue
        calcExportTotal()
    }
    
    @IBAction func twoFiveZeroValueChanged(_ sender: Any) {
        txtTwoFiftys.stringValue = twoFiveZeroStepper.stringValue
        calcExportTotal()
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
        let desiredSum = Int(lblTotalExport.stringValue)
        
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
        txtFives.stringValue = "0"
        txtTwentyFives.stringValue = "0"
        let safe = Safe.Instance()
        oneStep.maxValue = Double((safe?.Ones.TotalQuantity)!)
        fiveStepper.maxValue = Double((safe?.Fives.TotalQuantity)!)
        hundredStepper.maxValue = Double((safe?.Hundreds.TotalQuantity)!)
        twoFiveZeroStepper.maxValue = Double((safe?.KiloQuarters.TotalQuantity)!)
        twentyFiveStepper.maxValue = Double((safe?.Quarters.TotalQuantity)!)
        //oneStep.maxValue = 100
        //fiveStepper.maxValue = 100
        //hundredStepper.maxValue = 100
        //twoFiveZeroStepper.maxValue = 100
        //twentyFiveStepper.maxValue = 100
        
        txtSum.isHidden = true
        txtOnes.isEnabled = false
        txtTwoFiftys.isEnabled = false
        txtHundreds.isEnabled = false
        txtFives.isEnabled = false
        txtTwentyFives.isEnabled = false
    }
    
    func calcExportTotal() {
        let oneTotal = Int(txtOnes.stringValue)! * 1
        let fiveTotal = Int(txtFives.stringValue)! * 5
        let twoFiveTotal = Int(txtTwentyFives.stringValue)! * 25
        let hundredTotal = Int(txtHundreds.stringValue)! * 100
        let twoFiveZeroTotal = Int(txtTwoFiftys.stringValue)! * 250
        
        var totalExport = oneTotal + fiveTotal + twoFiveTotal + hundredTotal + twoFiveZeroTotal
        lblTotalExport.stringValue = String(totalExport)
        
        
    }
}
