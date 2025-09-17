//
//  StatusUpdateTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//


import UIKit
class StatusUpdateTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lbltype: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var popupImageWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var constantViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var img_ouipop: UIImageView!
    @IBOutlet weak var constantviewstatusTrailing: NSLayoutConstraint!
    @IBOutlet weak var constantviewhighcomplet: NSLayoutConstraint!
    
    @IBOutlet weak var constantviewwidth: NSLayoutConstraint!
    @IBOutlet weak var constanttrailing: NSLayoutConstraint!
    @IBOutlet weak var img_Add: UIImageView!
    @IBOutlet weak var lbl_PRN: UILabel!

override func prepareForReuse() {
       super.prepareForReuse()
       
       // ✅ Reset to default values
//       constanttrailing.constant = 20
//       constantViewHight.constant = 30
//       viewStatus.isHidden = true
//       img_Add.isHidden = false
   }
}
