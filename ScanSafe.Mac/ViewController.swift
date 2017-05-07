//
//  ViewController.swift
//  CloudCoin ScanSafe
//
//  Created by Сергей Житинский on 02.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, RAIDAEchoDelegate {
    @IBAction func Scan(_ sender: Any) {
    }
    @IBAction func Safe(_ sender: Any) {
    }
    @IBAction func Pay(_ sender: Any) {
    }
    @IBOutlet weak var IntroLabel: NSTextField!
    @IBOutlet weak var Australia: NSBox!
    @IBOutlet weak var Bangalore: NSBox!
    @IBOutlet weak var Huperbad: NSBox!
    @IBOutlet weak var Punjab: NSBox!
    @IBOutlet weak var Venezuela: NSBox!
    @IBOutlet weak var Columbia: NSBox!
    @IBOutlet weak var USA1: NSBox!
    @IBOutlet weak var USA2: NSBox!
    @IBOutlet weak var Canada: NSBox!
    @IBOutlet weak var Serbia: NSBox!
    @IBOutlet weak var UK: NSBox!
    @IBOutlet weak var Germany: NSBox!
    @IBOutlet weak var Romania: NSBox!
    @IBOutlet weak var Russia1: NSBox!
    @IBOutlet weak var Russia2: NSBox!
    @IBOutlet weak var Russia3: NSBox!
    @IBOutlet weak var Texas: NSBox!
    @IBOutlet weak var Taiwan: NSBox!
    @IBOutlet weak var Phillipines: NSBox!
    @IBOutlet weak var Singapore: NSBox!
    @IBOutlet weak var Ukraine: NSBox!
    @IBOutlet weak var Bulgaria: NSBox!
    @IBOutlet weak var Luxemburg: NSBox!
    @IBOutlet weak var Macedonia: NSBox!
    @IBOutlet weak var Switzerland: NSBox!
    
    var Countries: Dictionary<Node,NSBox> = Dictionary<Node,NSBox>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCountries()
        // Do any additional setup after loading the view.
    }
    
    func initCountries() {
        for node: Node? in (RAIDA.Instance?.NodesArray)! {
            switch node!.Number {
            case 0:
                Countries[node!] = Australia
                Australia.fillColor = NSColor.red
            case 1:
                Countries[node!] = Macedonia
                Macedonia.fillColor = NSColor.red
            case 2:
                Countries[node!] = Phillipines
                Phillipines.fillColor = NSColor.red
            case 3:
                Countries[node!] = Serbia
                Serbia.fillColor = NSColor.red
            case 4:
                Countries[node!] = Bulgaria
                Bulgaria.fillColor = NSColor.red
            case 5:
                Countries[node!] = Russia3
                Russia3.fillColor = NSColor.red
            case 6:
                Countries[node!] = Switzerland
                Switzerland.fillColor = NSColor.red
            case 7:
                Countries[node!] = UK
                UK.fillColor = NSColor.red
            case 8:
                Countries[node!] = Punjab
                Punjab.fillColor = NSColor.red
            case 9:
                Countries[node!] = Bangalore
                Bangalore.fillColor = NSColor.red
            case 10:
                Countries[node!] = Texas
                Texas.fillColor = NSColor.red
            case 11:
                Countries[node!] = USA1
                USA1.fillColor = NSColor.red
            case 12:
                Countries[node!] = Romania
                Romania.fillColor = NSColor.red
            case 13:
                Countries[node!] = Taiwan
                Taiwan.fillColor = NSColor.red
            case 14:
                Countries[node!] = Russia1
                Russia1.fillColor = NSColor.red
            case 15:
                Countries[node!] = Russia2
                Russia2.fillColor = NSColor.red
            case 16:
                Countries[node!] = Columbia
                Columbia.fillColor = NSColor.red
            case 17:
                Countries[node!] = Singapore
                Singapore.fillColor = NSColor.red
            case 18:
                Countries[node!] = Germany
                Germany.fillColor = NSColor.red
            case 19:
                Countries[node!] = Canada
                Canada.fillColor = NSColor.red
            case 20:
                Countries[node!] = Venezuela
                Venezuela.fillColor = NSColor.red
            case 21:
                Countries[node!] = Huperbad
                Huperbad.fillColor = NSColor.red
            case 22:
                Countries[node!] = USA2
                USA2.fillColor = NSColor.red
            case 23:
                Countries[node!] = Ukraine
                Ukraine.fillColor = NSColor.red
            case 24:
                Countries[node!] = Luxemburg
                Luxemburg.fillColor = NSColor.red
            default:
                Countries[node!] = USA1
                USA1.fillColor = NSColor.red
            }
        }
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func EchoReceivedFrom(node: Node) {
        Countries[node]?.fillColor = NSColor.green
    }
    
    func AllEchoesReceived() {
        
    }
}

