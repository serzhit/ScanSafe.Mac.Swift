//
//  DetectViewController.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 12.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class DetectViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBOutlet weak var DetectedTableView: NSTableView!
    
}

extension DetectViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 0
    }
    
}
