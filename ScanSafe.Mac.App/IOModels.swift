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
        let regexpattern: String = "[.\n\t\\s\\x09\\x0A\\x0D]*\"cloudcoin\""

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

        }
        else if (regEx?.numberOfMatches(in: String(data: signature!, encoding: .utf8)!, options: [], range: NSRange(location: 0,length: 19)))! > 0 {//JSON

            guard let stackFromJson = ReadJson(fileUrl: atURL) else {
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
        
        let status = Array(repeating: raidaNodeResponse.unknown, count: RAIDA.NODEQUANTITY)
        guard let coin = CloudCoin(nn: nn!, sn: sn!, ans: an, expired: ed!, aoid: aoid, status: status) else {
            return nil
        }
        guard coin.Validate() else {
            return nil
        }
        return coin
    }
    
    func WriteJpeg(cc: CloudCoin, tag: String, path: inout String) -> Bool {
        
        var cloudCoinStr = "01C34A46494600010101006000601D05"
        for index in 0...24 {
            cloudCoinStr += cc.ans[index]!
        }
        
        cloudCoinStr += "204f42455920474f4420262044454645415420545952414e545320"
        cloudCoinStr += "00"
        cloudCoinStr += "00"
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        
        cloudCoinStr += String(format:"%1X", month)
        cloudCoinStr += String(format:"%3X", year)
        
        cloudCoinStr += "01"
        
        let hexSN = String(format: "%6X", cc.sn)
        var fullHexSN = ""
        
        switch hexSN.characters.count {
        case 1:
            fullHexSN = "00000" + hexSN
            break
        case 2:
            fullHexSN = "0000" + hexSN
            break
        case 3:
            fullHexSN = "000" + hexSN
            break
        case 4:
            fullHexSN = "00" + hexSN
            break
        case 5:
            fullHexSN = "0" + hexSN
            break
        case 6:
            fullHexSN = hexSN
            break
        default:
            fullHexSN = hexSN
        }
        
        cloudCoinStr += fullHexSN
        /* BYTES THAT WILL GO FROM 04 TO 454 (Inclusive)*/
        let ccArray = hexStringToByteArray(hexString: cloudCoinStr)
        
        var jpgImage: NSImage? = nil
        
        switch(GetDenomination(sn: cc.sn)) {
        case 1:
            jpgImage = NSImage(named: "Cloudcoin_1")
            break;
        case 5:
            jpgImage = NSImage(named: "Cloudcoin_5")
            break;
        case 25:
            jpgImage = NSImage(named: "Cloudcoin_25")
            break;
        case 100:
            jpgImage = NSImage(named: "Cloudcoin_100")
            break;
        case 250:
            jpgImage = NSImage(named: "Cloudcoin_250")
            break;
        default:
            break;
        }
        //let image = UIImage(named:"Cloudcoin1", in: Bundle(for: self), compatibleWith: nil)
        jpgImage?.drawWithText(text: "\(cc.sn)" + " of 16,777,216 on Network: 1", point: NSPoint(x: 30, y: jpgImage!.size.height - 25))
        
        var rect = NSRect(x: 0, y: 0, width: jpgImage!.size.width, height: jpgImage!.size.height)
        let cgImage = jpgImage!.cgImage(forProposedRect: &rect, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        
        if let imageData = bitmapRep.representation(using: NSBitmapImageFileType.JPEG, properties: [:]) {
            let len = imageData.count
            
            var snbytes = [UInt8](repeating: 0, count: len)
            imageData.copyBytes(to: &snbytes, count: len)
            
            var hrbytes: [UInt8] = []
            for _ in 0...3 {
                let byte = snbytes.remove(at: 0)
                hrbytes.append(byte)
            }
            
            var tagComment = tag
            var outbytes: [UInt8] = []
            outbytes = hrbytes + ccArray! + snbytes
            
            if (tagComment == "random")
            {
                var random = arc4random_uniform(100000)
                random = random * 10 + arc4random_uniform(10)
                tagComment = "\(random)"
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyy"
            
            let folderPath = Safe.UserCloudcoinExportDir + tagComment + "_" + formatter.string(from: date) + "/"
            let folderurl = Utils.GetFileUrl(path: folderPath)
            try? FileManager.default.createDirectory(at: folderurl!, withIntermediateDirectories: false, attributes: nil)
            
            var fileName = "\(GetDenomination(sn: cc.sn))"
            fileName += ".CloudCoin." + "\(cc.nn)" + "." + "\(cc.sn)" + ".";
            let jpgFileName = folderPath + fileName + tag + ".jpg"
            
            let fileUrl = Utils.GetFileUrl(path: jpgFileName)
            
            let pointer = UnsafeBufferPointer(start: outbytes, count: outbytes.count)
            let data = Data(buffer: pointer)
            
            path = jpgFileName
            try! data.write(to: fileUrl!)
            
            return true
        }
        
        return false
    }
    
    func hexStringToByteArray(hexString: String) -> [UInt8]?
    {
        let length = hexString.characters.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = hexString.startIndex
        for _ in 0..<length/2 {
            let nextIndex = hexString.index(index, offsetBy: 2)
            if let b = UInt8(hexString[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
//    func DrawFont(image: NSImage, text: String, point: CGPoint) {
//        var font = NSFont(name: "Arial", size: 10)
//        NSGraphicsContext.current()?.cgContext.image
//        
//        
//    }
    
    func GetDenomination(sn: Int) -> Int
    {
        var nom: Int = 0
        if (sn < 1)
        {
            nom = 0
        }
        else if (sn < 2097153)
        {
            nom = 1
        }
        else if (sn < 4194305)
        {
            nom = 5
        }
        else if (sn < 6291457)
        {
            nom = 25
        }
        else if (sn < 14680065)
        {
            nom = 100
        }
        else if (sn < 16777217)
        {
            nom = 250
        }
        else
        {
            nom = 0
        }
        return nom
    }
    
    private func ReadJson(fileUrl: URL) -> CoinStack? {
        let coinsContent = try? String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
        let coinsData = coinsContent?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var json = try? JSONSerialization.jsonObject(with: coinsData!, options: []) as? [String: Any]
        let contents = json??["cloudcoin"] as! [[String: Any]]!
        if let stack = CoinStack(jsonArray: contents!, isFromOutSide: true){
            return stack
        }
        return CoinStack()
    }
}
