//
//  DocumentTableViewCell.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 21/08/25.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_eye: AGButton!
    @IBOutlet weak var Imgup: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var viewconsthide: NSLayoutConstraint!
    
    var isExpanded: Bool = false {
        didSet {
            viewconsthide.constant = isExpanded ? 210 : 50
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                // 👇 Default down, expand pe up
                self.Imgup.transform = self.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
