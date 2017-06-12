//
//  Protocols.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 06.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

protocol RAIDAEchoDelegate {
    func EchoReceivedFrom(node: Node)
    func AllEchoesReceived()
}

protocol ImportDelegate{
    func FinishImported(password: String)
}

protocol DetectDelegate {
    func FinishDetected()
}

protocol RAIDADetectDelegate {
    func DetectCompletedOn(coin: CloudCoin)
    func ProgressUpdated(progress: Double)
    func CoinDetectionCompleted()
}

protocol SafeDelegate{
    func SafeContentChanged()
}

protocol CloudCoinP {
    
    var nn: Int { get set }
    var sn: Int { get set }
    var denomination: Denomination { get }
    var ans: [String?] { get set }
    var pans: [String?] { get set }
    var aoid: [String?] { get set }
    var ed: String { get set }

}