//
//  Enums.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 08.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

enum Denomination {
    case Unknown, One, Five, Quarter, Hundred, KiloQuarter
}
enum Status {
    case Authenticated, Counterfeit, Fractioned, Unknown
}
enum raidaNodeResponse: Int {
    case pass = 0, fail, error, fixing, unknown
}
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
enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
    case BadFormat = "JSON is not correct"
}
