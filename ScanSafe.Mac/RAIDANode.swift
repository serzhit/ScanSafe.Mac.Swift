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

    var LastEchoStatus: RAIDAResponse?
    
    //computed properties
    var Country: Countries {
        switch Number {
        case 0:
            return Countries.Australia
        case 1:
            return Countries.Macedonia
        case 2:
            return Countries.Philippines
        case 3:
            return Countries.Serbia
        case 4:
            return Countries.Bulgaria
        case 5:
            return Countries.Russia3
        case 6:
            return Countries.Switzerland
        case 7:
            return Countries.UK
        case 8:
            return Countries.Punjab
        case 9:
            return Countries.Banglore
        case 10:
            return Countries.Texas
        case 11:
            return Countries.USA1
        case 12:
            return Countries.Romania
        case 13:
            return Countries.Taiwan
        case 14:
            return Countries.Russia1
        case 15:
            return Countries.Russia2
        case 16:
            return Countries.Columbia
        case 17:
            return Countries.Singapore
        case 18:
            return Countries.Germany
        case 19:
            return Countries.Canada
        case 20:
            return Countries.Venezuela
        case 21:
            return Countries.Hyperbad
        case 22:
            return Countries.USA2
        case 23:
            return Countries.Ukraine
        case 24:
            return Countries.Luxenburg
        default:
            return Countries.USA3
        }
    }
    
    var Location: String {
        return "\(Country)"
    }
    
    var BaseUri: URL? {
        guard let tmp = URL(string: "https://RAIDA\(Number).cloudcoin.global/service") else {
            print("Error creating NSURL...")
            return nil
        }
        return tmp
    }
    var BackupUri: URL? {
        guard let tmp = URL(string: "https://RAIDA\(Number).cloudcoin.ch/service") else {
            print("Error creating NSURL...")
            return nil
        }
        return tmp
    }
    
    //Constructor
    init(number: Int) {
        Number = number
        Name = "RAIDA\(Number)"
    }
    
    //Methods
    func Echo(withinGroup: DispatchGroup) {
        let delegate = RAIDA.Instance?.EchoDelegate
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: "/service/echo", relativeTo: BaseUri!)
        print(url!.absoluteString)
        _ = session.dataTask(with: url!) {
            data, response, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    guard let data = data else {
                        throw JSONError.NoData
                    }
                    let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
                    data.copyBytes(to: ptr, count: data.count)
                    let datastring = String(cString: UnsafePointer(ptr))
                    ptr.deallocate(capacity: data.count)
                    print(datastring)
                    let parsedJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let dict = parsedJson as? NSDictionary
                    if (dict?.value(forKey: "status") as? String) == "ready" {
                        print("Node \(self.Number) is ready")
                        delegate?.EchoReceivedFrom(node: self)
                    }
                    withinGroup.leave()
                    
                } catch let error as NSError {
                    print(error)
                } catch let error as JSONError {
                    print(error.rawValue)
                } catch let error as JSONSerializationError {
                    print(error.rawValue)
                }

            }
        }.resume()
    }
    
    func Detect(withCoin: CloudCoin, completion: @escaping (DetectResponse?) -> Void) {
        let query : String = "/detect?nn=\(withCoin.nn)&sn=\(withCoin.sn)&an=\(withCoin.ans[Number]!)&pan=\(withCoin.pans[Number]!)&denomination=\(Utils.Denomination2Int(forValue: withCoin.denomination))"
        let coinUrl = URL(string: BaseUri!.absoluteString + query)
        var request = URLRequest(url: coinUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard error == nil else {
                print(error!)
                completion(nil)
                return;
            }
            
            guard let data = data else {
                print("Data is empty")
                completion(nil)
                return;
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if (json == nil)
            {
                completion(nil)
                return;
            }
            
            if let detectResult = DetectResponse(json: json!!)
            {
                let number = self.Number
                if detectResult.status == "pass"
                {
                    withCoin.ans[number] = withCoin.pans[number]
                }
                
                switch detectResult.status
                {
                    case "pass" :
                        withCoin.detectStatus[number] = raidaNodeResponse.pass
                        break;
                    case "fail" :
                        withCoin.detectStatus[number] = raidaNodeResponse.fail
                        break;
                    default :
                        withCoin.detectStatus[number] = raidaNodeResponse.error
                }
                completion(detectResult)
            }
        }
        
        task.resume()
    }
    
    func fix(triad: [Node], m1: String, m2: String, m3: String, pan: String, sn: Int, completion: @escaping (DetectResponse?) -> Void) {
        let query : String = "/fix?fromserver1=\(triad[0].Number)&fromserver2=\(triad[1].Number)&fromserver3=\(triad[2].Number)&message1=\(m1)&message2=\(m2)&message3=\(m3)&pan=\(pan))"
        let coinUrl = URL(string: BaseUri!.absoluteString + query)
        var request = URLRequest(url: coinUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else {
                print(error!)
                completion(nil)
                return;
            }
            
            guard let data = data else {
                print("Data is empty")
                completion(nil)
                return;
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if (json == nil)
            {
                completion(nil)
                return;
            }
            
            if let fixResult = DetectResponse(json: json!!) {
                completion(fixResult)
            }
            
        }
        
        task.resume()
    }
    
    func getTicketFromNode(nn: Int, sn: Int, an: String, d: Denomination, completion: @escaping (DetectResponse?) -> Void){
        let query : String = "/get_ticket?nn=\(nn)&sn=\(sn)&an=\(an)&pan=\(an)&denomination=\(Utils.Denomination2Int(forValue: d))"
        let coinUrl = URL(string: BaseUri!.absoluteString + query)
        var request = URLRequest(url: coinUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard error == nil else {
                print(error!)
                completion(nil)
                return;
            }
            
            guard let data = data else {
                print("Data is empty")
                completion(nil)
                return;
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if (json == nil)
            {
                completion(nil)
                return;
            }
            
            if let detectResult = DetectResponse(json: json!!)
            {
                completion(detectResult)
            }
        }
        
        task.resume()
    }
}
