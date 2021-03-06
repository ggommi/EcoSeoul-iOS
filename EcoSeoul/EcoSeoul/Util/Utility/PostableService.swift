//
//  PostableService.swift
//  EcoSeoul
//
//  Created by 이충신 on 2018. 9. 25..
//  Copyright © 2018년 GGOMMI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PostableService {
    
    associatedtype NetworkData : Codable
    
    func post(_ URL:String, params : [String : Any], completion : @escaping (Result<NetworkData>)->Void)
    
    func delete(_ URL:String, params : [String : Any], completion : @escaping (Result<NetworkData>)->Void)
}

extension PostableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    
    func post(_ URL:String, params : [String : Any], completion : @escaping (Result<NetworkData>)->Void){
        
        Alamofire.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData(){
            res in

            switch res.result {
            case .success:
                
                if let value = res.result.value {
                   
                    let decoder = JSONDecoder()
                    
                    do {
                        let data = try decoder.decode(NetworkData.self, from: value)
                        completion(.success(data))
                        
                    }catch{
                        print("\n<*******Postable Error 내용 *******>")
                        print("\(error)")
                        completion(.error("error"))
                    }
                }
                break
            case .failure(let err):
                completion(.failure(err))
                break
            }
        }
        
        
    }
    
    
    func delete(_ URL:String, params : [String : Any], completion : @escaping (Result<NetworkData>)->Void){
        
        Alamofire.request(URL, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData(){
            res in
            switch res.result {
            case .success:
                
                if let value = res.result.value {
                    

                    let decoder = JSONDecoder()
                    
                    do {
                        let data = try decoder.decode(NetworkData.self, from: value)
                        completion(.success(data))
                        
                    }catch{
                        
                        completion(.error("error"))
                    }
                }
                break
            case .failure(let err):
                completion(.failure(err))
                break
            }
        }
        
        
    }
}
