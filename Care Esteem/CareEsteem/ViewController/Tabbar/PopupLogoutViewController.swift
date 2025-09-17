//
//  PopupLogoutViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//


import UIKit

class PopupLogoutViewController: UIViewController {

    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnConfirm: AGButton!
    var confirmHandler:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        lbl_1.font = UIFont(name: "RobotoSlab-Regular", size: 19)
            lbl_2.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        btnClose.titleLabel?.font = UIFont(name: "RobotoSlab-Regular", size: 13)
            btnConfirm.titleLabel?.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.btnConfirm.action = {
            self.dismiss(animated: true){
                self.confirmHandler?()
            }
        }
    }
}
