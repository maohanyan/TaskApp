//
//  UserEntity.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 02.08.22.
//

import Foundation

extension UserEntity: UserProtocol {
    func title() -> String {
        return "\(self.name?.first ?? "") \(self.name?.last ?? "")"
    }
    
    func info() -> String {
        return "\(self.gender?.capitalized ?? ""), \(self.phone ?? "")\n\(self.location?.country ?? "")\n\(self.location?.postcode ?? "") \(self.location?.city ?? "") \(self.location?.street?.name ?? "")"
    }
    
    func identifier() -> String {
        return self.email!
    }
    
    func coordinates() -> (Double, Double) {
        let lat = Double((self.location?.coordinates?.lat)!) ?? 0.0
        let lng = Double((self.location?.coordinates?.lng)!) ?? 0.0
        return (lat, lng)
    }
    
    func mediumPicURL() -> String {
        return self.picture?.medium ?? ""
    }
    
    func largePicURL() -> String {
        return self.picture?.large ?? ""
    }
}
