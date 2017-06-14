//
//  FixProcess.swift
//  ScanSafe.Mac
//
//  Created by Gao on 6/9/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class FixProcessViewController: NSViewController {
    
    @IBOutlet weak var fixTableView: NSTableView!
    
    override func viewDidLoad() {
        fixTableView.dataSource = self
        fixTableView.delegate = self
        
        var index = 0
        for coin in (Safe.Instance()?.FrackedCoinsList)! {
            RAIDA.Instance?.fixCoin(brokeCoin: coin, coinindex: index)
            index += 1
        }
    }
}

extension FixProcessViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2
    }
}

extension FixProcessViewController: NSTableViewDelegate{
    
    static let StatusCell = "StatusCellID"
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: "StatusCellID", owner: nil) as? RaidaStatusView {
            //cell.textField?.stringValue = text
            cell.lblStatus.stringValue = "lblstatus"
            return cell;
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }
}