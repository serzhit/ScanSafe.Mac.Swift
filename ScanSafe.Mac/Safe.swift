//
//  Safe.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class Safe: NSObject {
    static let SLOGAN = "Не в силе Бог, а в правде!"
    
    static let SafeFileName: String = "Cloudcoin/Safe.safe"
    static let UserCloudcoinDir: String = "Cloudcoin"
    static let UserCloudcoinImportDir: String = "Cloudcoin/Import"
    static let UserCloudcoinExportDir: String = "Cloudcoin/Export"
    static let UserCloudcoinBackupDir: String = "Cloudcoin/Backup"
    static let userCloudcoinLogDir: String = "Cloudcoin/Log"
    static let userCloudcoinTemplateDir: String="Cloudcoin/Templates"
    
    static func Instance() -> Safe {
        if theOnlySafeInstance == nil {
            return GetInstance()
        }
        return theOnlySafeInstance!
    }
    
    static var theOnlySafeInstance: Safe? = nil
    
    static let cryptPassFromFile: String = "" //encrypted string which has been read from Safe file
    static let userEnteredPassword: String = ""
    static let encryptedUserEnteredPassword: [UInt8] = []
    static let salt = [UInt8](SLOGAN.utf8)
    
    static func GetInstance() -> Safe {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent(SafeFileName)
            let bkpFilePath = dir.appendingPathComponent(SafeFileName + ".bkp")
            let fileManager = FileManager.default
            
            let userEnteredPassword = UserInteraction.password
            
            if (!fileManager.fileExists(atPath: filePath.path))
            { //Safe does not exist, create one
                if (userEnteredPassword != "")
                {
                    
                }
            }
            else { //Safe already exists
            
            }
        }
        theOnlySafeInstance = Safe()
        return theOnlySafeInstance!
    }
}

/*extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}*/
