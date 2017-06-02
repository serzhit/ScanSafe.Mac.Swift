//
//  CoinStack.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 04.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class CoinStack: Sequence {
    //properties
    var cloudcoinSet: Set<CloudCoin>?
    
    //computable properties
    var coinsInStack: Int {
        return cloudcoinSet!.count
    }
    var SumInStack: Int {
        var s = 0
        for cccc in cloudcoinSet! {
            s += Utils.Denomination2Int(forValue: cccc.denomination)
        }
        return s
    }
    var SumOfGoodCoins: Int {
    var s = 0
        for cccc in cloudcoinSet! {
            if cccc.Verdict != Status.Counterfeit {
                s += Utils.Denomination2Int(forValue: cccc.denomination)
            }
        }
        return s
    }
//    var Ones: Int {
//        return cloudcoinSet!.filter({$0.denomination == Denomination.One}).count
//    }
//    var Fives: Int {
//        return cloudcoinSet!.filter({$0.denomination == Denomination.Five}).count
//    }
//    var Quarters: Int {
//        return cloudcoinSet!.filter({$0.denomination == Denomination.Quarter}).count
//    }
//    var Hundreds: Int {
//        return cloudcoinSet!.filter({$0.denomination == Denomination.Hundred}).count
//    }
//    var KiloQuarters: Int {
//        return cloudcoinSet!.filter({$0.denomination == Denomination.KiloQuarter}).count
//    }
    
    func QuantityByDenom(denomination: Denomination, status : Status) -> Int {
        if status == .None
        {
            return cloudcoinSet!.filter({$0.denomination == denomination}).count
        }
        else
        {
            return cloudcoinSet!.filter({$0.denomination == denomination && $0.Verdict == status}).count
        }
    }
    
    var AuthenticatedQuantity: Int {
        return cloudcoinSet!.filter({$0.Verdict == Status.Authenticated}).count;
    }
    var FractionedQuantity: Int {
        return cloudcoinSet!.filter({$0.Verdict == Status.Fractioned}).count;
    }
    var CounterfeitedQuantity: Int {
        return cloudcoinSet!.filter({$0.Verdict == Status.Counterfeit}).count;
    }
    
    //Constructors
    init() {
        self.cloudcoinSet = Set<CloudCoin>()
    }
    init(_ coin: CloudCoin) {
        let coll: [CloudCoin] = [coin]
        self.cloudcoinSet = Set(coll)
    }
    init(stack: Set<CloudCoin>) {
        self.cloudcoinSet = stack
    }
    init(collection: AnyCollection<CloudCoin>) {
        self.cloudcoinSet = Set(collection)
    }
    
    //Methods
    func Add(_ coin: CloudCoin) {
        self.cloudcoinSet?.insert(coin)
    }
    
    func Add(stack: CoinStack) {
        for coin in stack.cloudcoinSet! {
            self.cloudcoinSet!.insert(coin)
        }
    }
    
    func Remove(stack: CoinStack) {
        for coin in stack.cloudcoinSet! {
            self.cloudcoinSet!.remove(coin)
        }
    }
    
    func makeIterator()-> SetIterator<CloudCoin> {
        return self.cloudcoinSet!.makeIterator()
    }
    
    func GetDictionary() -> [[String:Any]] {
        var allDictionaries: [[String: Any]] = []
        for coin in cloudcoinSet!
        {//    case pass = 0, fail, error, fixing, unknown
            var detectIntArray :[Int] = []
            for detectStatus in coin.detectStatus
            {
                var detectInt = 4
                switch(detectStatus)
                {
                case .pass :
                    detectInt = 0
                    break
                case .fail:
                    detectInt = 1
                    break
                case .error:
                    detectInt = 2
                    break
                case .fixing:
                    detectInt = 3
                    break
                case .unknown:
                    detectInt = 4
                    break
                }
                detectIntArray.append(detectInt)
            }
            
            
            let dictionary = [
                "ans": coin.ans,
                "detectStatus": detectIntArray,
                "aoid": coin.aoid,
                "ed": coin.ed,
                "nn": coin.nn,
                "sn": coin.sn] as [String : Any]
            allDictionaries.append(dictionary)
        }
        
        return allDictionaries
    }
    
    init? (jsonArray:[[String: Any]]){
        cloudcoinSet = Set<CloudCoin>()
        for var json in jsonArray {
            guard let ans = json["ans"] as? [String],
                let detectStatus = json["detectStatus"] as? [Int],
                let aoid = json["aoid"] as? [String],
                let ed = json["ed"] as? String,
                let nn = json["nn"] as? Int,
                let sn = json["sn"] as? Int
                else {
                    return nil
            }
            
            var coin = CloudCoin(nn: nn, sn: sn, ans: ans, expired: ed, aoid: aoid)
            cloudcoinSet?.insert(coin!)
        }
    }
}
