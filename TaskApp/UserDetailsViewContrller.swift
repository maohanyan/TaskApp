//
//  UserDetailsViewContrller.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 31.07.22.
//

import UIKit
import CoreData
import MapKit
import Kingfisher

class UserDetailsViewContrller: UIViewController {
 
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblDelete: UILabel!
    
    var user: UserProtocol!
    
    private let activeBtnColor = UIColor.init(red: 18/255, green: 228/255, blue: 124/255, alpha: 1.0)
    private let passiveBtnColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    
    private enum ScreenMode {
        case save
        case delete
    }
    private var screenMode: ScreenMode = .save {
        didSet {
            switch screenMode {
            case .save:
                btnSave.backgroundColor = activeBtnColor
                btnSave.isEnabled = true
                lblDelete.isHidden = true
            case .delete:
                btnSave.backgroundColor = passiveBtnColor
                btnSave.isEnabled = false
                lblDelete.isHidden = false
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func doSave(_ sender: Any) {
        btnSave.isUserInteractionEnabled = false
        if UserEntityManager.shared.save(user: user as! User) {
            btnSave.isUserInteractionEnabled = true
            btnSave.isEnabled = false
            lblDelete.isHidden = false
            lblDelete.isEnabled = true
            btnSave.backgroundColor = passiveBtnColor
            
        } else {
            showAlert(message: StringConstants.failedToSave)
        }
    }
    
    //MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user.title()
        if user is User {
            screenMode = .save
        } else if user is UserEntity {
            screenMode = .delete
        }
    
        setupUIElements()
        setupMap()
    }
    
    
    //MARK: - class helpers
    private func setupMap() {
        let pin = MKPointAnnotation()
        let location = CLLocationCoordinate2D.init(latitude: user.coordinates().0, longitude: user.coordinates().1)
        pin.coordinate = location
        mapView.addAnnotation(pin)
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
         mapView.setRegion(viewRegion, animated: false)
    }
    
    private func setupUIElements() {
        lblName.text = user.title()
        lblInfo.text = user.info()
        
        //
        btnSave.setTitle(StringConstants.saveUser, for: .normal)
        btnSave.setTitleColor(.white, for: .normal)
        btnSave.setTitle(StringConstants.userSaved, for: .disabled)
        btnSave.setTitleColor(.black, for: .disabled)
        
        //
        userPhoto.layer.borderColor = UIColor.white.cgColor
        let urlString = user.largePicURL()
        if let url = URL(string: urlString) {
            let resource = ImageResource.init(downloadURL: url, cacheKey: urlString)
            userPhoto.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        //
        lblDelete.text = StringConstants.removeUser
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.doDelete(_:)))
        tap.numberOfTouchesRequired = 1
        lblDelete.addGestureRecognizer(tap)
        lblDelete.isUserInteractionEnabled = true
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.failedToDelete, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func doDelete(_ sender: UITapGestureRecognizer) {
        lblDelete.isUserInteractionEnabled = false
        if UserEntityManager.shared.delete(object: user) {
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(message: StringConstants.failedToDelete)
            lblDelete.isUserInteractionEnabled = true
        }
    }
}


