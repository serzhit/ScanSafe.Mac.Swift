//
//  FixitHelper.swift
//  ScanSafe.Mac
//
//  Created by Gao on 6/12/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class FixitHelper {
    //instance variables
    var trustedServers = [Node?](repeating: nil, count: 8)
    
    //Each servers only trusts eight others
    var trustedTraid1: [Node] = []
    var trustedTraid2: [Node] = []
    var trustedTraid3: [Node] = []
    var trustedTraid4: [Node] = []
    var currentTraid: [Node] = []
    var ans1: [String?] = []
    var ans2: [String?] = []
    var ans3: [String?] = []
    var ans4: [String?] = []
    var currentAns = [String?](repeating: nil, count: 4)
    var finished = false
    
    let traid_1_is_ready = false
    let traid_2_is_ready = false
    let traid_3_is_ready = false
    let traid_4_is_ready = false
    var currentTraidReady = false
    
    init(raidaNumber: Int, ans: [String?]) {
        self.trustedServers = getTrustedServers(raidaNumber: raidaNumber)
        
        self.trustedTraid1 = [trustedServers[0]!, trustedServers[1]!, trustedServers[3]!]
        self.trustedTraid2 = [trustedServers[1]!, trustedServers[2]!, trustedServers[4]!]
        self.trustedTraid3 = [trustedServers[3]!, trustedServers[5]!, trustedServers[6]!]
        self.trustedTraid4 = [trustedServers[4]!, trustedServers[6]!, trustedServers[7]!]
        self.currentTraid = trustedTraid1
        //Try the first tried first
        
        ans1 = [ans[trustedTraid1[0].Number], ans[trustedTraid1[1].Number], ans[trustedTraid1[2].Number]]
        ans2 = [ans[trustedTraid2[0].Number], ans[trustedTraid2[1].Number], ans[trustedTraid2[2].Number]]
        ans3 = [ans[trustedTraid3[0].Number], ans[trustedTraid3[1].Number], ans[trustedTraid3[2].Number]]
        ans4 = [ans[trustedTraid4[0].Number], ans[trustedTraid4[1].Number], ans[trustedTraid4[2].Number]]
        currentAns = ans1
    }
    
    func getTrustedServers(raidaNumber: Int) -> [Node?] {
        var result = [Node?](repeating: nil, count: 8)
        let i = raidaNumber
        result = [RAIDA.Instance?.NodesArray[(i+19)%25], RAIDA.Instance?.NodesArray[(i+20)%25],
                RAIDA.Instance?.NodesArray[(i+21)%25], RAIDA.Instance?.NodesArray[(i+24)%25],
                RAIDA.Instance?.NodesArray[(i+26)%25], RAIDA.Instance?.NodesArray[(i+29)%25],
                RAIDA.Instance?.NodesArray[(i+30)%25], RAIDA.Instance?.NodesArray[(i+31)%25]]
        return result
    }
    
    func setCornerToCheck(corner: Int) {
        switch (corner) {
        case 1:
            self.currentTraid = self.trustedTraid1
            currentTraidReady = traid_1_is_ready
            break
        case 2:
            self.currentTraid = self.trustedTraid2
            currentTraidReady = traid_2_is_ready
            break
        case 3:
            self.currentTraid = self.trustedTraid3
            currentTraidReady = traid_3_is_ready
            break
        case 4:
            self.currentTraid = self.trustedTraid4
            currentTraidReady = traid_4_is_ready
            break
        default:
            self.finished = true
            break
        }
    }
    
    func setCornerToTest(mode: Int) {
        switch (mode) {
        case 1:
            currentTraid = trustedTraid1
            currentAns = ans1
            currentTraidReady = true
            break
        case 2:
            currentTraid = trustedTraid2
            currentAns = ans2
            currentTraidReady = true
            break
        case 3:
            currentTraid = trustedTraid3
            currentAns = ans3
            currentTraidReady = true
            break
        case 4:
            currentTraid = trustedTraid4
            currentAns = ans4
            currentTraidReady = true
            break
        default:
            self.finished = true
            break
        }
    }
}
