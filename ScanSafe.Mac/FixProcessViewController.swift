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
        self.title = "Fix Coins"
        let detectGroup = DispatchGroup()
        
        var index = 0
        print ("Fracked count - ",Safe.Instance()?.FrackedCoinsList.count)
        
        for coin in (Safe.Instance()?.FrackedCoinsList)! {
            detectGroup.enter()
            RAIDA.Instance?.fixCoin(brokeCoin: coin, coinindex: index) {
                result in
                detectGroup.leave()
            }
            index += 1
        }
        
        detectGroup.notify(queue: DispatchQueue.main) {
            Safe.Instance()?.safeDelegate?.SafeContentChanged()
            Safe.Instance()?.Save()
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
