//
//  AppDelegate.swift
//  CloudCoin ScanSafe
//
//  Created by Сергей Житинский on 02.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        let newans = CloudCoin.generatePans()
        RAIDA.Instance?.getEcho()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

