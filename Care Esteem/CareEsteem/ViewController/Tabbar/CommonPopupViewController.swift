//
//  CommonPopupViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 02/05/25.
//

import UIKit


class CommonPopupViewController: UIViewController {
    
    @IBOutlet weak var btnCancal:AGButton!
    @IBOutlet weak var btnOther:AGButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var logo:AGImageView!
    
    var strTitle:String = ""
    var strMessage:String = ""
    var strButton:String = "Yes"
    var strCancelButton:String = "No"
    var strImage:String = "logo"
    var buttonClickHandler:(()->Void)?
    var otherButtonClickHandler:(()->Void)?
    var hideOtherButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.logo.image = UIImage(named: strImage)
        self.btnOther.isHidden = hideOtherButton
        self.lblTitle.text = self.strTitle
        self.lblSubTitle.text =  self.strMessage
        self.btnOther.setTitle(self.strButton, for: .normal)
        self.btnCancal.setTitle(self.strCancelButton, for: .normal)
        
        self.lblTitle.isHidden = strTitle.isEmpty
        self.lblSubTitle.isHidden = strMessage.isEmpty
        self.lblTitle.font = UIFont.robotoSlab(.bold, size: 15)
        self.lblSubTitle.font = UIFont.robotoSlab(.regular, size: 14)
        self.btnOther.titleLabel?.font = UIFont.robotoSlab(.regular, size: 14)
        self.btnCancal.titleLabel?.font = UIFont.robotoSlab(.regular, size: 14)
        self.btnOther.action = {
            self.dismiss(animated: true) {
                self.buttonClickHandler?()
            }
        }
        self.btnCancal.action = {
            self.dismiss(animated: true){
                self.otherButtonClickHandler?()
            }
        }
    }
}

