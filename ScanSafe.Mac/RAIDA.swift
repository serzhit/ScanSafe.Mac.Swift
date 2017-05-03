//
//  RAIDA.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 03.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class RAIDA: NSObject {
    //constants needed in other classes
    static let NODEQUANTITY = 25
    static let MINNODES4PASS = 13
    enum Countries {
        case
        Australia,
        Macedonia,
        Philippines,
        Serbia,
        Bulgaria,
        Russia3,
        Ukraine,
        UK,
        Punjab,
        Banglore,
        Texas,
        USA1,
        USA2,
        USA3,
        Romania,
        Taiwan,
        Russia1,
        Russia2,
        Columbia,
        Singapore,
        Germany,
        Canada,
        Venezuela,
        Hyperbad,
        Switzerland,
        Luxenburg
    }
    
    //properties
    var NodesArray: [Node] = []
    var EchoStatus: [RAIDAResponse] = []
    
    //Singeton pattern
    static let theOnlyInstance: RAIDA? = RAIDA()
    static var Instance: RAIDA? {
        return self.theOnlyInstance
    }
    
    override init() {
        for i in 0..<RAIDA.NODEQUANTITY {
            self.NodesArray[i] = Node(number: i)
            self.EchoStatus[i] = RAIDAResponse()
        }
        super.init()
    }
    
    //methods
    func getEcho() {
        for node: Node in NodesArray {
            EchoStatus[node.Number] = node.Echo()
        }
    }
    
    
}

class RAIDAResponse: NSObject {
    var server: String
    var status: String
    var sn: String
    var message: String
    var time: String
    
    override init() {
        self.server = "unknown"
        self.status = "unknown"
        self.sn = "0"
        self.message = "Not yet replied"
        self.time = "never"
    }
    init(server: String, status: String, sn: String, message: String, time: String) {
        self.server = server
        self.status = status
        self.sn = sn
        self.message = message
        self.time = time
    }
    
}
