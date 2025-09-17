//
//  PopupCreateUnchecduleViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 13/03/25.
//

import UIKit

class PopupCreateUnchecduleViewController: UIViewController {
    
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnConfirm: AGButton!
    var confirmHandler:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

