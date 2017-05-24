//
//  Safe.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/22/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa
import CryptoSwift

class Safe: NSObject {
    static let Slogan = "Не в силе Бог, а в правде!"
    
    static let SafeFileName: String = "Cloudcoin/Safe.safe"
    static let UserCloudcoinDir: String = "Cloudcoin"
    static let UserCloudcoinImportDir: String = "Cloudcoin/Import"
    static let UserCloudcoinExportDir: String = "Cloudcoin/Export"
    static let UserCloudcoinBackupDir: String = "Cloudcoin/Backup"
    static let userCloudcoinLogDir: String = "Cloudcoin/Log"
    static let userCloudcoinTemplateDir: String="Cloudcoin/Templates"
    
    static func Instance() -> Safe? {
        if theOnlySafeInstance == nil {
            return GetInstance()
        }
        return theOnlySafeInstance!
    }
    
    let safeFilePath: String
    let bkpFilePath: String
    let safeFileUrl: URL
    let bkpFileUrl: URL
    let contents: CoinStack
    
    init(filePath: URL, coins: CoinStack) {
        safeFilePath = filePath.path
        bkpFilePath = filePath.path + ".bkp"
        safeFileUrl = filePath
        bkpFileUrl = URL(fileURLWithPath: bkpFilePath)
        contents = coins;
    }
    
    static var theOnlySafeInstance: Safe? = nil
    
    static let cryptPassFromFile: String = "" //encrypted string which has been read from Safe file
    static var userEnteredPassword: String = ""
    static var encryptedUserEnteredPassword: String = ""
    
    static func GetInstance() -> Safe? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent(SafeFileName)
//            let bkpFilePath = dir.appendingPathComponent(SafeFileName + ".bkp")
            let fileManager = FileManager.default
            
            userEnteredPassword = UserInteraction.password
            encryptedUserEnteredPassword = userEnteredPassword.sha1()
            
            if (!fileManager.fileExists(atPath: filePath.path))
            { //Safe does not exist, create one
                if (userEnteredPassword != "")
                {
                    let coins = CoinStack()
                    if (CreateSafeFile(filePath: filePath, stack: coins))
                    {
                        theOnlySafeInstance = Safe(filePath: filePath, coins: coins)
                        return theOnlySafeInstance
                    }
                }
                else
                {
                    return nil;
                }
            }
            else { //Safe already exists
                if (userEnteredPassword != "")
                {
                    let safeContents = ReadSafeFile(filePath: filePath)
                    theOnlySafeInstance = Safe(filePath: filePath, coins: safeContents)
                }
                else {
                    return nil;
                }
            }
        }
        
        return nil
    }
    
    static func CreateSafeFile(filePath: URL, stack: CoinStack) -> Bool
    {
        let stackDic = stack.GetDictionary()
        if let theJsonData = try? JSONSerialization.data(withJSONObject: stackDic, options: []) {
            let theJsonText = String(data: theJsonData, encoding: .ascii)
            let password: Array<UInt8> = Array(userEnteredPassword.utf8)
            let salt: Array<UInt8> = Array(Slogan.utf8)
            let key = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()
            let iv = Array(key[0...15])
            let cryptedJson = try? theJsonText!.aesEncrypt(key: key, iv: iv)
            
            try? encryptedUserEnteredPassword.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            try? cryptedJson!.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            
            return true;
        }
        
        return false
    }
    
    static func ReadSafeFile(filePath: URL) -> CoinStack {
        return CoinStack()
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
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

