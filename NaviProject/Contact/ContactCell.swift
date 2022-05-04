//
//  ContactCell.swift
//  NaviProject
//
//  Created by inforex on 2021/06/25.
//

import Foundation
import UIKit

class ContactCell: UITableViewCell{
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
    }
    
    func initialize(){
        contactImage.layer.cornerRadius = contactImage.frame.height/2  //프로필이미지 둥글게
    }
}
