//
//  AddEditVisitNotesViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit

class AddEditVisitNotesViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: AGButton!
    @IBOutlet weak var txtVisitNote: AGTextView!
    @IBOutlet weak var btnSubmit: AGButton!
    @IBOutlet weak var btnCancel: AGButton!
    @IBOutlet weak var main_view: AGView!
    
    var updateHandler:(()->Void)?
    var VisitType = ""
    var visitNotes:  VisitNotesModel?
    var visitDetaiID:String?
    var isEdit:Bool = false
    var visitUnscheduledNotes:UnscheduleNotesModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        main_view.layer.cornerRadius = 15
        main_view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        main_view.clipsToBounds = true
        
        if self.isEdit{
            self.txtVisitNote.text = VisitType == "Unscheduled" ? self.visitUnscheduledNotes?.visitNotes :  self.visitNotes?.visitNotes
        }
        
        btnCancel.action = {
            self.dismiss(animated: true)
        }
        self.btnSubmit.action = { [weak self] in
            guard let self = self else { return }
            
            // 🔥 Check if lblTitle is empty
            guard let text = self.txtVisitNote.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                DispatchQueue.main.async {
                    self.showToast(message: "Please enter visit notes")
                }
                return
            }
            
            // 🔥 Proceed if not empty
            if self.isEdit {
                if self.VisitType == "Unscheduled" {
                    self.updateUnscheduledVisiteNotes_APICall()
                } else {
                    self.updateVisiteNotes_APICall()
                }
            } else {
                if self.VisitType == "Unscheduled" {
                    self.addUnscheduledVisiteNotes_APICall()
                } else {
                    self.addVisiteNotes_APICall()
                }
            }
        }
        
        //            self.btnSubmit.action = {
        //                if self.isEdit{
        //                    if self.VisitType == "Unscheduled" {
        //                        self.updateUnscheduledVisiteNotes_APICall()
        //                    } else {
        //                        self.updateVisiteNotes_APICall()
        //                    }
        //
        //                }else{
        //                    if self.VisitType == "Unscheduled" {
        //                        self.addUnscheduledVisiteNotes_APICall()
        //                    } else {
        //                        self.addVisiteNotes_APICall()
        //                    }
        //
        //                }
        //            }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
    // "Updated unscheduled visitnotes details successfully"
    // "Inserted client visitnotes details successfully"
    func showToast(message: String) {
        let toastView = UIView()
        toastView.backgroundColor = UIColor(named: "appYellow")
//        toastView.backgroundColor = .systemYellow
        toastView.layer.cornerRadius = 22
        toastView.clipsToBounds = true
        toastView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90), // Bottom se 100 px
            toastView.widthAnchor.constraint(equalToConstant: 230),
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
        
        let iconImageView = UIImageView(image: UIImage(systemName: "info"))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        toastLabel.numberOfLines = 1
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
//    func showToast1(message: String) {
//        let toastView = UIView()
//        toastView.backgroundColor = .systemYellow
//        toastView.layer.cornerRadius = 22
//        toastView.clipsToBounds = true
//        toastView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(toastView)
//        
//        NSLayoutConstraint.activate([
//            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90), // Bottom se 100 px
//            toastView.widthAnchor.constraint(equalToConstant: 320),
//            toastView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        toastView.addSubview(stackView)
//        
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor)
//        ])
//        
//        let iconImageView = UIImageView(image: UIImage(systemName: "check"))
//        iconImageView.tintColor = .white
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let toastLabel = UILabel()
//        toastLabel.text = message
//        toastLabel.textColor = .white
//        
//        toastLabel.font = UIFont(name: "RobotoSlab-Regular", size: 13)
//        toastLabel.numberOfLines = 2
//        
//        stackView.addArrangedSubview(iconImageView)
//        stackView.addArrangedSubview(toastLabel)
//        
//        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
//            toastView.alpha = 0.0
//        }) { _ in
//            toastView.removeFromSuperview()
//        }
//    }
    
    func showToast1(message: String) {
        let toastView = UIView()
        toastView.backgroundColor = .systemGreen
//        toastView.backgroundColor = UIColor(named: "appGreen")
        toastView.layer.cornerRadius = 22
        toastView.clipsToBounds = true
        toastView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90),
            toastView.widthAnchor.constraint(lessThanOrEqualToConstant: 330) // Width fixed
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        toastView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 13),
            stackView.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -13)
        ])
        
        let iconImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }

    
}



    // MARK: API Call
extension AddEditVisitNotesViewController {
   
        
        private func addVisiteNotes_APICall() {
            CustomLoader.shared.showLoader(on: self.view)
            
            let params: [String: Any] = [
                APIParameters.Visits.visit_details_id: self.visitDetaiID ?? 0,
                APIParameters.Visits.visitNotes: self.txtVisitNote.text ?? "",
                APIParameters.Visits.createdbyUserid: UserDetails.shared.user_id,
                APIParameters.Visits.createdAt: convertDateToString(
                    date: Date(),
                    format: "yyyy-MM-dd HH:mm:ss",
                    timeZone: TimeZone(identifier: "Europe/London")
                )
            ]
            
            WebServiceManager.sharedInstance.callAPI(
                apiPath: .addVisitNotes,
                method: .post,
                params: params,
                isAuthenticate: true,
                model: CommonRespons<[VisitNotesModel]>.self
            ) { response, _ in
                CustomLoader.shared.hideLoader()
                
                switch response {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        if data.statusCode == 200 {
                            let message = data.message ?? "Success"
                            
                            // 🔥 Toast Show Pehle
//                            self.view.makeToast(message)
                            self.showToast1(message: message)
                            
                            // 🔥 2 sec baad dismiss
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.updateHandler?()
                                self.dismiss(animated: true)
                            }
                            
                        } else {
//                            self.view.makeToast(data.message ?? "Something went wrong")
                            self.showToast1(message: data.message ?? "Something went wrong")
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.showToast1(message:error.localizedDescription)
                    }
                }
            }
        }
    

//    private func addVisiteNotes_APICall() {
//        
//        CustomLoader.shared.showLoader(on: self.view)
//        
//        let params = [APIParameters.Visits.visit_details_id: self.visitDetaiID ?? 0,
//                      APIParameters.Visits.visitNotes: self.txtVisitNote.text ?? "",
//                      APIParameters.Visits.createdbyUserid: UserDetails.shared.user_id,
//                      APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//        ] as [String : Any]
//        
//        WebServiceManager.sharedInstance.callAPI(apiPath: .addVisitNotes, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
//            CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        self?.showToast(message: "vvvvvvvvv")
//                        self?.updateHandler?()
//                        self?.dismiss(animated: true)
//                    }else{
//                        self?.view.makeToast(data.message ?? "")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {[weak self] in
//                    self?.view.makeToast(error.localizedDescription)
//                }
//            }
//        }
//    }
    private func updateVisiteNotes_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        
        let params = [APIParameters.Visits.visit_details_id: self.visitDetaiID ?? "0",
                      APIParameters.Visits.visitNotes: self.txtVisitNote.text ?? "",
                      APIParameters.Visits.createdbyUserid: (self.visitNotes?.createdByUserID ?? "").description,
                      APIParameters.Visits.createdAt:self.visitNotes?.createdAt ?? "",
                      APIParameters.Visits.updatedbyUserid: UserDetails.shared.user_id,
                      APIParameters.Visits.updatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                          timeZone: TimeZone(identifier: "Europe/London"))
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .editVisitNotes(visitNotesId: (self.visitNotes?.id ?? "").description), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
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
    
    private func addUnscheduledVisiteNotes_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        
        let params = [APIParameters.UnscheduledVisits.visitDetailsId: self.visitDetaiID ?? 0,
                      APIParameters.UnscheduledVisits.visitNotes: self.txtVisitNote.text ?? "",
                      APIParameters.UnscheduledVisits.visitUserId: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.createdbyUserid: UserDetails.shared.user_id,
                      APIParameters.UnscheduledVisits.visitCreatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                          timeZone: TimeZone(identifier: "Europe/London"))
                      
        ] as [String : Any]
        
        
        WebServiceManager.sharedInstance.callAPI(apiPath: .addUnscheduledVisitNotesDetails, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.showToast1(message: "Inserted client visitnotes details successfully")
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
    //        private func updateUnscheduledVisiteNotes_APICall() {
    //
    //            CustomLoader.shared.showLoader(on: self.view)
    //            let unscheduledVisits = APIParameters.UnscheduledVisits.self
    //
    //            let params = [unscheduledVisits.visitNotes: self.txtVisitNote.text ?? "",
    //                          unscheduledVisits.visitUserId: UserDetails.shared.user_id,
    //                          unscheduledVisits.visitUpdatedAt: convertDateToString(date: Date(),
    //                                                                                format: "yyyy-MM-dd'T'HH:mm:ss",
    //                                                                                timeZone: TimeZone(identifier: "Europe/London")),
    //                          APIParameters.Visits.updatedbyUserid: visitUnscheduledNotes?.id ?? 0,
    //                          APIParameters.Visits.updatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
    //                                                                              timeZone: TimeZone(identifier: "Europe/London"))
    //            ] as [String : Any]
    //
    //            WebServiceManager.sharedInstance.callAPI(apiPath: .updateUnscheduledVisitNotesDetails(visitNotesId: self.visitNotes?.id ?? ""), method: .put, params: params,isAuthenticate: true, model: CommonRespons<[VisitNotesModel]>.self) { response, successMsg in
    //                CustomLoader.shared.hideLoader()
    //                switch response {
    //                case .success(let data):
    //                    DispatchQueue.main.async {[weak self] in
    //                        if data.statusCode == 200{
    //                            self?.updateHandler?()
    //                            self?.dismiss(animated: true)
    //                        }else{
    //                            self?.view.makeToast(data.message ?? "")
    //                        }
    //                    }
    //                case .failure(let error):
    //                    DispatchQueue.main.async {[weak self] in
    //                        self?.view.makeToast(error.localizedDescription)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    private func updateUnscheduledVisiteNotes_APICall() {
        CustomLoader.shared.showLoader(on: self.view)
        let unscheduledVisits = APIParameters.UnscheduledVisits.self
        
        // ✅ Ensure we have noteId
        guard let noteId = visitUnscheduledNotes?.id, !noteId.isEmpty else {
            CustomLoader.shared.hideLoader()
            print("❌ ERROR: Missing Note ID")
            self.view.makeToast("Note ID missing")
            return
        }
        
        let params: [String: Any] = [
            unscheduledVisits.visitNotes: self.txtVisitNote.text ?? "",
            unscheduledVisits.visitUserId: UserDetails.shared.user_id,
            unscheduledVisits.visitUpdatedAt: convertDateToString(
                date: Date(),
                format: "yyyy-MM-dd'T'HH:mm:ss",
                timeZone: TimeZone(identifier: "Europe/London")
            ),
            APIParameters.Visits.updatedbyUserid: UserDetails.shared.user_id,
            APIParameters.Visits.updatedAt: convertDateToString(
                date: Date(),
                format: "yyyy-MM-dd HH:mm:ss",
                timeZone: TimeZone(identifier: "Europe/London")
            )
        ]
        
        print("DEBUG: Updating Unscheduled Note ID => \(noteId)")
        
        WebServiceManager.sharedInstance.callAPI(
            apiPath: .updateUnscheduledVisitNotesDetails(visitNotesId: noteId),
            method: .put,
            params: params,
            isAuthenticate: true,
            model: CommonRespons<[VisitNotesModel]>.self
        ) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200 {
                        self?.showToast1(message: "Updated unscheduled visitnotes details successfully")
//                        var style = ToastStyle()
//                            style.backgroundColor = .yellow
//                            style.messageColor = .black
                            
//                            self?.view.makeToast("✅ Note updated successfully!", duration: 2.0, position: .bottom, style: style)
                        self?.updateHandler?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self?.dismiss(animated: true)
                        }
                    } else {
                        self?.view.makeToast(data.message ?? "Failed to update note")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}
