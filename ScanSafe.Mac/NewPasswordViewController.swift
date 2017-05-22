//
//  NewPasswordViewController.swift
//  ScanSafe.Mac
//
//  Created by Donald on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class NewPasswordViewController: NSViewController{
    @IBOutlet weak var lblExplain: NSScrollView!
    
    override func viewDidLoad() {
        lblExplain.layer?.borderWidth = 0.0
        lblExplain.layer?.masksToBounds = true
    }
}
