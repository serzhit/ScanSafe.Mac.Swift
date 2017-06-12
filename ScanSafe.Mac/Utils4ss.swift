//
//  Utils.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 03.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class Utils: NSObject {

    static func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEF0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func Denomination2Int(forValue: Denomination) -> Int {
        switch forValue {
            case Denomination.One:
                return 1
            case Denomination.Five:
                return 5
            case Denomination.Quarter:
                return 25
            case Denomination.Hundred:
                return 100
            case Denomination.KiloQuarter:
                return 250
            default:
                return 0
        }
    }
    
//    static func Encrypt(plain: String, password: String, iv: String)
//    {
//        let encrypted = try AES(key: password, iv: iv).encrypt(plain)
//        return encrypted
//    }
    
    static func ToHexString(_ fromData: Data) -> String {
        return fromData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func GetFileUrl(path: String) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent(path)
        }
        return nil;
    }
    
    static func FileExists(url: URL) -> Bool{
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: url.path)
    }
}
