//
//  NetworkManager.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 30.07.22.
//

import Foundation


struct NetworkManager {
    static let shared = NetworkManager()    
    
    func getUser(perPage: Int, page: Int, completion: @escaping (_ result: Result?, _ succeeded: Bool) -> Void ) {
        Networking.shared.getUser(perPage: perPage, page: page) { data, error in
            if error == nil {
                if let data = data {
                    let decocder = JSONDecoder()
                    do {
                        let result = try decocder.decode(Result.self, from: data)
                        ResourceManager.shared.users.append(contentsOf: result.users)
                        ResourceManager.shared.info = result.info
                        completion(result, true)
                    } catch {
                        completion(nil, false)
                    }
                }
            }
        }
    }
}
