//
//  AddEditMedicationViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 14/03/25.
//

import UIKit
import DropDown

class AddEditMedicationViewController: UIViewController {
    @IBOutlet weak var view_cornerradius: AGView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var btnClose1: AGButton!
    @IBOutlet weak var btnSubmit: AGButton!
    @IBOutlet weak var btnStatus: AGButton!
    @IBOutlet weak var txtView: AGTextView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var prnStack: UIStackView!
    @IBOutlet weak var bpStack: UIStackView!
    @IBOutlet weak var image_Arrow: UIImageView!
    @IBOutlet weak var heigthconstraint: NSLayoutConstraint!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblFrequancy: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var main_view: AGView!
    @IBOutlet weak var stack_AddNotes: UIStackView!
    @IBOutlet weak var lbl_addNotes: UILabel!
    
    
    var updateHandler:(()->Void)?
    var isEdit:Bool = false
    var mediFlag = false
    var medication:VisitMedicationModel?
    var visit:VisitsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        if mediFlag == false {
            self.txtView.text = self.medication?.carerNotes
            self.txtView.font =  UIFont.robotoSlab(.regular, size: 15)
            
        }else{
            self.txtView.text = self.medication?.carerNotes
            self.txtView.font =  UIFont.robotoSlab(.regular, size: 15)
            
        }
        imageStackView.axis = .vertical
            imageStackView.alignment = .fill
            imageStackView.distribution = .equalSpacing
            imageStackView.spacing = 0
            imageStackView.isLayoutMarginsRelativeArrangement = true
            imageStackView.layoutMargins = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        //        heigthconstraint.constant = self.view.frame.height - 450
        //        scrollview.layer.cornerRadius = 15
        //        scrollview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //        scrollview.clipsToBounds = true
        view_cornerradius.layer.cornerRadius = 15
        view_cornerradius.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view_cornerradius.clipsToBounds = true
        if  self.medication?.additionalInstructions == "" {
            self.stack_AddNotes.isHidden = true
        } else {
            self.stack_AddNotes.isHidden = false
            self.lbl_addNotes.text = self.medication?.additionalInstructions
        }
        
        self.lblTitle.text = self.medication?.nhsMedicineName
        print("Type ======:-    ",self.medication?.medicationType)
        if self.medication?.medicationType == "PRN1"{
            self.prnStack.isHidden = true
            self.bpStack.isHidden = false
        }else
        if  self.medication?.medicationType == "PRN"{
            self.prnStack.isHidden = true
            self.bpStack.isHidden = false
            self.lblType.text = self.medication?.medicationType
            self.lblSupport.text = self.medication?.medicationSupport
            self.lblQuantity.text = self.medication?.quantityEachDose?.description
            self.lblRoute.text = self.medication?.medicationRouteName
            let doses = self.medication?.doses ?? 0
            let dosePer = self.medication?.dosePer ?? 0
            let timeFrame = self.medication?.timeFrame ?? ""
            self.lblFrequancy.text = "\(doses) Doses per \(dosePer) \(timeFrame)"
            
        }else {
            self.prnStack.isHidden = true
            self.bpStack.isHidden = false
            self.lblType.text = self.medication?.medicationType
            self.lblSupport.text = self.medication?.medicationSupport
            self.lblQuantity.text = self.medication?.quantityEachDose?.description
            self.lblRoute.text = self.medication?.medicationRouteName
            
            self.lblFrequancy.text = self.medication?.dayName
        }
        
        
        self.lblStatus.text = "Select"
        if let status = self.medication?.status, status.lowercased() != "scheduled" {
            self.lblStatus.text = status == "" ? "Select" : status
        }
        
        self.btnSubmit.action = {
            if self.lblStatus.text == nil || self.lblStatus.text == "" || self.lblStatus.text == "Select" {
                self.view.showToastwithImage(
                    message: "Please select status",
                    image: UIImage(systemName: "info.circle"),
                    textColor: .white,
                    backgroundColor: UIColor(named: "appYellow")
                )
                return
            }
            
            if self.visit?.visitType == "Unscheduled" {
                if self.medication?.medicationType == "PRN"{
                    if self.mediFlag {
                        self.updatePRNMedication_APICall1()
                    } else {
                        self.updatePRNSMedication_APICall()
                    }
                }else if self.medication?.medicationType == "Scheduled"{
                    self.updateScheduleMedication_APICall1()
                }else{
                    self.updateBPMedication_APICall1()
                }
                if self.medication?.medicationType != "PRN"{
                    if self.lblStatus.text != "Fully Taken"{
                        self.AddAlert_APICall1()
                    }
                }
            } else {
                print("Gaurav :-  ",self.medication?.medicationType)
                if self.medication?.medicationType == "PRN"{
                    if self.mediFlag {
                        if self.lblStatus.text != ""{
                            self.updatePRNSMedication_APICall()
                        } else {
                            self.view.showToastwithImage(message: "Please select status", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
                        }
                    } else {
                        if self.lblStatus.text != "Select"{
                            self.updatePRNMedication_APICall()
                        } else {
                            self.view.showToastwithImage(message: "Please select status", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
                        }
                    }
                }else if self.medication?.medicationType == "Scheduled"{
                    self.updateScheduleMedication_APICall()
                }else{
                    self.updateBPMedication_APICall()
                }
                if self.medication?.medicationType != "PRN"{
                    if self.lblStatus.text != "Fully Taken"{
                        self.AddAlert_APICall()
                    }
                }
            }
        }

//        self.btnSubmit.action = {
//            if self.visit?.visitType == "Unscheduled" {
//                //                self.unschedulePRNSMedication_APICall()
//                if self.medication?.medicationType == "PRN"{
//                    if self.mediFlag {
//                        self.updatePRNMedication_APICall1()
//                        
//                    } else {
//                        self.updatePRNSMedication_APICall()
////                        self.updateBPMedication_APICall1()
//                    }
//                }else if self.medication?.medicationType == "Scheduled"{
//                    self.updateScheduleMedication_APICall1()
//                }else{
//                    self.updateBPMedication_APICall1()
//                }
//                if self.medication?.medicationType != "PRN"{
//                    if self.lblStatus.text != "Fully Taken"{
//                        self.AddAlert_APICall1()
//                    }
//                }
//            } else {
//                print("Gaurav :-  ",self.medication?.medicationType)
//                if self.medication?.medicationType == "PRN"{
//                    if self.mediFlag {
//                        if self.lblStatus.text != ""{
//                            self.updatePRNSMedication_APICall()
//                        } else {
//                            self.view.showToastwithImage(message: "Please select status", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
//                        }
//                        
//                    } else {
//                        if self.lblStatus.text != "Select"{
//                            self.updatePRNMedication_APICall()
//                        } else {
//                            self.view.showToastwithImage(message: "Please select status", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
//                        }
//                        
//                    }
//                }else if self.medication?.medicationType == "Scheduled"{
//                    self.updateScheduleMedication_APICall()
//                }else{
//                    self.updateBPMedication_APICall()
//                }
//                if self.medication?.medicationType != "PRN"{
//                    if self.lblStatus.text != "Fully Taken"{
//                        self.AddAlert_APICall()
//                    }
//                }
//            }
//        }
//        
        
        self.btnStatus.action = {
            let dropDown = DropDown()
            dropDown.anchorView = self.btnStatus // Attach dropdown to button
            dropDown.dataSource = ["Fully Taken","Prepared & Left Out","Not Taken","Missing Medication","Destroyed","Self Administered","Not Observed","Refused","Not Given","No Visit","Other","Partially Taken"]
            dropDown.direction = .bottom // Show dropdown below the button
            UserDefaults.standard.set(true, forKey: "sep")
            UserDefaults.standard.synchronize()
            self.image_Arrow.image = UIImage(named: "upArrow")

            dropDown.selectionAction = { (index: Int, item: String) in
                self.lblStatus.text = item
                self.image_Arrow.image = UIImage(named: "downArrow")
            }
            dropDown.cancelAction = {
                self.image_Arrow.image = UIImage(named: "downArrow")
            }
            dropDown.show()
        }

//        self.btnStatus.action = {
//            let dropDown = DropDown()
//            dropDown.anchorView = self.btnStatus // Attach dropdown to button
//            dropDown.dataSource = ["Fully Taken","Prepared & Left Out","Not Taken","Missing Medication","Destroyed","Self Administered","Not Observed","Refused","Not Given","No Visit","Other","Partially Taken"]
//            dropDown.direction = .bottom // Show dropdown below the button
//            UserDefaults.standard.set(true, forKey: "sep")
//            UserDefaults.standard.synchronize()
//            dropDown.selectionAction = { (index: Int, item: String) in
//                self.lblStatus.text = item
//            }
//            dropDown.show()
//        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
        self.btnClose1.action = {
            self.dismiss(animated: true)
        }
        
        if let array =  medication?.body_map_image_url, array.count > 0 {
            for index in 0...(array.count - 1) {
                
                self.createRow(title: medication?.body_part_names?[index], image: array[index])
            }
        }
    }
    func createRow(title: String?, image: String?) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.robotoSlab(.bold, size: 13)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageStackView.addArrangedSubview(titleLabel)

        let imageView = UIImageView()
        imageView.sd_setImage(
            with: URL(string: image ?? ""),
            placeholderImage: UIImage(named: "logo1")
        )
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.appGreen.cgColor
        imageView.clipsToBounds = true

        // ✅ Height set to 210
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true

        // ✅ 20px padding from left and right
        imageView.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)  // Top & Bottom 5px, Left & Right 20px

        // 🔥 Apply background color to imageView
        imageView.backgroundColor = UIColor.viewBGColor // Apply your custom background color

        imageStackView.addArrangedSubview(imageView)

        // 🔥 Add 15px gap below the image (before the next element)
        let gapView = UIView()
        gapView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imageStackView.addArrangedSubview(gapView)
    }






//    func createRow(title: String?, image: String?) {
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        //        titleLabel.textAlignment =
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont.robotoSlab(.regular, size: 13)
//        //RobotoSlabFont(size: 13, weight: .Regular)
//        titleLabel.textColor = .black
//        //        titleLabel.widthAnchor.constraint(equalToConstant: self.visit.frame.width/2.2).isActive = true
//        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
//        
//        imageStackView.addArrangedSubview(titleLabel)
//        
//        let imageView = UIImageView()
//        imageView.sd_setImage(with: URL(string: image ?? ""),
//                              placeholderImage: UIImage(named: "logo1"))
//        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
//        var width: CGFloat = self.view.frame.width - 40
//        let wd = imageStackView.frame.width
//        if wd > 40 {
//            width = wd
//        }
//        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
//        imageView.layer.cornerRadius = 16  // Change 16 → as per design
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.appGreen.cgColor
//        //        titleLabel.textAlignment =
//        //        titleLabel.numberOfLines = 0
//        //        titleLabel.font = UIFont.RobotoSlabFont(size: 13, weight: .Regular)
//        //        titleLabel.textColor = .black
//        imageStackView.addArrangedSubview(imageView)
//    }
}
extension AddEditMedicationViewController{
    private func updatePRNMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.clientId: self.medication?.clientID ?? "",
                      APIParameters.Medication.medicationId: self.medication?.medicationID ?? "",
                      APIParameters.Medication.prnId: self.medication?.prnID ?? "",
                      APIParameters.Medication.dosePer: self.medication?.dosePer ?? "",
                      APIParameters.Medication.doses: self.medication?.doses ?? "",
                      APIParameters.Medication.timeFrame: self.medication?.timeFrame ?? "",
                      APIParameters.Medication.prnOffered: self.medication?.prnOffered ?? "",
                      APIParameters.Medication.prnBeGiven: self.medication?.prnBeGiven ?? "",
                      APIParameters.Medication.visitDetailsId: self.visit?.visitDetailsID ?? "",
                      APIParameters.Medication.userId: UserDetails.shared.user_id,
                      APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                      APIParameters.Medication.medicationTime: "",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(),
                                                                              format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        
        WebServiceManager.sharedInstance.callAPI(apiPath:visit?.visitType == "Unscheduled" ? .unSchedulemedicationPRNDetail : .medicationPRNDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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
    private func updatePRNMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.clientId: self.medication?.clientID ?? "",
                      APIParameters.Medication.medicationId: self.medication?.medicationID ?? "",
                      APIParameters.Medication.prnId: self.medication?.prnID ?? "",
                      APIParameters.Medication.dosePer: self.medication?.dosePer ?? "",
                      APIParameters.Medication.doses: self.medication?.doses ?? "",
                      APIParameters.Medication.timeFrame: self.medication?.timeFrame ?? "",
                      APIParameters.Medication.prnOffered: self.medication?.prnOffered ?? "",
                      APIParameters.Medication.prnBeGiven: self.medication?.prnBeGiven ?? "",
                      APIParameters.Medication.visitDetailsId: self.visit?.visitDetailsID ?? "",
                      APIParameters.Medication.userId: UserDetails.shared.user_id,
                      APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                      APIParameters.Medication.medicationTime: "",
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(),
                                                                              format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .unSchedulemedicationPRNDetail,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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

    private func updateScheduleMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                      "scheduled_outcome": "1"
        ] as [String : Any]
    
        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationScheduledDetails(scheduleId: (self.medication?.scheduledDetailsID ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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
    private func updateScheduleMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                      "scheduled_outcome": "1"
        ] as [String : Any]
    
        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationScheduledDetails(scheduleId: (self.medication?.scheduledDetailsID ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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

    private func updatePRNSMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? ""
        ] as [String : Any]


        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationPrnDetails(cId: (self.medication?.prnDetailsID ?? "").description),
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
                    }else{
                        print("---Error ",data.message ?? "")
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
    private func updatePRNSMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? ""
        ] as [String : Any]


        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationPrnDetails(cId: (self.medication?.prnDetailsID ?? "").description),
                                                 method: .get,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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


    private func unschedulePRNSMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                     APIParameters.Medication.clientId : visit?.clientID ?? "",
                      "data" : visit?.visitDate ?? ""]

        WebServiceManager.sharedInstance.callAPI(apiPath: .unSchedulemedicationPRNDetail,
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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

    
    private func updateBPMedication_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "" ,
                      "blister_pack_outcome": "1"
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationBPDetails(bpId: (self.medication?.blisterPackDetailsID ?? "").description),
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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
    private func updateBPMedication_APICall1() {
        
        CustomLoader.shared.showLoader(on: self.view)

        let params = [APIParameters.Medication.carerNotes: self.txtView.text ?? "",
                      APIParameters.Medication.status: self.lblStatus.text ?? "" == "Select" ? "" : self.lblStatus.text ?? "",
                      "blister_pack_outcome": "1"
        ] as [String : Any]

        WebServiceManager.sharedInstance.callAPI(apiPath: .medicationBPDetails(bpId: (self.medication?.blisterPackDetailsID ?? "").description),
                                                 method: .put,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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

    private func AddAlert_APICall() {
        
        var params = [APIParameters.Medication.clientId: self.visit?.clientID ?? "",
                      APIParameters.Medication.alert_type: "Medication \(self.lblStatus.text ?? "")",
                      APIParameters.Medication.alert_status: "Action Required",
                      APIParameters.Medication.blister_pack_id: self.medication?.medicationType ?? "" == "Blister Pack" ? self.medication?.blisterPackDetailsID ?? "" : "",
                      APIParameters.Medication.scheduleId : self.medication?.medicationType == "Scheduled" ? self.medication?.scheduledDetailsID ?? "" : "",
                      
                      APIParameters.Medication.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        //        if let scheduledID = self.medication?.scheduledDetailsID {
        //            params[APIParameters.Medication.scheduleId] = self.medication?.medicationType == "Blister Pack" ? self.medication?.scheduledDetailsID : ""
        //        }
        //        if let medicationID = self.medication?.blisterPackDetailsID{
        //            params[APIParameters.Medication.blister_pack_id] = self.medication?.medicationType == "Scheduled" ? self.medication?.blisterPackDetailsID : ""
        //        }
        if let visitDetailsID = self.medication?.visitDetailsID?.value {
            params[APIParameters.Medication.visitDetailsId] = visitDetailsID
        }
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .addMedicationAlertDetails,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: true,
                                                 model: CommonRespons<[String:CodableValue]>.self) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.updateHandler?()
                        self?.dismiss(animated: true)
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

        private func AddAlert_APICall1() {
        
            var params = [APIParameters.Medication.clientId: self.visit?.clientID ?? "",
                          APIParameters.Medication.alert_type: "Medication \(self.lblStatus.text ?? "")",
                          APIParameters.Medication.alert_status: "Action Required",
                          APIParameters.Medication.blister_pack_id: self.medication?.medicationType ?? "" == "Blister Pack" ? self.medication?.blisterPackDetailsID ?? "" : "",
                          APIParameters.Medication.scheduleId : self.medication?.medicationType == "Scheduled" ? self.medication?.scheduledDetailsID ?? "" : "",
                          APIParameters.Medication.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                  timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
    //        if let scheduledID = self.medication?.scheduledID {
    //            params[APIParameters.Medication.scheduleId] = scheduledID
    //        }
    //        if let medicationID = self.medication?.medicationID{
    //            params[APIParameters.Medication.blister_pack_id] = medicationID
    //        }
            if let visitDetailsID = self.medication?.visitDetailsID?.value {
                params[APIParameters.Medication.visitDetailsId] = visitDetailsID
            }
            
            WebServiceManager.sharedInstance.callAPI(apiPath: .addMedicationAlertDetails,
                                                     method: .post,
                                                     params: params,
                                                     isAuthenticate: true,
                                                     model: CommonRespons<[String:CodableValue]>.self) { response, successMsg in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
                            self?.updateHandler?()
                            self?.dismiss(animated: true)
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

}
extension UIColor {
    static var appGreen: UIColor {
        return UIColor(named: "appGreen") ?? UIColor.systemGreen
    }

    static var viewBGColor: UIColor {
        return UIColor(named: "viewBGColor") ?? UIColor.systemGray5
    }
}

extension String {
    /// Capital letters ke pehle space add karega
    var spacedWords: String {
        return self.replacingOccurrences(of: "(?<!^)(?=[A-Z])",
                                         with: " ",
                                         options: .regularExpression)
    }

    /// Jo string me space hai usko remove karke camel-case banayega
    var removeSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
