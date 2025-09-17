//
//  CheckInPopupViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 01/04/25.
//

import UIKit

class CheckInPopupViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnConfirm: AGButton!
    
    var confirmHandler:(()->Void)?
    var isCheckin = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        if isCheckin {
            self.lblTitle.text = "Check In"
            self.lblMessage.text = "Are you sure you want to check in now?"
        } else {
            self.lblTitle.text = "Check Out"
            self.lblMessage.text = "Are you sure you want to check out now?"
        }
        
        self.btnClose.action = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.btnConfirm.action = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.confirmHandler?()
            }
        }
    }
}
