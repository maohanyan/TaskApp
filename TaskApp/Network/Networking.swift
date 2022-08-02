//
//  Networking.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 31.07.22.
//

import Foundation

struct Networking {
    
    static let shared = Networking()
    private let baseURL = "https://randomuser.me/api?seed=renderforest"
    
    func getUser(perPage: Int, page: Int, completion: @escaping (_ data: Data?, _ Error: Error?) -> Void ) {
        var urlComponents = URLComponents.init(string: baseURL)
        urlComponents?.queryItems = [URLQueryItem.init(name: "results", value: String(perPage)),
                                     URLQueryItem.init(name: "page", value: String(page))]
        let url = urlComponents?.url
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let err = error {
                completion(nil, err)
            } else {
                if let data = data {
                    completion(data, nil)
                }
            }            
        }
        task.resume()
    }
}
