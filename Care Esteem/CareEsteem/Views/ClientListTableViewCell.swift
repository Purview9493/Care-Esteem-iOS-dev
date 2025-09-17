//
//  ClientListTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 09/03/25.
//


import UIKit
import SDWebImage


class ClientListTableViewCell:UITableViewCell{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRiskLevel: UILabel!
    
    @IBOutlet weak var moderateView: UIView!
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var lowView: UIView!
    
    func setupData(model:ClientModel){
        
        
        if let urlStr = model.profilePhoto, !urlStr.isEmpty {
            imgProfile.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "logo1"))
        } else {
            imgProfile.image = initialsImage(from: model.fullName ?? "", size: CGSize(width: 25, height: 25))
        }
        self.lblName.text = model.fullName
        self.lblPhone.text = model.contactNumber
        self.lblAddress.text = model.fullAddress
        self.lblRiskLevel.text = model.riskLevel
        self.moderateView.isHidden = true
        self.highView.isHidden = true
        self.lowView.isHidden = true
        if model.riskLevel?.lowercased() == "low"{
            self.lowView.isHidden = false
        }else if model.riskLevel?.lowercased() == "moderate"{
            self.moderateView.isHidden = false
            self.lowView.isHidden = false
        }else if model.riskLevel?.lowercased() == "high"{
            self.moderateView.isHidden = false
            self.highView.isHidden = false
            self.lowView.isHidden = false
        }
    }
    
    // amit saini
    func initialsImage(from name: String, size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        let parts = name.components(separatedBy: " ").filter { !$0.isEmpty }
        var initials = ""
        
        if let first = parts.first?.first {
            initials.append(first)
        }
        if parts.count > 1, let last = parts.last?.first {
            initials.append(last)
        }
        
        initials = initials.uppercased()
        
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        label.text = initials
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "appGreen")  // Background color
        label.textColor = .white
        
        // ✅ Set Roboto Slab font instead of system font
        if let robotoFont = UIFont(name: "RobotoSlab-Regular", size: size.width / 2) {
            label.font = robotoFont
        } else {
            label.font = UIFont.systemFont(ofSize: size.width / 2, weight: .bold)
            print("Roboto Slab font not found. Make sure it's added to your project and Info.plist.")
        }
        label.layer.cornerRadius = size.width / 2
        label.layer.masksToBounds = true
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            label.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
