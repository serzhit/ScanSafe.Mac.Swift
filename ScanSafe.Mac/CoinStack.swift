//
//  CoinStack.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 04.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class CoinStack: NSObject {
    //properties
    var cloudcoin: Set<CloudCoin>? = nil
    
    //computable properties
    var coinsInStack: Int {
        return cloudcoin!.count
    }
    var SumInStack: Int {
        var s = 0
        for cccc in cloudcoin! {
            s += Utils.Denomination2Int(forValue: cccc.denomination)
        }
        return s
    }
    var SumOfGoodCoins: Int {
    var s = 0
        for cccc in cloudcoin! {
            if cccc.Verdict != CloudCoin.Status.Counterfeit {
                s += Utils.Denomination2Int(forValue: cccc.denomination)
            }
        }
        return s
    }
    var Ones: Int {
        return (cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.denomination != CloudCoin.Denomination.One }).count)
    }
    var Fives: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.denomination != CloudCoin.Denomination.Five }).count
    }
    var Quarters: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.denomination != CloudCoin.Denomination.Quarter }).count
    }
    var Hundreds: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.denomination != CloudCoin.Denomination.Hundred }).count
    }
    var KiloQuarters: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.denomination != CloudCoin.Denomination.KiloQuarter }).count
    }
    var AuthenticatedQuantity: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.Verdict != CloudCoin.Status.Authenticated }).count
    }
    var FractionedQuantity: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.Verdict != CloudCoin.Status.Fractioned }).count
    }
    var CounterfeitedQuantity: Int {
        return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
            return coin.Verdict != CloudCoin.Status.Counterfeit }).count
    }
    
    //Constructors
    override init() {
        self.cloudcoin = Set<CloudCoin>()
    }
    init(coin: CloudCoin) {
        let coll: [CloudCoin] = [coin]
        self.cloudcoin = Set(coll)
    }
    init(stack: Set<CloudCoin>) {
        self.cloudcoin = stack
    }
    init(collection: AnyCollection<CloudCoin>) {
        self.cloudcoin = Set(collection)
    }
    
    //Methods
    func Add(coin: CloudCoin) {
        self.cloudcoin?.insert(coin)
    }
    func Add(stack: CoinStack) {
        for coin in stack.cloudcoin! {
            self.cloudcoin!.insert(coin)
        }
    }
    func Remove(stack: CoinStack) {
        for coin in stack.cloudcoin! {
            self.cloudcoin!.remove(coin)
        }
    }
}
