//
//  SafeContentViewController.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class SafeContentViewController: NSViewController{
    
    @IBOutlet weak var safeTableView: NSTableView!
    override func viewDidLoad() {
        
    }
}

//extension SafeContentViewController: NSTableViewDataSource {
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return detectResults.count
//    }
//}
//
//extension SafeContentViewController: NSTableViewDelegate{
//    
//    fileprivate enum CellIdentifiers {
//        static let SerialCell = "SerialCellID"
//        static let ValueCell = "ValueCellID"
//        static let AuthCell = "AuthCellID"
//        static let CommentCell = "CommentCellID"
//    }
//    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        var cellIdentifier: String = ""
//        var text: String = ""
//        
//        if tableColumn == tableView.tableColumns[0]{
//            text = "\(detectResults[row].Serial)"
//            cellIdentifier = CellIdentifiers.SerialCell
//        } else if tableColumn == tableView.tableColumns[1]{
//            text = "\(detectResults[row].Value)"
//            cellIdentifier = CellIdentifiers.ValueCell
//        } else if tableColumn == tableView.tableColumns[2]{
//            text = "\(detectResults[row].Check)"
//            cellIdentifier = CellIdentifiers.AuthCell
//        } else if tableColumn == tableView.tableColumns[3]{
//            text = detectResults[row].Comment
//            cellIdentifier = CellIdentifiers.CommentCell
//        }
//        
//        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
//            cell.textField?.stringValue = text
//            return cell;
//        }
//        return nil
//    }
//}
