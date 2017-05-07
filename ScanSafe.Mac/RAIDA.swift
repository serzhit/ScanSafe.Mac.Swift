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
    var NodesArray: [Node?] = Array<Node?>(repeating: nil, count: NODEQUANTITY)
    var EchoStatus: [RAIDAResponse?] = Array<RAIDAResponse?>(repeating: nil, count: NODEQUANTITY)
    //Singeton pattern
    private static let theOnlyInstance: RAIDA? = RAIDA()
    public static var Instance: RAIDA?
    {
        return theOnlyInstance
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
        for node: Node? in NodesArray {
            EchoStatus[node!.Number] = node!.Echo()
        }
    }
}

struct RAIDAResponse {
    var server: String
    var status: String
    var sn: String
    var message: String
    var time: String
    
    init() {
        server = "unknown"
        status = "unknown"
        sn = "none"
        message = "none"
        time = "never"
    }
    
    init?(json: [String: Any]) {
        guard let server = json["server"] as? String,
            let st = json["status"] as? String,
            let sn = json["sn"] as? String,
            let message = json["message"] as? String,
            let time = json["time"] as? String
        else {
            return nil
        }
        
        self.server = server
        self.status = st
        self.sn = sn
        self.message = message
        self.time = time
    }
}
