//
//  CloudCoin.swift
//  CloudCoin ScanSafe
//
//  Created by Сергей Житинский on 02.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class CloudCoin: NSObject {
    
    enum Denomination {
        case Unknown, One, Five, Quarter, Hundred, KiloQuarter
    }
    enum Status {
        case Authenticated, Counterfeit, Fractioned, Unknown
    }
    enum raidaNodeResponse {
        case pass, fail, error, fixing, unknown
    }
    
    var nn: Int
    var sn: Int
    var denomination: Denomination {
        if (sn < 1) { return Denomination.Unknown }
        else if (sn < 2097153) { return Denomination.One }
        else if (sn < 4194305) { return Denomination.Five }
        else if (sn < 6291457) { return Denomination.Quarter }
        else if (sn < 14680065){ return Denomination.Hundred }
        else if (sn < 16777217){ return Denomination.KiloQuarter }
        else { return Denomination.Unknown }
    }
    var ans: [String?]
    var pans: [String?]
    var aoid: [String?]
    var ed: String
    var detectStatus: [raidaNodeResponse]
    
    var percentOfRAIDAPass: Int {
        let passed = CountStatuses(raidaNodeResponse.pass)
        return passed*100/detectStatus.count
    }
    var isPassed: Bool {
        let passed = CountStatuses(raidaNodeResponse.pass)
        
        return (passed > RAIDA.NODEQUANTITY) ? true : false
    }
    var Verdict: Status {
        if (percentOfRAIDAPass != 100) {
            return isPassed ? Status.Fractioned : Status.Counterfeit
        }
        else {
            return isPassed ? Status.Authenticated : Status.Counterfeit
        }
    }
    var isValidated: Bool = false
    
    init (nn: Int,sn: Int, ans: [String], expired: String, aoid: [String]) {
        
        self.sn = sn;
        self.nn = nn;
        self.ans = ans;
        ed = expired;
        self.aoid = aoid;
        
        detectStatus = Array(repeating: raidaNodeResponse.unknown, count: RAIDA.NODEQUANTITY)
        
        pans = CloudCoin.generatePans()
        super.init()
        isValidated = self.Validate()
    }
    
    static func generatePans() -> [String?] {
        var result = Array<String?>(repeating: nil, count: RAIDA.NODEQUANTITY)
        for i in 0..<RAIDA.NODEQUANTITY {
            let randstr: String = Utils.randomString(length: 32)
            result[i] = randstr
        }//end for each Pan
        return result
    }
    
    func Validate() -> Bool {
        guard nn == 1 else {
            return false
        }
        guard sn >= 0 && sn < 16777216 else {
            return false
        }
        guard !(ans.isEmpty) else {
            return false
        }
        guard ans.count == RAIDA.NODEQUANTITY else {
            return false
        }
        for anValue in ans {
            guard anValue?.lengthOfBytes(using: String.Encoding.ascii) == 32
            else { return false }
        }
        
        return true
    }
    
    func CountStatuses(_ status: raidaNodeResponse) -> Int {
        var quantity = 0
        for st in detectStatus {
            if st == status { quantity+=1 }
        }
        return quantity
    }
    
}
