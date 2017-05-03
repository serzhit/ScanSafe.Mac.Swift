//
//  RAIDANode.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 03.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class Node: NSObject {
    //properties
    let Number: Int
    let Name: String
    var LastEchoStatus: RAIDAResponse
    
    //countable properties
    var Country: RAIDA.Countries {
        switch Number {
        case 0:
            return RAIDA.Countries.Australia
        case 1:
            return RAIDA.Countries.Macedonia
        case 2:
            return RAIDA.Countries.Philippines
        case 3:
            return RAIDA.Countries.Serbia
        case 4:
            return RAIDA.Countries.Bulgaria
        case 5:
            return RAIDA.Countries.Russia3
        case 6:
            return RAIDA.Countries.Switzerland
        case 7:
            return RAIDA.Countries.UK
        case 8:
            return RAIDA.Countries.Punjab
        case 9:
            return RAIDA.Countries.Banglore
        case 10:
            return RAIDA.Countries.Texas
        case 11:
            return RAIDA.Countries.USA1
        case 12:
            return RAIDA.Countries.Romania
        case 13:
            return RAIDA.Countries.Taiwan
        case 14:
            return RAIDA.Countries.Russia1
        case 15:
            return RAIDA.Countries.Russia2
        case 16:
            return RAIDA.Countries.Columbia
        case 17:
            return RAIDA.Countries.Singapore
        case 18:
            return RAIDA.Countries.Germany
        case 19:
            return RAIDA.Countries.Canada
        case 20:
            return RAIDA.Countries.Venezuela
        case 21:
            return RAIDA.Countries.Hyperbad
        case 22:
            return RAIDA.Countries.USA2
        case 23:
            return RAIDA.Countries.Ukraine
        case 24:
            return RAIDA.Countries.Luxenburg
        default:
            return RAIDA.Countries.USA3
        }
    }
    
    var Location: String {
        return "\(Country)"
    }
    
    var BaseUri: NSURL {
        return NSURL(string: "https://RAIDA\(Number).cloudcoin.global/service")!
    }
    var BackupUri: NSURL {
        return NSURL(string: "https://RAIDA\(Number).cloudcoin.ch/service")!
    }
    
    init(number: Int) {
        Number = number
        Name = "RAIDA\(Number)"
        LastEchoStatus = 
    }
}
