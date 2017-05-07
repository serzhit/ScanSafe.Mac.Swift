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

protocol RAIDADetectDelegate {
    func DetectCompletedOn(node: Node)
    func RAIDADetectionCompleted()
}
