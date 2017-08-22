//
//  ViewController.swift
//  CloudCoin ScanSafe
//
//  Created by Сергей Житинский on 02.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa
import CryptoSwift

class MainViewController: NSViewController, RAIDAEchoDelegate, ImportDelegate, DetectDelegate {
    static var isPasswordShown : Bool = false
    @IBOutlet weak var lblExplain: NSTextField!
    @IBOutlet weak var lblStatus: NSTextField!
    @IBOutlet weak var IntroLabel: NSTextField!
    @IBOutlet weak var Australia: NSBox!
    @IBOutlet weak var RAIDAReadyLabel: NSTextField!
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
    @IBOutlet weak var imgView: NSImageView!
    
    var coinFile: CloudCoinFile = CloudCoinFile()
    var scanOpType : String = "Detect"
    
    
    enum ViewType {
        case Imported, Safe, Exported
    }
    var subViewType: ViewType = .Imported
    
    @IBAction func Scan(_ sender: NSButton) {
        
        subViewType = .Imported
        
        guard let files = FileSystem.ChooseInputFile() else {
            return
        }
        
        coinFile = CloudCoinFile(urls: files);
        
        if (coinFile.IsValidFile)
        {
            let alertAnswer = UserInteraction.YesNoAlert(with: "Do you want to take ownership of imported coins. Choose 'No' to check coins and leave psasswords unchanged", style: NSAlertStyle.informational)
            if alertAnswer == NSAlertFirstButtonReturn {
                scanOpType = "Import"
                let detectVC = self.storyboard?.instantiateController(withIdentifier: "DetectViewController") as? DetectViewController
                detectVC?.detectDelegate = self
                self.presentViewControllerAsModalWindow(detectVC!);
                
                RAIDA.Instance?.Detect(stack: coinFile.Coins, ArePasswordsToBeChanged: true)
            } else {
                scanOpType = "Detect"
                let detectVC = self.storyboard?.instantiateController(withIdentifier: "DetectViewController") as? DetectViewController
                detectVC?.detectDelegate = self
                self.presentViewControllerAsModalWindow(detectVC!);
                
                RAIDA.Instance?.Detect(stack: coinFile.Coins, ArePasswordsToBeChanged: false)
            }
        }
    }
    
    @IBAction func SafeAction(_ sender: NSButton) {
        subViewType = .Safe
            ShowPasswordViewController(showPassword : MainViewController.isPasswordShown)
        }
    
    @IBAction func Pay(_ sender: NSButton) {
        subViewType = .Exported
        
            ShowPasswordViewController(showPassword : MainViewController.isPasswordShown)
            
  
    }
    
    var Countries: Dictionary<Node,NSBox> = Dictionary<Node,NSBox>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStatus.isHidden = true
        lblExplain.isHidden = true
        initCountries()

        RAIDA.Instance?.EchoDelegate = self
        FileSystem.InitializePaths();
        RAIDA.Instance?.getEcho();
        self.title = "Scan and Safe"
        
        showDisclaimer()
        MainViewController.isPasswordShown = false
        
        
    }
    
    func showDisclaimer() {
        let disclaimershown = UserDefaults.standard.string(forKey: "disclaimershown")
        
        if(disclaimershown != "yes") {
        let alert = NSAlert()
        alert.messageText = "Disclaimer"
        alert.informativeText = "This software is provided as is with all faults, defects and errors, and without warranty of any kind. Free from the CloudCoin Consortium"
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "Agree")
        alert.addButton(withTitle: "Disagree")
        let answer = alert.runModal() == NSAlertFirstButtonReturn
        if(answer == true) {
            UserDefaults.standard.set("yes", forKey: "disclaimershown")
        }
        else {
            NSApplication.shared().terminate(self);
            
        }
        }
        
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
        
    }
    
    func EchoReceivedFrom(node: Node) {
        DispatchQueue.main.async {
            self.Countries[node]?.fillColor = NSColor.green
            print("ViewController: Node \(node.Number) is ready!")
        }
    }
    
    func AllEchoesReceived() {
        DispatchQueue.main.async {
            print("All echoes received!")
            self.lblStatus.isHidden = false
            self.lblExplain.isHidden = false
            //UserInteraction.alert(with: "RAIDA is ready to detect cloudcoins!", style: NSAlertStyle.informational)
        }
    }
    
    func FinishImported(password: String) {
        UserInteraction.password = password
        
        if (subViewType == .Safe || subViewType == .Imported)
        {
            ShowContentViewController()
        }
        else {
            ShowExportViewController()
        }
        
        if subViewType == .Imported
        {
            if(scanOpType == "Import") {
                Safe.Instance()?.Add(stack: coinFile.Coins)
            }
        }
    }
    
    func FinishImported() {
        
        
        if subViewType == .Imported
        {
            if(scanOpType == "Import") {
                Safe.Instance()?.Add(stack: coinFile.Coins)
            }
        }
    }
    
    
    func ShowContentViewController() {
        let safeContentVC = self.storyboard?.instantiateController(withIdentifier: "SafeContentViewController") as? SafeContentViewController
        self.presentViewControllerAsModalWindow(safeContentVC!);
    }
    
    func ShowExportViewController() {
        let exportVC = self.storyboard?.instantiateController(withIdentifier: "ExportViewController") as? ExportViewController
        self.presentViewControllerAsModalWindow(exportVC!);
    }
    
    func FinishDetected()
    {
        ShowPasswordViewController(showPassword : MainViewController.isPasswordShown)
    }
    
    func ShowPasswordViewController() {
        let safeFilePath = Utils.GetFileUrl(path: Safe.SafeFileName)!
        if Utils.FileExists(url: safeFilePath)
        {
            let enterPassVC = self.storyboard?.instantiateController(withIdentifier: "EnterPasswordViewController") as? EnterPasswordViewController
            enterPassVC?.delegate = self
            self.presentViewControllerAsModalWindow(enterPassVC!);
        }
        else
        {
            let newPassVC = self.storyboard?.instantiateController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController
            newPassVC?.delegate = self
            self.presentViewControllerAsModalWindow(newPassVC!);
        }
        MainViewController.isPasswordShown = true
    }
    
    func ShowPasswordViewController(showPassword:Bool) {
        let safeFilePath = Utils.GetFileUrl(path: Safe.SafeFileName)!
        if(MainViewController.isPasswordShown == false) {
        if Utils.FileExists(url: safeFilePath)
        {
            let enterPassVC = self.storyboard?.instantiateController(withIdentifier: "EnterPasswordViewController") as? EnterPasswordViewController
            enterPassVC?.delegate = self
            self.presentViewControllerAsModalWindow(enterPassVC!);
        }
        else
        {
            let newPassVC = self.storyboard?.instantiateController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController
            newPassVC?.delegate = self
            self.presentViewControllerAsModalWindow(newPassVC!);
        }
        }
        else {
            if (subViewType == .Safe || subViewType == .Imported)
            {
                ShowContentViewController()
            }
            else
            {
                ShowExportViewController()
            }
            
            if subViewType == .Imported
            {
                if(scanOpType == "Import") {
                    Safe.Instance()?.Add(stack: coinFile.Coins)
                }
            }
            
        }
        
        MainViewController.isPasswordShown = true
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
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        
        return hexBytes.joined()
    }
    
    func aesEncrypt(key: Array<UInt8>, iv: Array<UInt8>) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: Array<UInt8>, iv: Array<UInt8>) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

extension NSImage {
    func drawWithText(text: String, point: NSPoint) {
        let textFontAttributes = [NSFontAttributeName: NSFont.labelFont(ofSize: 10), NSForegroundColorAttributeName: NSColor.white]
        let string = NSAttributedString(string: text, attributes: textFontAttributes)
        self.lockFocus()
        NSGraphicsContext.saveGraphicsState()
        string.draw(at: point)
        NSGraphicsContext.restoreGraphicsState()
        self.unlockFocus()
    }
    
}
