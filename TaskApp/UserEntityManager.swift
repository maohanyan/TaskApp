//
//  UserEntityManager.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 01.08.22.
//

import UIKit
import Foundation
import CoreData

class UserEntityManager {
    static let shared = UserEntityManager()
    
    private lazy var managedContext: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        } 
        return appDelegate.persistentContainer.viewContext
    }()
    
    //MARK: -
    func save(user: User) -> Bool {
        guard let contect = managedContext else {
            return false
        }
         //
        let nameEntity = NSEntityDescription.entity(forEntityName: "NameEntity", in: contect)!
        let name = NSManagedObject.init(entity: nameEntity, insertInto: contect)
        name.setValue(user.name.title, forKey: "title")
        name.setValue(user.name.first, forKey: "first")
        name.setValue(user.name.last, forKey: "last")
        
        //
        let IDEntity = NSEntityDescription.entity(forEntityName: "IDEntity", in: contect)!
        let id = NSManagedObject.init(entity: IDEntity, insertInto: contect)
        id.setValue(user.id.value, forKey: "value")
        id.setValue(user.id.name, forKey: "name")
        
        //
        let pictureEntity = NSEntityDescription.entity(forEntityName: "PictureEntity", in: contect)!
        let picture = NSManagedObject.init(entity: pictureEntity, insertInto: contect)
        picture.setValue(user.picture.medium, forKey: "medium")
        picture.setValue(user.picture.large, forKey: "large")
        picture.setValue(user.picture.thumbnail, forKey: "thumbnail")

        //
        let streetEntity = NSEntityDescription.entity(forEntityName: "StreetEntity", in: contect)!
        let street = NSManagedObject.init(entity: streetEntity, insertInto: contect)
        street.setValue(user.location.street.name, forKey: "name")
        street.setValue(user.location.street.number, forKey: "number")
        
        //
        let coordinatesEntity = NSEntityDescription.entity(forEntityName: "CoordinatesEntity", in: contect)!
        let coordinates = NSManagedObject.init(entity: coordinatesEntity, insertInto: contect)
        coordinates.setValue(user.location.coordinates.lat, forKey: "lat")
        coordinates.setValue(user.location.coordinates.lng, forKey: "lng")
        
        //
        let timezoneEntity = NSEntityDescription.entity(forEntityName: "TimezoneEntity", in: contect)!
        let timezone = NSManagedObject.init(entity: timezoneEntity, insertInto: contect)
        timezone.setValue(user.location.timezone.offset, forKey: "offset")
        timezone.setValue(user.location.timezone.description, forKey: "descript")
        
        //
        let locationEntity = NSEntityDescription.entity(forEntityName: "LocationEntity", in: contect)!
        let location = NSManagedObject.init(entity: locationEntity, insertInto: contect)
        location.setValue(street, forKey: "street")
        location.setValue(user.location.city, forKey: "city")
        location.setValue(user.location.state, forKey: "state")
        location.setValue(user.location.country, forKey: "country")
        location.setValue(user.location.postcode, forKey: "postcode")
        location.setValue(coordinates, forKey: "coordinates")
        location.setValue(timezone, forKey: "timezone")
        
        //
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: contect)!
        let savedUser = NSManagedObject.init(entity: entity, insertInto: contect)
        savedUser.setValue(user.gender, forKey: "gender")
        savedUser.setValue(user.email, forKey: "email")
        savedUser.setValue(user.phone, forKey: "phone")
        savedUser.setValue(user.cell, forKey: "cell")
        savedUser.setValue(name, forKey: "name")
        savedUser.setValue(location, forKey: "location")
        savedUser.setValue(picture, forKey: "picture")
        savedUser.setValue(id, forKey: "id")
        
        //
        do {
            try contect.save()
            return true
        } catch {
            return false
        }
    }

    func fetchAll() -> [UserEntity]? {
        getList(searchText: nil)
    }
    
    func search(text: String) -> [UserEntity] {
        getList(searchText: text)
    }
    
    func delete(object: UserProtocol) -> Bool {
        guard let contect = managedContext else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate.init(format: "email == %@", object.identifier())
        do {
            let rst = try contect.fetch(fetchRequest).first as! UserEntity
            contect.delete(rst)
            do {
                try contect.save()
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }
    
    //MARK: - class helpers
    private func getList(searchText: String?) -> [UserEntity] {
        guard let contect = managedContext else {
            return []
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        if let text = searchText  {
            fetchRequest.predicate = NSPredicate.init(format: "email BEGINSWITH %@", text )
        }
        
        do {
            let rst = try contect.fetch(fetchRequest) as! [UserEntity]
            print(rst)
            return rst
        } catch {
            //TODO: error
            return []
        }
    }
    
    
}
