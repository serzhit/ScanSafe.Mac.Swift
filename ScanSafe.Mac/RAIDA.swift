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
    
    //properties
    var NodesArray: [Node?] = Array<Node?>(repeating: nil, count: NODEQUANTITY)
    var EchoStatus: [RAIDAResponse?] = Array<RAIDAResponse?>(repeating: nil, count: NODEQUANTITY)
    
    //Singeton pattern
    private static let theOnlyInstance: RAIDA? = RAIDA()
    
    public static var Instance: RAIDA?
    {
        return theOnlyInstance
    }
    
    //Delegates
    var EchoDelegate: RAIDAEchoDelegate?
    var DetectDelegate: RAIDADetectDelegate?
    
    //Constructor
    override init() {
        for i in 0..<RAIDA.NODEQUANTITY {
            self.NodesArray[i] = Node(number: i)
//            self.EchoStatus[i] = nil
        }
        super.init()
    }
    
    //methods
    func getEcho() {
        let myGroup = DispatchGroup()
        for node: Node? in NodesArray {
            myGroup.enter()
            node!.Echo(withinGroup: myGroup)
        }
        myGroup.notify(queue: .main) {
            self.EchoDelegate?.AllEchoesReceived()
        }
    }
    
    func Detect(stack: CoinStack, ArePasswordsToBeChanged: Bool) {
        let stackGroup = DispatchGroup()
        var coinSetGroup = Set<DispatchGroup>()
        
        for coin: CloudCoin in stack {
            stackGroup.enter()
            let coinGroup = DispatchGroup();
            coinSetGroup.insert(coinGroup)
            
            for node: Node? in NodesArray {
                coinGroup.enter()
                
                node!.Detect(withCoin: coin){detectResult in
                    if detectResult != nil
                    {
                        coinGroup.leave()
                        self.DetectDelegate?.ProgressUpdated(progress: 100 / (Double)(stack.coinsInStack * self.NodesArray.count))
                    }
                }
            }
            coinGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                stackGroup.leave()
                self.DetectDelegate?.DetectCompletedOn(coin: coin)
            }
        }
        
        stackGroup.notify(queue: DispatchQueue.main) {
            self.DetectDelegate?.CoinDetectionCompleted()
        }
    }
}

struct RAIDAResponse {
    enum Status: String {
        case ready, fail, error
    }
    var server: String
    var status: String
//    var sn: String?
    var message: String
    var time: String
/*
    init() {
        server = "unknown"
        status = "unknown"
//        sn = "none"
        message = "none"
        time = "never"
    }
*/
    init?(json: [String: String]) throws {
        guard let server = json["server"] else {
            throw JSONSerializationError.missingServer
        }
        guard let st = json["status"] else {
            throw JSONSerializationError.missingStatus
        }
//            let sn: String = json["sn"] as? String,
        guard let message = json["message"] else {
            throw JSONSerializationError.missingMessage
        }
        guard let time = json["time"] else {
            throw JSONSerializationError.missingTime
        }
        guard let status = Status(rawValue: st) else {
            throw JSONSerializationError.invalidStatus
        }
        self.server = server
        self.status = status.rawValue
//        self.sn = sn
        self.message = message
        self.time = time

    }
}

enum JSONSerializationError: String, Error {
    case missingServer = "Missing 'server' in json"
    case missingStatus = "Missing 'status' in json"
    case missingMessage = "Missing 'message' in json"
    case missingTime = "Missing 'time' in json"
    case invalidStatus = "Invalid status in message"
}
