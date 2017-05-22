//
//  DetectViewController.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 12.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class DetectViewController: NSViewController, RAIDADetectDelegate {
    @IBOutlet weak var progressBar: NSProgressIndicator!

    @IBOutlet weak var DetectedTableView: NSTableView!
    @IBOutlet weak var lblProgress: NSTextField!
    var detectResults : [DetectDisplay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RAIDA.Instance?.DetectDelegate = self
        
        DetectedTableView.delegate = self;
        DetectedTableView.dataSource = self;
        
        detectResults = [DetectDisplay]()
        
    }
    
    func DetectCompletedOn(coin: CloudCoin) {
        print("DetectCompletedOn")
        let detectInfo = DetectDisplay(Serial: coin.sn, Value: Utils.Denomination2Int(forValue: coin.denomination), Check: coin.isPassed,
                                       Comment: "\(coin.percentOfRAIDAPass)" + " % of keys are good. Checked in ");
        detectResults.append(detectInfo)
        DispatchQueue.main.async {
            self.DetectedTableView.reloadData();
        }
    }
    
    func CoinDetectionCompleted(){
        print("CoinDetectionCompleted")
        DispatchQueue.main.async {
            self.progressBar.doubleValue = 100.0
            self.lblProgress.stringValue = "100%"
        }
    }
    
    func ProgressUpdated(progress: Double){
        DispatchQueue.main.async {
            self.progressBar.increment(by: progress)
            let progress = self.progressBar.doubleValue
            self.lblProgress.stringValue = "\(Int(progress))" + "%"
        }
    }
}

extension DetectViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return detectResults.count
    }
}

extension DetectViewController: NSTableViewDelegate{
    
    fileprivate enum CellIdentifiers {
        static let SerialCell = "SerialCellID"
        static let ValueCell = "ValueCellID"
        static let AuthCell = "AuthCellID"
        static let CommentCell = "CommentCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var text: String = ""
        
        if tableColumn == tableView.tableColumns[0]{
            text = "\(detectResults[row].Serial)"
            cellIdentifier = CellIdentifiers.SerialCell
        } else if tableColumn == tableView.tableColumns[1]{
            text = "\(detectResults[row].Value)"
            cellIdentifier = CellIdentifiers.ValueCell
        } else if tableColumn == tableView.tableColumns[2]{
            text = "\(detectResults[row].Check)"
            cellIdentifier = CellIdentifiers.AuthCell
        } else if tableColumn == tableView.tableColumns[3]{
            text = detectResults[row].Comment
            cellIdentifier = CellIdentifiers.CommentCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell;
        }
        return nil
    }
}
