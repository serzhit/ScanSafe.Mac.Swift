//
//  SafeContentViewController.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class SafeContentViewController: NSViewController, SafeDelegate{
    
    @IBOutlet weak var safeTableView: NSTableView!
    
    @IBOutlet weak var totalCoins: NSTextField!
    var safeResults: [SafeDisplay] = []
    
    override func viewDidLoad() {
        safeTableView.delegate = self
        safeTableView.dataSource = self
        Safe.Instance()?.safeDelegate = self
        totalCoins.stringValue = String(describing: Safe.Instance()!.Contents.SumInStack)
        SafeContentChanged()
    }
    
    func SafeContentChanged() {
        let safe = Safe.Instance()
        safeResults = []
        
        InsertSafeItem(value: "Ones", good: safe!.Ones.GoodQuantity, fractioned: safe!.Ones.FractionedQuality, total: safe!.Ones.TotalQuantity)
        InsertSafeItem(value: "Fives", good: safe!.Fives.GoodQuantity, fractioned: safe!.Fives.FractionedQuality, total: safe!.Fives.TotalQuantity)
        InsertSafeItem(value: "Quarters", good: safe!.Quarters.GoodQuantity, fractioned: safe!.Quarters.FractionedQuality, total: safe!.Quarters.TotalQuantity)
        InsertSafeItem(value: "Hundreds", good: safe!.Hundreds.GoodQuantity, fractioned: safe!.Hundreds.FractionedQuality, total: safe!.Hundreds.TotalQuantity)
        InsertSafeItem(value: "250s", good: safe!.KiloQuarters.GoodQuantity, fractioned: safe!.KiloQuarters.FractionedQuality, total: safe!.KiloQuarters.TotalQuantity)
        InsertSafeItem(value: "Sum:", good: safe!.KiloQuarters.GoodQuantity * 250 + safe!.Hundreds.GoodQuantity * 100
                                    + safe!.Quarters.GoodQuantity * 25 + safe!.Fives.GoodQuantity * 5 + safe!.Ones.GoodQuantity ,
                       fractioned: safe!.KiloQuarters.FractionedQuality * 250 + safe!.Hundreds.FractionedQuality * 100
                                    + safe!.Quarters.FractionedQuality * 25 + safe!.Fives.FractionedQuality * 5 + safe!.Ones.FractionedQuality,
                       total: safe!.KiloQuarters.TotalQuantity * 250 + safe!.Hundreds.TotalQuantity * 100
                                    + safe!.Quarters.TotalQuantity * 25 + safe!.Fives.TotalQuantity * 5 + safe!.Ones.TotalQuantity)
        
        DispatchQueue.main.async {
            self.safeTableView.reloadData();
        }
    }
    
    func InsertSafeItem(value: String, good: Int, fractioned: Int, total: Int)
    {
        safeResults.append(SafeDisplay(Value: value, Good: good, Fractioned: fractioned, Total: total))
        
    }
}

extension SafeContentViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return safeResults.count
    }
}

extension SafeContentViewController: NSTableViewDelegate{
    
    fileprivate enum CellIdentifiers {
        static let ValueCell = "ValueCellID"
        static let GoodCell = "GoodCellID"
        static let FractionedCell = "FractionedCellID"
        static let TotalCell = "TotalCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var text: String = ""
        
        if tableColumn == tableView.tableColumns[0]{
            text = "\(safeResults[row].Value)"
            cellIdentifier = CellIdentifiers.ValueCell
        } else if tableColumn == tableView.tableColumns[1]{
            text = "\(safeResults[row].Good)"
            cellIdentifier = CellIdentifiers.GoodCell
        } else if tableColumn == tableView.tableColumns[2]{
            text = "\(safeResults[row].Fractioned)"
            cellIdentifier = CellIdentifiers.FractionedCell
        } else if tableColumn == tableView.tableColumns[3]{
            text = "\(safeResults[row].Total)"
            cellIdentifier = CellIdentifiers.TotalCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell;
        }
        return nil
    }
}
