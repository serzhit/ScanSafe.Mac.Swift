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
    var Contents: CoinStack
    
    init(filePath: URL, coins: CoinStack) {
        safeFilePath = filePath.path
        bkpFilePath = filePath.path + ".bkp"
        safeFileUrl = filePath
        bkpFileUrl = URL(fileURLWithPath: bkpFilePath)
        Contents = coins;
    }
    
    static var theOnlySafeInstance: Safe? = nil
    
    static let cryptPassFromFile: String = "" //encrypted string which has been read from Safe file
    static var userEnteredPassword: String = ""
    static var encryptedUserEnteredPassword: String = ""
    
    static func GetInstance() -> Safe? {
        
        let filePath = Utils.GetFileUrl(path: SafeFileName)
//            let bkpFilePath = dir.appendingPathComponent(SafeFileName + ".bkp")
        
        userEnteredPassword = UserInteraction.password
        encryptedUserEnteredPassword = userEnteredPassword.sha1()
        
        if (!Utils.FileExists(url: filePath!))
        { //Safe does not exist, create one
            if (userEnteredPassword != "")
            {
                let coins = CoinStack()
                let folderPath = Utils.GetFileUrl(path: "Cloudcoin")
                
                try? FileManager.default.createDirectory(at: folderPath!, withIntermediateDirectories: false, attributes: nil)
                if (CreateSafeFile(filePath: filePath!, stack: coins))
                {
                    theOnlySafeInstance = Safe(filePath: filePath!, coins: coins)
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
                let safeContents = ReadSafeFile(filePath: filePath!)
                theOnlySafeInstance = Safe(filePath: filePath!, coins: safeContents)
            }
            else {
                return nil;
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
            let cryptedJson = try! theJsonText!.aesEncrypt(key: key, iv: iv)
            
            try? (encryptedUserEnteredPassword + cryptedJson).write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            
            return true;
        }
        
        return false
    }
    
    static func ReadSafeFile(filePath: URL) -> CoinStack {
        return CoinStack()
    }
    
    func Add(stack: CoinStack)
    {
        Contents.Add(stack: stack)
        RemoveCounterfeitCoins();
        //SafeContentChanged();
        Save();
    }
    
    func Remove(coin: CloudCoin)
    {
        Contents.cloudcoinSet?.remove(coin)
        //SafeContentChanged()
        Save();
    }
    
    func Save() {
        
    }
    
    func RemoveCounterfeitCoins(){
        
    }
    
    
}


