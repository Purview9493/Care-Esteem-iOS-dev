//
//  CreateAlertViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit
import DropDown
enum DropdownType { case client, visit, severity }


class CreateAlertViewController: UIViewController {
    
    @IBOutlet weak var appHeaderView: AppHeaderView!
    @IBOutlet weak var view_Hidden: AGView!
    @IBOutlet weak var lbl_4: UILabel!
    @IBOutlet weak var lbl_3: UILabel!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeverityOfConcern: UILabel!
    @IBOutlet weak var txtConcernDetail: UITextView!
    @IBOutlet weak var btnClientName: AGButton!
    @IBOutlet weak var btnVisitTime: AGButton!
    @IBOutlet weak var btnSeverityOfConcern: AGButton!
    @IBOutlet weak var btnDisable: AGButton!
    @IBOutlet weak var btnEnable: AGButton!
    @IBOutlet weak var btnSave: AGButton!
    @IBOutlet weak var btnCancel: AGButton!
    @IBOutlet weak var clientDropDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var visitDropDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var serverityDropDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: AGTableView!
    @IBOutlet weak var selectedTableView: AGTableView!
    @IBOutlet weak var img_Client: UIImageView!
    @IBOutlet weak var img_VisitDown: UIImageView!
    @IBOutlet weak var img_serverityDown: UIImageView!
    
    var bodyPartList:[BodyPartModel] = []
    var clientList:[ClientNameModel] = []
    var visitList:[VisitsModel] = []
    var selectedClient:ClientNameModel?
    var selectedVisit:VisitsModel?
    var addedBodyPart:[SelectedBodyPart] = []
    var isClientDropdownOpen = false
    var isVisitDropdownOpen = false
    var isSeverityDropdownOpen = false
    var overlayView: UIView?  // Dim background view
    var filteredVisitList: [VisitsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtConcernDetail.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        self.view_Hidden.isHidden = true
        setLabelWithStar(label: lbl_2, text: "Visit")
        setLabelWithStar(label: lbl_1, text: "Clients")
        setLabelWithStar(label: lbl_4, text: "Notes")
        setLabelWithStar(label: lbl_3, text: "Severity of Concern")
        // Default label placeholder
        lblClientName.text = "Select"
        lblClientName.textColor = .lightGray
        lblTime.text = "Select"
        lblTime.textColor = .lightGray
        lblSeverityOfConcern.text = "Select"
        lblSeverityOfConcern.textColor = .lightGray
        
        self.bodyPartList = [
            BodyPartModel(name: "Body", list: [
                PartItem(name: "Body Front", image: "comp_body_front"),
                PartItem(name: "Body Back", image: "comp_body_back")
            ],isExpand:false),
            BodyPartModel(name: "Face", list: [
                PartItem(name: "Face Front", image: "comp_face_front"),
                PartItem(name: "Face Back", image: "comp_face_back"),
            ],isExpand:false),
            BodyPartModel(name: "Hand", list: [
                PartItem(name:  "Right Front", image: "comp_hand_right_front"),
                PartItem(name:  "Right Back", image: "comp_hand_right_back"),
                PartItem(name:  "Left Front", image: "comp_hand_left_front"),
                PartItem(name:  "Left Back", image: "comp_hand_left_back"),
            ],isExpand:false),
            BodyPartModel(name: "Pelvis", list: [
                PartItem(name:  "Pelvis Front", image: "comp_pelvis_front"),
                PartItem(name:  "Pelvis Back", image: "comp_pelvis_back"),
            ],isExpand:false),
            BodyPartModel(name: "Feet", list: [
                PartItem(name: "Right Front", image: "comp_feet_right_front"),
                PartItem(name: "Right Back", image: "comp_feet_right_back"),
                PartItem(name: "Right Heel", image: "comp_feet_right_heel"),
                PartItem(name: "Left Front", image: "comp_feet_left_front"),
                PartItem(name: "Left Back", image: "comp_feet_left_back"),
                PartItem(name: "Left Heel", image: "comp_feet_left_heel"),
            ],isExpand:false)
        ]
        
        self.getAlertDetail_APICall()
        
        self.btnDisable.isSelected = true
        self.btnDisable.setImage(UIImage(systemName: "button.programmable"), for: .selected)
        self.btnEnable.isSelected = false
        self.btnEnable.setImage(UIImage(systemName: "button.programmable"), for: .selected)
        self.selectedTableView.isHidden = true
        self.tableView.isHidden = true
        
        
//        self.btnClientName.action = {
//                    if self.clientList.isEmpty {
//                        self.showToast(message: "No visits are available")
//                        return
//                    }
//                    
//                    self.toggleDropdown(type: .client) {
//                        let dropDown = DropDown()
//                        dropDown.anchorView = self.btnClientName
//                        dropDown.separatorColor = UIColor(named: "appGreen") ?? .green
//                        
//                        
//                        dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
//                           
//                            if index == dropDown.dataSource.count - 1 {
//                                // Hide separator for last row
//                                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//                            } else {
//                                cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//                            }
//                        }
//                        var seen = Set<String>()
//                        let uniqueClientList = self.clientList.filter { client in
//                            if let name = client.clientName, !seen.contains(name) {
//                                seen.insert(name)
//                                return true
//                            }
//                            return false
//                        }
//                        
//                        self.clientList = uniqueClientList
//                        dropDown.dataSource = uniqueClientList.map { $0.clientName ?? "" }
//                        dropDown.direction = .bottom // Show dropdown below the button
//                        
//            
//                        self.img_Client.image = UIImage(named: "upArrow")
//                        self.isClientDropdownOpen = true
//                        
//                       
//                        dropDown.selectionAction = { (index: Int, item: String) in
//                            self.selectedClient = self.clientList[index]
//                            self.lblClientName.text = item
//                            self.lblClientName.textColor = .black // Normal color after selection
//                            self.clientDropDownHeightConstraint.constant = 0
//                            self.isClientDropdownOpen = false
//                            self.img_Client.image = UIImage(named: "downArrow")
//                            
//                            self.selectedVisit = self.visitList.first(where: { v in
//                                v.clientID == self.selectedClient?.clientID
//                            })
////                            self.lblTime.text = self.selectedVisit?.sessionTime ?? ""
//                            self.lblTime.text = "Select"
//                            self.lblTime.textColor = .lightGray
//        //                    self.lblTime.text = self.selectedVisit?.sessionTime ?? ""
//        //                    self.lblTime.text = "\(self.selectedVisit?.plannedStartTime ?? "") - \(self.selectedVisit?.plannedEndTime ?? "")"
//                            
//                        }
//                        
//                        // Dropdown height adjust
//                        self.clientDropDownHeightConstraint.constant =
//                        CGFloat(self.clientList.count < 5 ? self.clientList.count * 50 : 250)
//                        
//                        // Cancel action (jab dropdown dismiss ho)
//                        dropDown.cancelAction = {
//                            self.isClientDropdownOpen = false
//                            self.img_Client.image = UIImage(named: "downArrow")
//                            self.clientDropDownHeightConstraint.constant = 0
//                        }
//                        
//                        dropDown.show()
//                    }
//                }
        
//        self.btnVisitTime.action = { [self] in
//            
//            if (self.lblClientName.text ?? "").isEmpty || self.lblClientName.text == "Select" {
//                self.showToast(message: "Please select a client first")
//                return
//            }
//            
//            guard let client = self.selectedClient else {
//                self.showToast(message: "Please select a client first")
//                return
//            }
//            
//            self.isVisitDropdownOpen = true
//            self.img_VisitDown.image = UIImage(named: "upArrow")
//            
//            self.toggleDropdown(type: .visit) {
//                let filteredVisits = self.visitList.filter { $0.clientID == client.clientID }
//                
//                if filteredVisits.isEmpty {
//                    self.showToast(message: "No visits found for this client")
//                    self.isVisitDropdownOpen = false
//                    self.img_VisitDown.image = UIImage(named: "downArrow")
//                    return
//                }
//                
//                let validVisits = filteredVisits.filter { !($0.sessionTime?.isEmpty ?? true) }
//                if validVisits.isEmpty {
//                    self.showToast(message: "No visit times available.")
//                    self.isVisitDropdownOpen = false
//                    self.img_VisitDown.image = UIImage(named: "downArrow")
//                    return
//                }
//                
//                let displayItems = validVisits.map { visit -> String in
//                    let type = (visit.visitType ?? "").lowercased()
//                    let actualStartRaw = visit.actualStartTime?.first ?? ""
//                    let actualEndRaw = visit.actualEndTime?.first ?? ""
//                    let actualStart = actualStartRaw.isEmpty ? "" : self.formatTime(actualStartRaw)
//                    let actualEnd = actualEndRaw.isEmpty ? "" : formatTime(actualEndRaw)
//
//                    if type == "scheduled" {
//                        // ✅ Always show planned times (ignore actualStartTime/actualEndTime)
//                        let start = (visit.plannedStartTime?.isEmpty == false) ? visit.plannedStartTime! : "??:??"
//                        let end = (visit.plannedEndTime?.isEmpty == false) ? visit.plannedEndTime! : "??:??"
//                        return "\(start) - \(end)"
//                    } else if type == "unscheduled" {
//                        // ✅ Unscheduled → actual times or sessionTime
//                        if !actualStart.isEmpty {
//                            return !actualEnd.isEmpty
//                                ? "\(actualStart) - \(actualEnd) (Unscheduled)"
//                                : "\(actualStart) (Unscheduled)"
//                        } else {
//                            return "\(visit.sessionTime ?? "Unknown Time") (Unscheduled)"
//                        }
//                    } else {
//                        // ✅ Fallback for other types
//                        return visit.sessionTime ?? "Unknown Time"
//                    }
//                }
//
//                
//                
//                let dropDown = DropDown()
//                dropDown.anchorView = self.btnVisitTime
//                dropDown.direction = .bottom
//                dropDown.separatorColor = UIColor(named: "appGreen") ?? .green
//                dropDown.dataSource = displayItems
//                
//                dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
//                    cell.optionLabel.font = UIFont(name: "RobotoSlab-Regular", size: 15)
//                    cell.optionLabel.textColor = .black
//                    cell.optionLabel.textAlignment = .left
//                    cell.separatorInset = (index == dropDown.dataSource.count - 1)
//                        ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//                        : UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//                }
//                
//                dropDown.selectionAction = { index, item in
//                    let selected = validVisits[index]
//                    self.selectedVisit = selected
//                    self.lblTime.text = item
//                    self.lblTime.textColor = .black
//                    self.lblTime.font = UIFont(name: "RobotoSlab-Regular", size: 15)
//                    self.visitDropDownHeightConstraint.constant = 0
//                    self.isVisitDropdownOpen = false
//                    self.img_VisitDown.image = UIImage(named: "downArrow")
//                }
//                
//                dropDown.cancelAction = {
//                    self.isVisitDropdownOpen = false
//                    self.img_VisitDown.image = UIImage(named: "downArrow")
//                    self.visitDropDownHeightConstraint.constant = 0
//                }
//                
//                self.visitDropDownHeightConstraint.constant = CGFloat(displayItems.count < 5 ? displayItems.count * 50 : 250)
//                
//                if self.lblTime.text?.isEmpty ?? true {
//                    self.lblTime.text = "Select"
//                    self.lblTime.textColor = .lightGray
//                }
//                
//                dropDown.show()
//            }
//        }

 
        
        // Severity Dropdown
//        self.btnSeverityOfConcern.action = {
//            self.toggleDropdown(type: .severity) {
//                let dropDown = DropDown()
//                //                dropDown.separatorColor = .green
//                dropDown.separatorColor = UIColor(named: "appGreen") ?? .green
//                dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
//                    // For all rows except last, left inset 5, right inset 0
//                    if index == dropDown.dataSource.count - 1 {
//                        // Hide separator for last row
//                        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//                    } else {
//                        cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//                    }
//                }
//                dropDown.anchorView = self.btnSeverityOfConcern // Attach dropdown to button
//                dropDown.dataSource = ["Low", "Medium", "High"]
//                dropDown.direction = .bottom // Show dropdown below the button
//                
//                // Placeholder if label is empty
//                if self.lblSeverityOfConcern.text?.isEmpty ?? true {
//                    self.lblSeverityOfConcern.text = "Select"
//                    self.lblSeverityOfConcern.textColor = .lightGray
//                }
//                
//                // Selection action
//                dropDown.selectionAction = { (index: Int, item: String) in
//                    self.lblSeverityOfConcern.text = item
//                    self.lblSeverityOfConcern.textColor = .black // Normal color after selection
//                    self.serverityDropDownHeightConstraint.constant = 0
//                    self.isSeverityDropdownOpen = false
//                    self.img_serverityDown.image = UIImage(named: "downArrow")
//                }
//                
//                // Dropdown height adjust
//                self.serverityDropDownHeightConstraint.constant =
//                CGFloat(dropDown.dataSource.count < 5 ? dropDown.dataSource.count * 50 : 250)
//                
//                // Cancel action
//                dropDown.cancelAction = {
//                    self.isSeverityDropdownOpen = false
//                    self.img_serverityDown.image = UIImage(named: "downArrow")
//                    self.serverityDropDownHeightConstraint.constant = 0
//                }
//                
//                dropDown.show()
//            }
//        }
        
        self.btnDisable.action = {
            self.btnDisable.isSelected = true
            self.btnEnable.isSelected = false
            self.selectedTableView.isHidden = true
            self.tableView.isHidden = true
        }
        self.btnEnable.action = {
            self.btnDisable.isSelected = false
            self.btnEnable.isSelected = true
            self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
            self.tableView.isHidden = false
        }
//        self.btnSave.action = {
//            if self.selectedClient == nil {
//                self.view.makeToast("Please select the client")
//            } else if self.selectedVisit == nil {
//                self.view.makeToast("Please select the visit")
//            } else if (self.txtConcernDetail.text ?? "").isEmpty {
//                self.view.makeToast("Please enter the Concern Details")
//            } else {
//                // Show dimmed background
//                self.showPopupWithOverlay()
//            }
//        }
//
        self.btnSave.action = {
            // Client check
            if self.selectedClient == nil || (self.lblClientName.text ?? "").isEmpty || self.lblClientName.text == "Select" {
//                self.view.makeToast("Please select the client")
                var style = ToastStyle()
                style.backgroundColor = .red
                self.view.makeToast("Please select the client", duration: 2.0, position: .bottom, style: style)
                return
            }

            // Visit check
            if self.selectedVisit == nil || (self.lblTime.text ?? "").isEmpty || self.lblTime.text == "Select" {
//                self.view.makeToast("Please select the visit")
                var style = ToastStyle()
                style.backgroundColor = .red
                self.view.makeToast("Please select the visit", duration: 2.0, position: .bottom, style: style)
                
                return
            }

            // Concern detail check
            if (self.txtConcernDetail.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                self.view.makeToast("Please enter the Concern Details")
                var style = ToastStyle()
                style.backgroundColor = .red
                self.view.makeToast("Please enter the Concern Detailst", duration: 2.0, position: .bottom, style: style)
                return
            }

            // ✅ Sab sahi hai
            self.showPopupWithOverlay()
        }

        
        
        self.btnCancel.action = {
            //  self.navigationController?.popViewController(animated: true)
            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
            vc.strImage = "profile_alert"
            vc.strTitle = "Do you want to leave without saving changes?"
            vc.strButton = "Confirm"
            vc.strCancelButton = "Cancel"
            vc.strMessage = "Any unsaved changes will be lost."
            vc.buttonClickHandler = {
                self.navigationController?.popViewController(animated: true)
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.getNotoficationList_APICall()

            // For manual updates
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateNotificationCount),
                name: .updateCount,
                object: nil
            )

            // For foreground resume
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateNotificationCount),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            NotificationCenter.default.removeObserver(self, name: .updateCount, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    
    
    
    @IBAction func tapclientButton(_ sender: Any) {
            if self.clientList.isEmpty {
                self.showToast(message: "No visits are available")
                return
            }
            
            self.toggleDropdown(type: .client) {
                let dropDown = DropDown()
                dropDown.anchorView = self.btnClientName
                dropDown.separatorColor = UIColor(named: "appGreen") ?? .green

                dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
                    cell.optionLabel.text = item
                    cell.optionLabel.textColor = .black
                    cell.optionLabel.textAlignment = .left
                    cell.accessoryView = UIView(frame: .zero)

                    if index == dropDown.dataSource.count - 1 {
                        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                    } else {
                        cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
                    }
                }


                var seen = Set<String>()
                let uniqueClientList = self.clientList.filter { client in
                    if let name = client.clientName, !seen.contains(name) {
                        seen.insert(name)
                        return true
                    }
                    return false
                }

                self.clientList = uniqueClientList
                dropDown.dataSource = uniqueClientList.map { $0.clientName ?? "" }
                dropDown.direction = .bottom

                self.img_Client.image = UIImage(named: "upArrow")
                self.isClientDropdownOpen = true

                dropDown.selectionAction = { (index: Int, item: String) in
                    self.selectedClient = self.clientList[index]
                    self.lblClientName.text = item
                    self.lblClientName.textColor = .black
                    self.clientDropDownHeightConstraint.constant = 0
                    self.isClientDropdownOpen = false
                    self.img_Client.image = UIImage(named: "downArrow")

                    self.selectedVisit = self.visitList.first(where: { v in
                        v.clientID == self.selectedClient?.clientID
                    })
                    self.lblTime.text = "Select"
                    self.lblTime.textColor = .lightGray
                }

                self.clientDropDownHeightConstraint.constant =
                CGFloat(self.clientList.count < 5 ? self.clientList.count * 50 : 250)

                dropDown.cancelAction = {
                    self.isClientDropdownOpen = false
                    self.img_Client.image = UIImage(named: "downArrow")
                    self.clientDropDownHeightConstraint.constant = 0
                }

                dropDown.show()
            }
        }

    
    @IBAction func tapvisitTimeButton(_ sender: Any) {
        if (self.lblClientName.text ?? "").isEmpty || self.lblClientName.text == "Select" {
            self.showToast(message: "Please select a client first")
            return
        }
        
        guard let client = self.selectedClient else {
            self.showToast(message: "Please select a client first")
            return
        }
        
        self.isVisitDropdownOpen = true
        self.img_VisitDown.image = UIImage(named: "upArrow")
        
        self.toggleDropdown(type: .visit) {
            let filteredVisits = self.visitList.filter { $0.clientID == client.clientID }
            
            if filteredVisits.isEmpty {
                self.showToast(message: "No visits found for this client")
                self.isVisitDropdownOpen = false
                self.img_VisitDown.image = UIImage(named: "downArrow")
                return
            }
            
            let validVisits = filteredVisits.filter { !($0.sessionTime?.isEmpty ?? true) }
            if validVisits.isEmpty {
                self.showToast(message: "No visit times available.")
                self.isVisitDropdownOpen = false
                self.img_VisitDown.image = UIImage(named: "downArrow")
                return
            }
            
            let displayItems = validVisits.map { visit -> String in
                let type = (visit.visitType ?? "").lowercased()
                let actualStartRaw = visit.actualStartTime?.first ?? ""
                let actualEndRaw = visit.actualEndTime?.first ?? ""
                let actualStart = actualStartRaw.isEmpty ? "" : self.formatTime(actualStartRaw)
                let actualEnd = actualEndRaw.isEmpty ? "" : formatTime(actualEndRaw)

                if type == "scheduled" {
                    let start = (visit.plannedStartTime?.isEmpty == false) ? visit.plannedStartTime! : "??:??"
                    let end = (visit.plannedEndTime?.isEmpty == false) ? visit.plannedEndTime! : "??:??"
                    return "\(start) - \(end)"
                } else if type == "unscheduled" {
                    if !actualStart.isEmpty {
                        return !actualEnd.isEmpty
                            ? "\(actualStart) - \(actualEnd) (Unscheduled)"
                            : "\(actualStart) (Unscheduled)"
                    } else {
                        return "\(visit.sessionTime ?? "Unknown Time") (Unscheduled)"
                    }
                } else {
                    return visit.sessionTime ?? "Unknown Time"
                }
            }

            let dropDown = DropDown()
            dropDown.anchorView = self.btnVisitTime
            dropDown.direction = .bottom
            dropDown.separatorColor = UIColor(named: "appGreen") ?? .green
            dropDown.dataSource = displayItems
                        
//            dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
//                cell.optionLabel.text = item
//                cell.optionLabel.textColor = .black
//                cell.optionLabel.textAlignment = .left
//                cell.accessoryView = UIView(frame: .zero)
//                if index == dropDown.dataSource.count - 1 {
//                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//                } else {
//                    cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//                }
//            }
            
            dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.text = item
                cell.optionLabel.textColor = .black
                cell.optionLabel.textAlignment = .left

                // ✅ Right side ka text aur image remove
                cell.accessoryView = nil
                cell.accessoryType = .none

                // ✅ Agar DropDown lib ne extra UILabel ya UIImageView add kiya ho to usko hide kar do
                cell.subviews.forEach { subview in
                    if let label = subview as? UILabel, label != cell.optionLabel {
                        label.isHidden = true
                    }
                    if let imageView = subview as? UIImageView {
                        imageView.isHidden = true
                    }
                }

                if index == dropDown.dataSource.count - 1 {
                    cell.separatorInset = UIEdgeInsets(
                        top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude
                    )
                } else {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
                }
            }


            
            dropDown.selectionAction = { index, item in
                let selected = validVisits[index]
                self.selectedVisit = selected
                self.lblTime.text = item
                self.lblTime.textColor = .black
                self.lblTime.font = UIFont(name: "RobotoSlab-Regular", size: 15)
                self.visitDropDownHeightConstraint.constant = 0
                self.isVisitDropdownOpen = false
                self.img_VisitDown.image = UIImage(named: "downArrow")
            }
            
            dropDown.cancelAction = {
                self.isVisitDropdownOpen = false
                self.img_VisitDown.image = UIImage(named: "downArrow")
                self.visitDropDownHeightConstraint.constant = 0
            }
            
            self.visitDropDownHeightConstraint.constant = CGFloat(displayItems.count < 5 ? displayItems.count * 50 : 250)
            
            if self.lblTime.text?.isEmpty ?? true {
                self.lblTime.text = "Select"
                self.lblTime.textColor = .lightGray
            }
            
            dropDown.show()
        }
    }

    
    @IBAction func tapseverityButton(_ sender: Any) {
        self.toggleDropdown(type: .severity) {
            let dropDown = DropDown()
            //                dropDown.separatorColor = .green
            dropDown.separatorColor = UIColor(named: "appGreen") ?? .green
            
            
                dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) -> Void in
                    cell.optionLabel.text = item
                    cell.optionLabel.textColor = .black
                    cell.optionLabel.textAlignment = .left
                    cell.accessoryView = UIView(frame: .zero)
                    if index == dropDown.dataSource.count - 1 {
                        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                    } else {
                        cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
                    }
                }
            dropDown.anchorView = self.btnSeverityOfConcern
            dropDown.dataSource = ["Low", "Medium", "High"]
            dropDown.direction = .bottom
            
            // Placeholder if label is empty
            if self.lblSeverityOfConcern.text?.isEmpty ?? true {
                self.lblSeverityOfConcern.text = "Select"
                self.lblSeverityOfConcern.textColor = .lightGray
            }
            
            // Selection action
            dropDown.selectionAction = { (index: Int, item: String) in
                self.lblSeverityOfConcern.text = item
                self.lblSeverityOfConcern.textColor = .black
                self.serverityDropDownHeightConstraint.constant = 0
                self.isSeverityDropdownOpen = false
                self.img_serverityDown.image = UIImage(named: "downArrow")
            }
            
            // Dropdown height adjust
            self.serverityDropDownHeightConstraint.constant =
            CGFloat(dropDown.dataSource.count < 5 ? dropDown.dataSource.count * 50 : 250)
            
            // Cancel action
            dropDown.cancelAction = {
                self.isSeverityDropdownOpen = false
                self.img_serverityDown.image = UIImage(named: "downArrow")
                self.serverityDropDownHeightConstraint.constant = 0
            }
            
            dropDown.show()
        }
    }
        
    @objc func updateNotificationCount() {
            getNotoficationList_APICall()
        }
    func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"  // Server se aaya format
        if let date = formatter.date(from: timeString) {
            formatter.dateFormat = "HH:mm" // Output format
            return formatter.string(from: date)
        }
        return timeString // Fallback agar parse na ho
    }
    
    // toggleDropdown
    func toggleDropdown(type: DropdownType, openAction: () -> Void) {
        // Close all
        isClientDropdownOpen = false
        isVisitDropdownOpen = false
        isSeverityDropdownOpen = false
        img_Client.image = UIImage(named: "downArrow")
        img_VisitDown.image = UIImage(named: "downArrow")
        img_serverityDown.image = UIImage(named: "downArrow")
        clientDropDownHeightConstraint.constant = 0
        visitDropDownHeightConstraint.constant = 0
        serverityDropDownHeightConstraint.constant = 0
        
        // Open selected
        switch type {
        case .client:
            isClientDropdownOpen = true
            img_Client.image = UIImage(named: "upArrow")
        case .visit:
            isVisitDropdownOpen = true
            img_VisitDown.image = UIImage(named: "upArrow")
        case .severity:
            isSeverityDropdownOpen = true
            img_serverityDown.image = UIImage(named: "upArrow")
        }
        
        openAction()
    }
    
    
        func showToast(message: String) {
            let toastView = UIView()
            toastView.backgroundColor = .systemYellow
            toastView.layer.cornerRadius = 22
            toastView.clipsToBounds = true
            toastView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(toastView)
    
            NSLayoutConstraint.activate([
                toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90),
                toastView.widthAnchor.constraint(equalToConstant: 250),
                toastView.heightAnchor.constraint(equalToConstant: 45)
            ])
    
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            toastView.addSubview(stackView)
    
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor)
            ])
    
            let iconImageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
            let toastLabel = UILabel()
            toastLabel.text = message
            toastLabel.textColor = .white
            toastLabel.font = UIFont(name: "RobotoSlab-Regular", size: 16)
            toastLabel.numberOfLines = 1
    
            stackView.addArrangedSubview(iconImageView)
            stackView.addArrangedSubview(toastLabel)
    
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    // Amit saini
    func setLabelWithStar(label: UILabel, text: String) {
        let fullText = "\(text) *"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let robotoFont = UIFont(name: "RobotoSlab-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        // Normal text color and font
        attributedString.addAttributes([
            .foregroundColor: UIColor.black,
            .font: robotoFont
        ], range: NSRange(location: 0, length: text.count))
        
        attributedString.addAttributes([
            .foregroundColor: UIColor(named: "appGreen") ?? UIColor.systemGreen,
            .font: robotoFont
        ], range: NSRange(location: fullText.count - 1, length: 1))
        
        label.attributedText = attributedString
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
    }
    
    
    @IBAction func tapNoButton(_ sender: Any) {
        hidePopup()
    }
    
    @IBAction func tapYesButton(_ sender: Any) {
        hidePopup()
        self.createAlert_APICall() // Save data
    }
    
    func hidePopup() {
        self.view_Hidden.isHidden = true
        overlayView?.removeFromSuperview()
    }
    
    func showPopupWithOverlay() {
            // Create overlay
            overlayView = UIView(frame: self.view.bounds)
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Dimmed
            overlayView?.tag = 999
            self.view.addSubview(overlayView!)
            
            // Bring popup to front
            self.view_Hidden.isHidden = false
            self.view.bringSubviewToFront(view_Hidden)
        }
}


extension CreateAlertViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        if tableView == self.tableView{
            return self.bodyPartList.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            if self.bodyPartList[section].isExpand ?? false{
                return self.bodyPartList[section].list?.count ?? 0
            }else{
                return 0
            }
        }else{
            return addedBodyPart.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 50
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSectionTableCell.self)
            cell.setupData(model: self.bodyPartList[section])
            
            cell.clickHandler = {
                for i in 0..<self.bodyPartList.count {
                    if i != section {
                        self.bodyPartList[i].isExpand = false
                    }
                }
                self.bodyPartList[section].isExpand = !(self.bodyPartList[section].isExpand ?? false)
                self.tableView.reloadData()
            }
            
            let view: AGView = cell.viewWithTag(1) as! AGView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.bodyPartList[section].isExpand ?? false {
                    view.roundCorners([.topLeft, .topRight], radius: 5)
                } else {
                    view.roundCorners([.allCorners], radius: 5)
                }
            }
            
            self.tableView.layoutSubviews()
            return cell
        } else {
            return nil
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    //        if tableView == self.tableView{
    //            let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSectionTableCell.self)
    //            cell.setupData(model: self.bodyPartList[section])
    //            cell.clickHandler = {
    //                self.bodyPartList[section].isExpand = !(self.bodyPartList[section].isExpand ?? false)
    //                self.tableView.reloadData()
    //            }
    //            let view: AGView = cell.viewWithTag(1) as! AGView
    //            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {
    //                if self.bodyPartList[section].isExpand ?? false {
    //                    view.roundCorners([.topLeft, .topRight], radius: 5)
    //                } else {
    //                    view.roundCorners([.allCorners], radius: 5)
    //                }
    //            })
    //
    //            self.tableView.layoutSubviews()
    //            return cell
    //        }else{
    //            return nil
    //        }
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
            cell.lblName.text = self.bodyPartList[indexPath.section].list?[indexPath.row].name
            if indexPath.row + 1 == self.bodyPartList[indexPath.section].list?.count {
                //                cell.bgView.addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor(named: "appGreen")!, borderWidth: 2, cornerRadius: 5)
            } else {
                //                cell.bgView.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" })
                //                cell.bgView.addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor(named: "appGreen")!, borderWidth: 0, cornerRadius: 0)
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {[weak self] in
                    self?.addBottomBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                })
                cell.bgView.clipsToBounds = true
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1, execute: {[weak self] in
                    self?.addLeftBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                    self?.addRightBorderWithColor(cell.bgView, color: UIColor(named: "appGreen")!, width: 1)
                })
            }
            if indexPath.row != 0 {
                //                cell.bgView.backgroundColor = .white
            }
            self.tableView.layoutSubviews()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: BodyPartSelectedTableCell.self,for: indexPath)
            cell.setupData(model: self.addedBodyPart[indexPath.row])
            cell.clickHandler = {
                self.addedBodyPart.remove(at: indexPath.row)
                self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
                self.selectedTableView.reloadData()
            }
            self.selectedTableView.layoutSubviews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let vc = Storyboard.Alerts.instantiateViewController(withViewClass: EditImageViewController.self)
            
            vc.selectedImage = SelectedBodyPart(
                parent: self.bodyPartList[indexPath.section].name,
                name: self.bodyPartList[indexPath.section].list?[indexPath.row].name,
                image: self.bodyPartList[indexPath.section].list?[indexPath.row].image
            )
            
            vc.updatedHandler = { temp in
                if let t = temp {
                    self.addedBodyPart.append(t)
                    self.selectedTableView.isHidden = self.addedBodyPart.isEmpty
                    self.selectedTableView.reloadData()
                }
            }
            
            // 🔥 Just transparent black background (NO BLUR)
            vc.modalPresentationStyle = .overFullScreen
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 30% dark
            
            self.present(vc, animated: true)
        }
    }
}



// MARK: API Call
extension CreateAlertViewController {
    
    private func getAlertDetail_APICall() {
        
        //  CustomLoader.shared.showLoader(on: self.view)
        let s = convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London"))
        // s = "2025-02-03"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientNameList(userId: UserDetails.shared.user_id),queryParams: [APIParameters.Visits.visitDate: s], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ClientNameModel]>.self) { response, successMsg in
            //     CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.clientList = data.data ?? []
                        self?.selectedClient = self?.clientList.first
                        //                        self?.lblClientName.text = self?.clientList.first?.clientName
                        self?.getVisiteList_APICall()
                    }else{
                        // self.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    private func getVisiteList_APICall() {
        
        //  CustomLoader.shared.showLoader(on: self.view)
        let s = convertDateToString(date:Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London"))
        // s = "2025-02-03"
        WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitList(userId: UserDetails.shared.user_id),queryParams: [APIParameters.Visits.visitDate: s], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
            //  CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.visitList = data.data ?? []
                        self?.selectedVisit = self?.visitList.first(where:{ v in
                            v.clientID == self?.selectedClient?.clientID
                        })
                        //                        self?.lblTime.text = "\(self?.selectedVisit?.plannedStartTime ?? "") - \(self?.selectedVisit?.plannedEndTime ?? "")"
                    }else{
                        // self.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    private func createAlert_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        
        var params = [APIParameters.Alerts.alertMessage: self.txtConcernDetail.text ?? "",
                      APIParameters.Alerts.clientId: self.selectedClient?.clientID ?? 0,
                      APIParameters.Alerts.userId: UserDetails.shared.user_id,
                      APIParameters.Alerts.visitDetailsId: self.selectedVisit?.visitDetailsID ?? "",
                      APIParameters.Alerts.severityOfConcern: self.lblSeverityOfConcern.text ?? "",
                      APIParameters.Alerts.concernDetails: self.txtConcernDetail.text ?? "",
                      APIParameters.Alerts.createdAt: convertDateToString(date: Date(),
                                                                          format: "yyyy-MM-dd HH:mm:ss",
                                                                          timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        if self.btnEnable.isSelected && self.addedBodyPart.count > 0{
            params[APIParameters.Alerts.bodyPartType] = self.addedBodyPart.map{$0.parent ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.bodyPartNames] = self.addedBodyPart.map{$0.name ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.fileName] = self.addedBodyPart.map{$0.fileName ?? ""}.joined(separator: ",")
            params[APIParameters.Alerts.images] = self.addedBodyPart.map{$0.updatedImage ?? UIImage()}
        }else{
            params[APIParameters.Alerts.bodyPartType] = ""
            params[APIParameters.Alerts.bodyPartNames] = ""
            params[APIParameters.Alerts.fileName] = ""
            params[APIParameters.Alerts.images] = []
        }
        
        WebServiceManager.sharedInstance.imageUploadAPIRequest(url: .addAlert, method: .post, formFields: params, model: CommonRespons<[ClientNameModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.navigationController?.popViewController(animated: true)
                        AppDelegate.shared.topViewController()?.view.makeToast(data.message ?? "")
                    }else{
                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    
    func addTopBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "broderName"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "broderName"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: objView.frame.size.height)
        objView.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "broderName"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: objView.frame.size.width - width, y: 0, width: width, height: objView.frame.size.height)
        objView.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        //        objView.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" || $0.name == "borderName" })
        border.name = "broderName"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: objView.frame.size.height - width, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    private func getNotoficationList_APICall() {
        
        // CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getallnotifications(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[NotificationModel]>.self) { response, successMsg in
            //  CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.statusCode == 200{
                        let array = data.data ?? []
                        notificationCount = array.count
                        print("Ayushi :- ",notificationCount)
                        if notificationCount > 0 {
                             self.appHeaderView.showBadge(count: notificationCount)
                        }
                    } else {
                        print("Error Code :-",data.statusCode ?? "")
                    }
                }
                
            case .failure(_):
                print("no code")
            }
        }
    }
}


//extension UIView {
//    func addBottomLeftRightBordersWithRoundedCorners(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
//        // Remove existing custom layers if needed
//        self.layer.sublayers?.removeAll(where: { $0.name == "customBorderLayer" || $0.name == "borderName" })
//
//        // Create path with bottom left & right corners rounded
//        let path = UIBezierPath()
//        let width = self.bounds.width
//        let height = self.bounds.height
//
//        path.move(to: CGPoint(x: 0, y: 0)) // Start at top-left (we won't draw top)
//        path.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
//        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: height),
//                          controlPoint: CGPoint(x: 0, y: height))
//
//        path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
//        path.addQuadCurve(to: CGPoint(x: width, y: height - cornerRadius),
//                          controlPoint: CGPoint(x: width, y: height))
//
//        path.addLine(to: CGPoint(x: width, y: 0)) // Up to top-right (no top border)
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = borderColor.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = borderWidth
//        shapeLayer.name = "customBorderLayer"
//
//        self.layer.addSublayer(shapeLayer)
//    }
//}


extension CreateAlertViewController {
    func isFormFilled() -> Bool {
        let client = lblClientName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let time = lblTime.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let severity = lblSeverityOfConcern.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let detail = txtConcernDetail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isEnableSelected = btnEnable.isSelected
        let blankValues = ["", "Select"]

        let isClientValid = !blankValues.contains(client)
        let isTimeValid = !blankValues.contains(time)
        let isSeverityValid = !blankValues.contains(severity)
        let isDetailValid = !detail.isEmpty

        let filled = isClientValid || isTimeValid || isSeverityValid || isDetailValid || isEnableSelected
        return filled
    }
}
