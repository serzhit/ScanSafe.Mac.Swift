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
    
    static let settingsPath: String?  = Bundle.main.path(forResource: "Setttings", ofType: "plist")
    static var settingsDict: NSDictionary? = NSDictionary(contentsOfFile: settingsPath!)

    static func InitializePaths() {
        let homedir: String? = settingsDict?.object(forKey: "AppFolder") as? String
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
        }
        
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
}
