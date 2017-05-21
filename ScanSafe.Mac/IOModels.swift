//
//  IOModels.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 08.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa


class FileSystem {
    static let FM  = FileManager.default
    
    //static let settingsPath: String?  = Bundle.main.path(forResource: "Setttings", ofType: "plist")
    //static var settingsDict: NSDictionary? = NSDictionary(contentsOfFile: settingsPath!)

    static func InitializePaths() {
        /*let homedir: String? = settingsDict?.object(forKey: "AppFolder") as? String
        let importdir: String? = settingsDict?.object(forKey: "ImportFolder") as? String
        let exportdir: String? = settingsDict?.object(forKey: "]ExportFolder") as? String
        let backupdir: String? = settingsDict?.object(forKey: "]BackupFolder") as? String
        let logdir: String? = settingsDict?.object(forKey: "LogFolder") as? String
        let tmpDir: String? = settingsDict?.object(forKey: "TmpFolder") as? String
    
        for path in [homedir, importdir, exportdir, backupdir, logdir, tmpDir] {
            if !FM.fileExists(atPath: path!) {
                do {
                    try FM.createDirectory(atPath: path!, withIntermediateDirectories: true)
                } catch let error as NSError {
                    print(error.debugDescription)
                    UserInteraction.alert(with: "Error encountered creating system foldres.", style: NSAlertStyle.critical)
                }
            }
        }*/
        
        Logger.Initialize();
    }
    
    static func ChooseInputFile() -> [URL]? {
        if let urls = NSOpenPanel().selectedUrls {
            for url in urls {
                print("file selected = \(url.path)")
            }
            return urls
        } else {
            print("file selection was canceled")
            return nil
        }
    }
    
    static func CopyOriginalFileToImported(_ fileURL: URL) {
        
    }
}

class CloudCoinFilesCollection {
    var files: [CloudCoinFile?]
    var CoinsFoundInFiles: CoinStack
    init? (urls: [URL]) {
        files = [CloudCoinFile?]()
        CoinsFoundInFiles = CoinStack()
        
        for url in urls {
            let ccFile = CloudCoinFile(url: url)
            files.append(ccFile)
            if ccFile != nil {
                CoinsFoundInFiles.Add(stack: ccFile!.Coins)
            }
            
        }
    }
}

class CloudCoinFile {
    var IsValidFile : Bool = false
    var Filename: String
    var Coins: CoinStack = CoinStack()
    
    init() {
        Filename = ""
    }
    
    init?(url: URL) {
        Filename = url.absoluteString
        guard ParseCloudCoinFile(atURL: url) else {
            return nil
        }
    }
    
    init(urls: [URL]?)
    {
        Filename = ""
        for url in urls!
        {
            ParseCloudCoinFile(atURL: url);
        }
    }
    
    private func ParseCloudCoinFile(atURL: URL) -> Bool {
        
        guard FileSystem.FM.fileExists(atPath: atURL.path) else {
            print("File \(atURL.path) doesn't exists!")
            return false
        }
        Filename = atURL.path
        
        var fhandle: FileHandle?
        do {
            fhandle = try  FileHandle(forReadingFrom: atURL)
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
        var signature: Data? = Data(count: 20)
        signature = fhandle?.readData(ofLength: 20)
        
        var regEx: NSRegularExpression?
        //let regexpattern: String = "{[.\\n\\t\\s\\x09\\x0A\\x0D]*\"cloudcoin\""
        let regexpattern: String = "json" //testing case
        /*do {
            regEx = try NSRegularExpression(pattern: regexpattern, options: [])
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }*/
        regEx = try! NSRegularExpression(pattern: regexpattern, options: [])
        IsValidFile = false
        
        if signature!.prefix(3).elementsEqual( [255,216,255] ) { //JPEG
            guard let coin = ReadJpeg(withFilePath: Filename) else {
                print("No coin in jpeg file at \(atURL.absoluteString)")
                return false
            }
            
            IsValidFile = coin.Validate()
            guard IsValidFile else {
                print("Coin in jpeg file at \(atURL.absoluteString) has bad format")
                return false
            }
            Coins.Add(stack: CoinStack(coin))
//            Logger.Write("Coin with SN " + coin.sn + " added for detecting", Logger.Level.Normal);

        }
        else if (regEx?.numberOfMatches(in: String(data: signature!, encoding: .utf8)!, options: [], range: NSRange(location: 0,length: 19)))! > 0 {//JSON

            guard let stackFromJson = ReadJson(withFileHandle: fhandle!) else {
                print("Cannot read json file \(atURL.absoluteString)")
                return false
            }
            for coin in stackFromJson {
                guard coin.Validate() else {
                    IsValidFile = false
                    break
                }
                IsValidFile = true;
//                Logger.Write("Coin with SN " + coin.sn + " added for detecting", Logger.Level.Normal);
            }
    
            if IsValidFile {
                Coins.Add(stack: stackFromJson)
            } else {
                print("Bad coin in stack file!")
                return false
            }
        }
        if IsValidFile {
            FileSystem.CopyOriginalFileToImported(atURL)
            return true
        } else {
            print("Cant be in this point actually")
            return false
        }
    }
    
    private func ReadJpeg(withFilePath: String) -> CloudCoin? {
        /*if let data = NSData(contentsOfFile: Filename){
            var buffer = [UInt8](repeating: 0, count: data.length)
            data.getBytes(&buffer, length: data.length)
            
            print("content file = \(data as NSData)")
            
        }*/
        
        let fileRange = NSRange(location: 0, length: 455)
        let fileByteContent = NSData(contentsOfFile: withFilePath)?.subdata(with: fileRange)
        var an: [String] = Array<String>(repeating: "", count: RAIDA.NODEQUANTITY)
        var aoid: [String] = [""]
        var nn: Int?
        var sn: Int?
        var ed: String?
        
        let jpegHexContent: String = Utils.ToHexString(fileByteContent!)
        
        print("content file = \(fileByteContent! as NSData)")
        
        for i in 0..<RAIDA.NODEQUANTITY {
            let start = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 40+i*32)
            let end = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 72+i*32)
            let range = start..<end
            an[i] = jpegHexContent.substring(with: range)
        }
        
        var start = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 840)
        var end = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 895)
        var range = start..<end
        aoid[0] = jpegHexContent.substring(with: range)
        
        start = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 898)
        end = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 902)
        range = start..<end
        ed = jpegHexContent.substring(with: range)
        
        start = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 902)
        end = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 904)
        range = start..<end
        nn = Int(jpegHexContent.substring(with: range), radix: 16)
        
        start = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 904)
        end = jpegHexContent.index(jpegHexContent.startIndex, offsetBy: 910)
        range = start..<end
        sn = Int(jpegHexContent.substring(with: range), radix: 16)
        
        guard let coin = CloudCoin(nn: nn!, sn: sn!, ans: an, expired: ed!, aoid: aoid) else {
            return nil
        }
        guard coin.Validate() else {
            return nil
        }
        return coin
    }
    
    private func ReadJson(withFileHandle: FileHandle) -> CoinStack? {
        var stack: CoinStack?
        let jsonData: Data?
        stack = nil
        
        do {
            jsonData = withFileHandle.readDataToEndOfFile()
            stack = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? CoinStack
            withFileHandle.closeFile()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return stack
    }
}
