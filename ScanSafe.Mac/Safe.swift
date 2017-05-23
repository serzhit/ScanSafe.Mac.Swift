//
//  Safe.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 20.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class Safe: NSObject {
    // Constants
    static let SLOGAN: String = "Не в силе Бог, а в правде!"
    
    // Singleton
    private static let theOnlySafeInstance:  Safe? = nil
    static var Instance: Safe? {
        get {
            return theOnlySafeInstance ?? GetInstance();   //Singleton Fabric
        }
    }

    
    //Static fields
    private static var cryptPassFromFile: String? //encrypted string which has been read from Safe file
    private static var userEnteredPassword: String?
    private static var encryptedUserEnteredPassword: [UInt8]?
    private static let salt: [UInt8] = Array(SLOGAN.utf8)
    
    private static func GetInstance() -> Safe? {
        let filePath: String = (FileSystem.settingsDict?.object(forKey: "SafeFolder") as! String) + NSUserName() + ".safe"
        let bkpFilePath: String = "\(filePath).bkp"
        
        if !FileSystem.FM.fileExists(atPath: bkpFilePath) {
            FileSystem.FM.createFile(atPath: bkpFilePath, contents: nil, attributes: nil)
        }
        if !FileSystem.FM.fileExists(atPath: filePath) {
            let setPassword = SetPassword()
            while !setPassword.isPasswordSet {
                continue
            }
            userEnteredPassword = setPassword.Password
        }
    }    
}
