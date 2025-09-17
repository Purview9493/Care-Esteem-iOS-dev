//
//  UnscheduleVisitNotesTableCell.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//


import UIKit
class UnscheduleVisitNotesTableCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var btnClick: AGButton!
    var selectedType:VisitDetailType = .visitnote
    var clickHandler:(()->Void)?
    override func awakeFromNib() {
        
        self.btnClick.action = {
            self.clickHandler?()
        }
    }
    func setupData(model: UnscheduleNotesModel) {
        if selectedType == .visitnote {
            self.lblNotes.text = model.visitNotes
            self.lblName.text = "Updated by: \(model.userLastName ?? "")"
            self.lblName.font = UIFont(name: "RobotoSlab-Regular", size: 13)
            self.lblNotes.font = UIFont(name: "RobotoSlab-Regular", size: 13)
            self.lblTime.font = UIFont(name: "RobotoSlab-Regular", size: 13)
           
            
            if let createdAtDate = convertStringToDate(dateString: model.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss") {
                self.lblTime.text = convertDateToString(date: createdAtDate, format: "dd/MM/yyyy 'at' hh:mm a")
            } else {
                self.lblTime.text = "No date available"
            }
            self.lblTime.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        }
    }


    
    
//    func setupData(model:UnscheduleNotesModel){
//        if selectedType == .todo{
//            self.lblName.text = ""
//            if let updatedAt = convertStringToDate(dateString: model.todoUpdatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Updated by: \(model.userLastName ?? "")"
//               self.lblTime.text = convertDateToString(date: updatedAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }else if let createdAt = convertStringToDate(dateString: model.todoCreatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Created by: \(model.userLastName ?? "")"
//                self.lblTime.text = convertDateToString(date: createdAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }
//            self.lblNotes.text = model.todoNotes
//        }else if selectedType == .medication{
//            self.lblName.text = ""
//            if let updatedAt = convertStringToDate(dateString: model.medicationUpdatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Updated by: \(model.userLastName ?? "")"
//               self.lblTime.text = convertDateToString(date: updatedAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }else if let createdAt = convertStringToDate(dateString: model.medicationCreatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Created by: \(model.userLastName ?? "")"
//                self.lblTime.text = convertDateToString(date: createdAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }
//            self.lblNotes.text = model.medicationNotes
//        }else if selectedType == .visitnote{
//            self.lblName.text = ""
//            if let updatedAt = convertStringToDate(dateString: model.todoUpdatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Updated by: \(model.userLastName ?? "")"
//               self.lblTime.text = convertDateToString(date: updatedAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }else if let createdAt = convertStringToDate(dateString: model.todoCreatedAt ?? "", format: "yyyy-MM-dd HH:mm:ss"){
//                self.lblName.text = "Created by: \(model.userLastName ?? "")"
//                self.lblTime.text = convertDateToString(date: createdAt, format: "dd/MM/yyyy 'at' hh:mm a")
//            }
//            self.lblNotes.text = model.visitNotes
//        }
//    }
}
