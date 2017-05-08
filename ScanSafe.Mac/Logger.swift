//
//  Logger.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 08.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class Logger: NSObject {
    enum Level { case Warning, Normal, Error, Debug }
    static let logdir: String? = FileSystem.settingsDict?.object(forKey: "LogFolder") as? String
    static let logFile: String = "\(logdir!) cloudcoin.log"
    
    static func Initialize() {
        if !FileSystem.FM.fileExists(atPath: logFile) {
            guard FileSystem.FM.createFile(atPath: logFile, contents: Data(capacity: 0)) else {
                print("Cannot create Log file: \(logFile)")
                return
            }
        }
    }
}
