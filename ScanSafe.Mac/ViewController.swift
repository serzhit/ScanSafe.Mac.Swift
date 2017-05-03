//
//  ViewController.swift
//  CloudCoin ScanSafe
//
//  Created by Сергей Житинский on 02.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBAction func Scan(_ sender: Any) {
    }
    @IBAction func Safe(_ sender: Any) {
    }
    @IBAction func Pay(_ sender: Any) {
    }
    @IBOutlet weak var IntroLabel: NSTextField!
    @IBOutlet weak var Australia: NSBox!
    @IBOutlet weak var Macedonia: NSBox!
    @IBOutlet weak var Phillipines: NSBox!
    @IBOutlet weak var Serbia: NSBox!
    @IBOutlet weak var Russia3: NSBox!
    @IBOutlet weak var Bangalore: NSBox!
    @IBOutlet weak var Hyperbad: NSBox!
    @IBOutlet weak var Punjab: NSBox!
    @IBOutlet weak var Venezuela: NSBox!
    @IBOutlet weak var Columbia: NSBox!
    @IBOutlet weak var USA1: NSBox!
    @IBOutlet weak var USA2: NSBox!
    @IBOutlet weak var Canada: NSBox!
    @IBOutlet weak var UK: NSBox!
    @IBOutlet weak var Germany: NSBox!
    @IBOutlet weak var Romania: NSBox!
    @IBOutlet weak var Russia1: NSBox!
    @IBOutlet weak var Russia2: NSBox!
    @IBOutlet weak var Texas: NSBox!
    @IBOutlet weak var Taiwan: NSBox!
    @IBOutlet weak var Singapore: NSBox!
    @IBOutlet weak var Ukraine: NSBox!
    @IBOutlet weak var Bulgaria: NSBox!
    @IBOutlet weak var Luxemburg: NSBox!
    @IBOutlet weak var Switzerland: NSBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        Australia.fillColor = NSColor.red
        Macedonia.fillColor = NSColor.red
        Phillipines.fillColor = NSColor.red
        Serbia.fillColor = NSColor.red
        Russia1.fillColor = NSColor.red
        Russia2.fillColor = NSColor.red
        Russia3.fillColor = NSColor.red
        Punjab.fillColor = NSColor.red
        Bangalore.fillColor = NSColor.red
        Hyperbad.fillColor = NSColor.red
        USA1.fillColor = NSColor.red
        USA2.fillColor = NSColor.red
        Taiwan.fillColor = NSColor.red
        Singapore.fillColor = NSColor.red
        Ukraine.fillColor = NSColor.red
        Romania.fillColor = NSColor.red
        Bulgaria.fillColor = NSColor.red
        Switzerland.fillColor = NSColor.red
        Germany.fillColor = NSColor.red
        Luxemburg.fillColor = NSColor.red
        UK.fillColor = NSColor.red
        Canada.fillColor = NSColor.red
        Venezuela.fillColor = NSColor.red
        Columbia.fillColor = NSColor.red
        Texas.fillColor = NSColor.red
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

