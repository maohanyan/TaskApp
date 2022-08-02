//
//  UserCell.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 29.07.22.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    
    func setupCell(data: UserProtocol) {
        lblTitle.text = data.title()
        lblSubTitle.text = data.info()
        let urlString = data.mediumPicURL()
        if let url = URL(string: urlString) {
            let resource = ImageResource.init(downloadURL: url, cacheKey: urlString)
            userPhoto.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        lblTitle.text = ""
        lblSubTitle.text = ""
        userPhoto.image = nil
    }
}
