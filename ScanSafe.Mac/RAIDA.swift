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
    static let NODEQNTY = 25
    static let MINNODES4PASS = 13
    static let MINTRUSTEDNODES4AUTH = 8
    var fixer: FixitHelper?
    
    //properties
    var NodesArray: [Node?] = Array<Node?>(repeating: nil, count: NODEQNTY)
    var EchoStatus: [RAIDAResponse?] = Array<RAIDAResponse?>(repeating: nil, count: NODEQNTY)
    
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
        for i in 0..<RAIDA.NODEQNTY {
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
        var coinSetGroup = [DispatchGroup]()
        var coinList = [CloudCoin]()
        
        for coin: CloudCoin in stack {
            stackGroup.enter()
            let coinGroup = DispatchGroup();
            coinSetGroup.append(coinGroup)
            coinList.append(coin)
            
            if (!ArePasswordsToBeChanged)
            {
                coin.pans = coin.ans
            }
            
            for node: Node? in NodesArray {
                coinGroup.enter()
                
                node!.Detect(withCoin: coin){detectResult in
                    coinGroup.leave()
                    if detectResult != nil
                    {
                        self.DetectDelegate?.ProgressUpdated(progress: 100 / (Double)(stack.coinsInStack * self.NodesArray.count))
                    }
                }
            }
            
            coinGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                DispatchQueue.main.async {
                    stackGroup.leave()
                    print("coin detected")
                    let index = coinSetGroup.index(of: coinGroup)
                    self.DetectDelegate?.DetectCompletedOn(coin: coinList[index!])
                }
            }
        }
        
        stackGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                self.DetectDelegate?.CoinDetectionCompleted()
            }
        }
    }
    
    func fixCoin(brokeCoin: CloudCoin, coinindex: Int, completion: @escaping (raidaNodeResponse?) -> Void) {
        var result = [raidaNodeResponse]()
        
        for index in 0...RAIDA.NODEQNTY-1 {
            result.append(raidaNodeResponse.unknown)
            if brokeCoin.detectStatus[index] != .pass {
                //onCoinFixStarted();
                ProcessFixingGUID(guid_id: index, returnCoin: brokeCoin, coinindex: coinindex) { result in
                    completion(result)
                }
            }
            else {
                result[index] = brokeCoin.detectStatus[index]
            }
        }
    }
    
    
    
    func ProcessFixingGUID(guid_id: Int, returnCoin: CloudCoin, coinindex: Int, completion: @escaping (raidaNodeResponse?) -> Void) {
        fixer = FixitHelper(raidaNumber: guid_id, ans: returnCoin.ans)
        var ticketStatus = [DetectResponse?](repeating: nil, count: 3)
        var corner = 1
        var result : raidaNodeResponse = .unknown
//        let detectGroup = DispatchGroup()
        
//        while(!(fixer?.finished)!) {
        for index in 1...30 {
            //onCoinFixProcessing(new )
//            detectGroup.enter()
        
            let trustedServerAns = [returnCoin.ans[(fixer?.currentTraid[0].Number)!], returnCoin.ans[(fixer?.currentTraid[1].Number)!], returnCoin.ans[(fixer?.currentTraid[2].Number)!]]
            
            getTickets(traid: (fixer?.currentTraid)!, ans: trustedServerAns as! [String], nn: returnCoin.nn, sn: returnCoin.sn, denomination: returnCoin.denomination) { ticketStatus in
                // See if there are errors in the tickets

                
                if ticketStatus[0]?.status != "ticket" || ticketStatus[1]?.status != "ticket" || ticketStatus[2]?.status != "ticket" {
                    corner += 1
                    self.fixer?.setCornerToCheck(corner: corner)
                }
                else { // Has three good tickets
                    self.NodesArray[guid_id]?.fix(triad: (self.fixer?.currentTraid)!, m1: (ticketStatus[0]?.message)!, m2: (ticketStatus[1]?.message)!, m3: (ticketStatus[2]?.message)!, pan: returnCoin.pans[guid_id]!, sn: returnCoin.sn) {fixResult in
                        if fixResult?.status == "success" {
                            returnCoin.detectStatus[guid_id] = .pass
                            result = .pass
                            //onCoinFixFinished()
                            returnCoin.ans[guid_id] = returnCoin.pans[guid_id]
                            self.fixer?.finished = true
                            completion(result)
                            //return result
                        } else if fixResult?.status == "fail" {
                            corner += 1
                            self.fixer?.setCornerToCheck(corner: corner)
                            returnCoin.detectStatus[guid_id] = .fail
                        } else if fixResult?.status == "error" {
                            corner += 1
                            self.fixer?.setCornerToCheck(corner: corner)
                            returnCoin.detectStatus[guid_id] = .error
                        } else {
                            corner += 1
                            self.fixer?.setCornerToCheck(corner: corner)
                            returnCoin.detectStatus[guid_id] = .error
                        }
//                        detectGroup.leave()
                    }
                }
            }
        }
        
//        detectGroup.notify(queue: DispatchQueue.main) {
//            result = returnCoin.detectStatus[guid_id]
//            //onCoinFixfinished()
//            completion(result)
//        }
    }
    
        
    func getTickets(traid: [Node], ans: [String], nn: Int, sn: Int, denomination: Denomination, completion: @escaping ([DetectResponse?]) -> Void) {
        var returnTicketsStatus = [DetectResponse?](repeating: nil, count: 3)
        let ticketsGroup = DispatchGroup()
        var index = 0
        
        for node in traid {
            ticketsGroup.enter()
            print("count = \(index)")
            node.getTicketFromNode(nn: nn, sn: sn, an: ans[index], d: denomination, index: index) {detectResult, order in
                ticketsGroup.leave()
                returnTicketsStatus[order] = detectResult
            }
            
            index += 1
        }
        
        ticketsGroup.notify(queue: DispatchQueue.main) {
            completion(returnTicketsStatus)
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
