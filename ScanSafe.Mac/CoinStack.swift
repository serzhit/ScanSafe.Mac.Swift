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
    var cloudcoin: Set<CloudCoin>?
    
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
            if cccc.Verdict != Status.Counterfeit {
                s += Utils.Denomination2Int(forValue: cccc.denomination)
            }
        }
        return s
    }
    var Ones: Int {
        //return (cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.denomination != Denomination.One }).count)
        return 0;
    }
    var Fives: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.denomination != Denomination.Five }).count
        return 0;
    }
    var Quarters: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.denomination != Denomination.Quarter }).count
        return 0;
    }
    var Hundreds: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.denomination != Denomination.Hundred }).count
        return 0;
    }
    var KiloQuarters: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.denomination != Denomination.KiloQuarter }).count
        return 0;
    }
    var AuthenticatedQuantity: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.Verdict != Status.Authenticated }).count
        return 0;
    }
    var FractionedQuantity: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.Verdict != Status.Fractioned }).count
        return 0;
    }
    var CounterfeitedQuantity: Int {
        //return cloudcoin!.drop(while: { (coin: CloudCoin) -> Bool in
        //    return coin.Verdict != Status.Counterfeit }).count
        return 0;
    }
    
    //Constructors
    init() {
        self.cloudcoin = Set<CloudCoin>()
    }
    init(_ coin: CloudCoin) {
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
    func Add(_ coin: CloudCoin) {
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
    func makeIterator()-> SetIterator<CloudCoin> {
        return self.cloudcoin!.makeIterator()
    }
}
