//
//  DetectResponse.swift
//  ScanSafe.Mac
//
//  Created by Gao on 5/21/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Foundation

struct DetectResponse{
    let server: String
    let status: String
    let sn: String
    let message: String
    let time: String
    
}

struct DetectDisplay{
    var Serial: Int
    var Value: Int
    var Check: Bool
    var Comment: String
    
    init(Serial: Int, Value: Int, Check: Bool, Comment: String){
        self.Serial = Serial
        self.Value = Value
        self.Check = Check
        self.Comment = Comment
    }
}

extension DetectResponse{
    init?(json:[String: Any]){
        guard let server = json["server"] as? String,
            let status = json["status"] as? String,
            let sn = json["sn"] as? String,
            let message = json["message"] as? String,
            let time = json["time"] as? String
            else{
                return nil
        }
        
        self.server = server
        self.status = status
        self.sn = sn
        self.message = message
        self.time = time
    }
}

