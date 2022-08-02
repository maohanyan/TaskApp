//
//  ResourceManager.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 30.07.22.
//

import Foundation

class ResourceManager {
    static let shared = ResourceManager()
    
    var result: Result!
    var users = [User]()
    var info: Info!
}
