//
//  UnscheduleViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit
import ImageIO

class UnscheduleViewController: UIViewController {
    
    @IBOutlet weak var addViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_3: UILabel!
    @IBOutlet weak var lblk_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var img_visitgif: UIImageView!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var img_gif: UIImageView!
    @IBOutlet weak var lbl_hide: UILabel!
    @IBOutlet weak var lbl_hide2: UILabel!
    @IBOutlet weak var view_hide: UIView!
    @IBOutlet weak var lbl_fulladdress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCheckout: AGButton!
    @IBOutlet weak var btnMedication: AGButton!
    @IBOutlet weak var btnVisitNotes: AGButton!
    @IBOutlet weak var btnNotes: AGButton!
    @IBOutlet weak var btnNotes1: AGButton!
    @IBOutlet weak var viewVisitNoData: UIView!
    @IBOutlet weak var addNoteView: UIStackView!
    @IBOutlet weak var lblTypeSelected: UILabel!
    @IBOutlet weak var lblNoDataText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusView: AGView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var speratorView: UILabel!
    @IBOutlet weak var addView: UIView!
    
    
    var imageView: UIImageView!
    var isCheckoutDataSet = false
    var visitTimer: Timer?
    var visit:VisitsModel?
    var visitType:VisitType = .none
    var selectedType:VisitDetailType = .medication
    var list:[UnscheduleNotesModel] = []
    var mediList1: [VisitMedicationModel] = []
    var mediList: [VisitMedicationModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 42, width: 10, height: 5))
        imageView.image = UIImage(named: "polygon")
        let scroll = self.view.viewWithTag(1106)
        scroll?.addSubview(imageView)
        updateImageViewFrame(btn: btnMedication)
        btnMedication.layer.cornerRadius = 0
        btnVisitNotes.layer.cornerRadius = 0
        let radius: CGFloat = 12
        btnMedication.layer.cornerRadius = radius
        btnMedication.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnMedication.layer.masksToBounds = true
        btnVisitNotes.layer.cornerRadius = radius
        btnVisitNotes.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnVisitNotes.layer.masksToBounds = true
        loadGif(into: img_visitgif, named: "44 Notes")
        loadGif(into: img_gif, named: "Bottle")
        self.lblk_2.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.lbl_3.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.lbl_1.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.lbl_hide.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        self.lbl_hide2.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        self.lblName.font = UIFont(name: "RobotoSlab-Bold", size: 14)
        self.lblAddress.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.lbl_fulladdress.font = UIFont(name: "RobotoSlab-Regular", size: 13)
        self.lbl_status.font = UIFont(name: "RobotoSlab-Bold", size: 14)
        //        btnMedication.layer.cornerRadius = 12
        //        btnMedication.layer.masksToBounds = true
        //        btnMedication.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addView.isHidden = selectedType == .medication
        
        self.viewVisitNoData.isHidden = true
        self.tableView.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getDataList_APICall()
        }
        
//        self.btnTodo.action = {
//            self.selectedType = .todo
//            self.addView.isHidden = false
//            self.setData()
//        }
        self.btnMedication.action = {
            self.updateImageViewFrame(btn: self.btnMedication)
            self.selectedType = .medication
            self.addView.isHidden = true
            self.viewVisitNoData.isHidden = true
            self.setData()
        }
        //        self.btnVisitNotes.action = {
        //            self.addView.isHidden = false
        //            self.selectedType = .visitnote
        //            self.setData()
        //        }
        //        
        self.btnVisitNotes.action = {
            self.updateImageViewFrame(btn: self.btnVisitNotes)
            self.selectedType = .visitnote
            self.addView.isHidden = true      // by default hide addView
            self.viewVisitNoData.isHidden = false // by default show no-data
            self.view_hide.isHidden = true
            self.setData()
        }
        
        
        self.btnCheckout.action = {
            if self.visitType != .onging{
                var style = ToastStyle()
                style.backgroundColor = .red
                self.view.makeToast("Changes are not allowed", duration: 2.0, position: .bottom, style: style)
                return
            }
            if (self.visit?.actualStartTime?.first ?? "").isEmpty{
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                vc.visit =  self.visit
                vc.isCheckin = true
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }else{
                guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {return}
                guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else { return}
                let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
                // Force 24-hour regardless of device settings
                dateFormatter.locale = Locale(identifier: "en_GB") // en_GB uses 24h
                //                let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                //                dateFormatter.timeZone = .current// TimeZone(identifier: "Europe/London")
                
                if let startDate = dateFormatter.date(from: fullDateTimeStr) {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.minute], from: startDate, to: currentDate)
                    //                    if currentDate < startDate {
                    //                        self.lblTime.text = "Time's up!"
                    //                        return
                    //                    }
                    if let minutes = components.minute,minutes < 2{
                        return
                    }
                }else{
                    return
                }
                
                let params = [:] as [String : Any]
                CustomLoader.shared.showLoader(on: self.view)
                WebServiceManager.sharedInstance.callAPI(apiPath: .gettodoessentialdetails(visitId: (self.visit?.visitDetailsID ?? "").description), method: .get, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                    CustomLoader.shared.hideLoader()
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async {[weak self] in
                            if data.statusCode == 200{
                                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                                vc.visit =  self?.visit
                                vc.isCheckin = false
                                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                AppDelegate.shared.topViewController()?.view.makeToast("Please first complete all essential")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            AppDelegate.shared.topViewController()?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
            }
        }
        self.btnNotes.action = {
            self.addNote()
            
            self.updateVisitTime() // initial update
        }
        self.btnNotes1.action = {
            self.addNote()
        }
        updateVisitTime() // initial update
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.visitType == .onging{
            startVisitTimer()
            
        }
        self.setData()
        self.getVisitDetail_APICall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        visitTimer?.invalidate()
        visitTimer = nil
    }
    
    func updateImageViewFrame(btn: AGButton) {
            imageView.frame =  CGRect(x: (btn.frame.origin.x + btn.frame.width / 2 ), y: 42, width: 10, height: 5)
        }
    
    func addNote(){
        if self.visitType != .onging{
            var style = ToastStyle()
            style.backgroundColor = .red
            self.view.makeToast("Changes are not allowed", duration: 2.0, position: .bottom, style: style)
            return
        }
        let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
        vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
        vc.updateHandler = {
            self.getDataList_APICall()
        }
//        vc.transitioningDelegate = customTransitioningDelegate
        // vc.selectedType = selectedType
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
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
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90), // Bottom se 100 px
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
    
    
    func loadGif(into imageView: UIImageView, named: String) {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: named, ofType: "gif"),
                  let data = NSData(contentsOfFile: path),
                  let source = CGImageSourceCreateWithData(data, nil) else { return }
            
            var images = [UIImage]()
            let count = CGImageSourceGetCount(source)
            
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            
            // 🔥 Speed control
            let frameDuration: Double = 0.03   // Adjust this value (0.03 faster, 0.1 slower)
            let animatedImage = UIImage.animatedImage(with: images, duration: Double(count) * frameDuration)
            
            DispatchQueue.main.async {
                imageView.image = animatedImage
            }
        }
    }

    func setData(){
        
        
        self.lblName.text = self.visit?.clientName
               self.lblAddress.text = self.visit?.clientAddress
               if let clientPostcode = self.visit?.clientPostcode, let clientCity = self.visit?.clientCity{
                   self.lbl_fulladdress.text =  clientCity + ", " + clientPostcode
               }
        
        
//        self.lblName.text = self.visit?.clientName
//        self.lblAddress.text = self.visit?.clientAddress
//        if let clientPostcode = self.visit?.clientPostcode, let clientCity = self.visit?.clientCity {
//            self.lblAddress.text = ( self.visit?.clientAddress ?? "") + "\n" + clientCity + ", " + clientPostcode
//        }
        if visitType != .onging {
                    self.lblTime.text = (self.visit?.totalActualTimeDiff?.first ?? "").isEmpty ? "00:00" : (self.visit?.totalActualTimeDiff?.first ?? "")
                }
        
//        self.setupUnselected(view: btnTodo)
        self.setupUnselected(view: btnMedication)
        self.setupUnselected(view: btnVisitNotes)
        
        if self.visitType == .completed{
            self.statusView.borderColor = UIColor(named: "appGreen") ?? .green
            self.statusView.backgroundColor = UIColor(named: "appGreen")?.withAlphaComponent(0.1) ?? .green
            self.timeView.backgroundColor = UIColor(named: "appGreen")?.withAlphaComponent(0.1) ?? .green
            self.btnCheckout.backgroundColor = UIColor(named: "appGreen")
            self.speratorView.backgroundColor = UIColor(named: "appGreen")
            self.btnCheckout.setTitle("Completed", for: .normal)
            self.addNoteView.isHidden = true
            
        }else if self.visitType == .notcompleted{
            self.statusView.borderColor = UIColor(named: "appRed") ?? .red
            self.statusView.backgroundColor = UIColor(named: "appRed")?.withAlphaComponent(0.1) ?? .red
            self.timeView.backgroundColor = UIColor(named: "appRed")?.withAlphaComponent(0.1) ?? .red
            self.btnCheckout.backgroundColor = UIColor(named: "appRed")
            self.speratorView.backgroundColor = UIColor(named: "appRed")
            self.btnCheckout.setTitle("Not Completed", for: .normal)
        }else if self.visitType == .onging{
            self.statusView.borderColor = UIColor(named: "appBlue") ?? .blue
            self.statusView.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.1) ?? .blue
            self.timeView.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.1) ?? .blue
//            self.btnCheckout.backgroundColor = UIColor(named: "appBlue")
            self.speratorView.backgroundColor = UIColor(named: "appBlue")
            if (self.visit?.actualStartTime?.first ?? "").isEmpty{
                self.btnCheckout.setTitle("Checkin", for: .normal)
            }else{
                self.btnCheckout.setTitle("Checkout", for: .normal)
            }
        }
        
        if selectedType == .todo{
//            self.setupSelected(view: btnTodo)
//            self.lblTypeSelected.text = "List of To-Do Notes"
//            self.lblNoDataText.text = "The To-Do note is currently empty, \n Please provide your To-do documentation."
        }else if selectedType == .medication{
            self.setupSelected(view: btnMedication)
//            self.lblTypeSelected.text = "List of Medication Notes"
//            self.lblNoDataText.text = "The Medication note is currently empty, \nPlease provide your Medication documentation."
        }else if selectedType == .visitnote{
            self.lblTypeSelected.isHidden = false
            self.setupSelected(view: btnVisitNotes)
//            self.lblTypeSelected.text = "List of Visit Notes"
//            self.lblNoDataText.text = "The visit note is currently empty, \nPlease provide your visit documentation."
        }
        // self.lblTypeSelected.isHidden = true
        self.getDataList_APICall()
    }
    func setupSelected(view:AGButton){
        view.backgroundColor = UIColor(named: "appGreen")
        view.setTitleColor(.white, for: .normal)
    }
    func setupUnselected(view:AGButton){
        view.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.10) ?? .blue
        view.setTitleColor(UIColor(named: "appDarkText") ?? .gray, for: .normal)
    }
    
    private func startVisitTimer() {
        visitTimer?.invalidate()
        visitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateVisitTime()
        }
        
        RunLoop.main.add(visitTimer!, forMode: .common)
    }
    
    private func updateVisitTime() {
        guard
            let startTimeStr = self.visit?.actualStartTime?.first,
            let visitDateStr = self.visit?.visitDate,
            !startTimeStr.isEmpty,
            !visitDateStr.isEmpty
        else {
            self.lblTime.text = "00:00"
            self.btnCheckout.isUserInteractionEnabled = false
            self.btnCheckout.alpha = 0.5
            self.btnCheckout.backgroundColor = UIColor.lightGray
            return
        }

        let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Europe/London")
        formatter.locale = Locale(identifier: "en_GB")

        guard let startDate = formatter.date(from: fullDateTimeStr) else {
            self.lblTime.text = "00:00"
            self.btnCheckout.isUserInteractionEnabled = false
            self.btnCheckout.alpha = 0.5
            self.btnCheckout.backgroundColor = UIColor.lightGray
            return
        }

        let interval = Date().timeIntervalSince(startDate)
        let totalSeconds = Int(abs(interval))

        // ✅ Agar 24 hours cross kar gaya
        if totalSeconds >= 86400 { // 24*60*60
            self.lblTime.text = "Time's up!"
            self.btnCheckout.isUserInteractionEnabled = false
            self.btnCheckout.backgroundColor = .gray
            self.btnCheckout.setTitleColor(.black, for: .normal)
            return
        }

        let totalMinutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        // ✅ Show minutes:seconds
        self.lblTime.text = String(format: "%d:%02d", totalMinutes, seconds)

        // ✅ Checkout enable logic
        if totalMinutes >= 2 {
            self.btnCheckout.isUserInteractionEnabled = true
            self.btnCheckout.alpha = 1.0
            self.btnCheckout.backgroundColor = UIColor(named: "appRed")
            self.btnCheckout.setTitleColor(.white, for: .normal)
        } else {
            self.btnCheckout.isUserInteractionEnabled = false
            self.btnCheckout.alpha = 0.5
            self.btnCheckout.backgroundColor = UIColor.lightGray
            self.btnCheckout.setTitleColor(.black, for: .normal)
        }

        // ✅ Timer border styling
        self.timeView.layer.borderColor = UIColor.black.cgColor
        self.timeView.layer.borderWidth = 1
    }
    
//    private func updateVisitTime() {
//        guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {
//            self.lblTime.text = "00:00"
//            return
//        }
//        
//        guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else {
//            self.lblTime.text = "00:00"
//            return
//        }
//        
//        let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
//        // Force 24-hour regardless of device settings
//        dateFormatter.locale = Locale(identifier: "en_GB") // en_GB uses 24h
//        
//        if let startDate = dateFormatter.date(from: fullDateTimeStr) {
//            let currentDate = Date()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: currentDate)
//            //            if currentDate < startDate {
//            //                self.lblTime.text = "Time's up!"
//            //                return
//            //            }
//            let hours = components.hour ?? 0
//            
//            var  minutes = components.minute ?? 0
//            var seconds = components.second ?? 0
//            if minutes < 0 {
//                minutes = minutes * (-1)
//            }
//            if seconds < 0 {
//                seconds = seconds * (-1)
//            }
//            //            if hours > 0 {
//            //                self.lblTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//            //            } else {
//            self.lblTime.text = String(format: "%02d:%02d", minutes, seconds)
//            self.timeView.layer.borderColor = UIColor.black.cgColor
//            self.timeView.layer.borderWidth = 1
//            //            }
//            
//            // Enable checkout after 2 minutes
//            if minutes >= 2 {
//                self.btnCheckout.isUserInteractionEnabled = true
//                self.btnCheckout.alpha = 1.0
//                self.btnCheckout.backgroundColor = UIColor(named: "appRed")
//                self.btnCheckout.setTitleColor(.white, for: .normal)
//            } else {
//                self.btnCheckout.isUserInteractionEnabled = false
////                self.btnCheckout.alpha = 0.5
//                self.btnCheckout.backgroundColor = UIColor.gray
//                self.btnCheckout.setTitleColor(.black, for: .normal)
//                
//              
//
//            }
//        } else {
//            self.lblTime.text = "00:00"
//            self.btnCheckout.isUserInteractionEnabled = false
//            self.btnCheckout.alpha = 0.5
//        }
//    }
    
    //
    //    private func startVisitTimer() {
    //        visitTimer?.invalidate()
    //        visitTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
    //            self?.updateVisitTime()
    //        }
    //        RunLoop.main.add(visitTimer!, forMode: .common)
    //        updateVisitTime() // initial update
    //    }
    //
    //    private func updateVisitTime() {
    //        guard let startTimeStr = self.visit?.actualStartTime?.first, !startTimeStr.isEmpty else {
    //            self.lblTime.text = "00:00"
    //            return
    //        }
    //
    //        guard let visitDateStr = self.visit?.visitDate, !visitDateStr.isEmpty else {
    //            self.lblTime.text = "00:00"
    //            return
    //        }
    //
    //        let fullDateTimeStr = "\(visitDateStr) \(startTimeStr)"
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
    //
    //        if let startDate = dateFormatter.date(from: fullDateTimeStr) {
    //            let currentDate = Date()
    //            let calendar = Calendar.current
    //            let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: currentDate)
    ////            if currentDate < startDate {
    ////                self.lblTime.text = "Time's up!"
    ////                return
    ////            }
    //            let hours = components.hour ?? 0
    //            var  minutes = components.minute ?? 0
    //            var seconds = components.second ?? 0
    //            if minutes < 0 {
    //                minutes = minutes * (-1)
    //            }
    //            if seconds < 0 {
    //                seconds = seconds * (-1)
    //            }
    //            if hours > 0 {
    //                self.lblTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    //            } else {
    //                self.lblTime.text = String(format: "%02d:%02d", minutes, seconds)
    //            }
    //        } else {
    //            self.lblTime.text = "00:00"
    //        }
    //    }
    // MARK: - UI Update
    func updateUI() {
        if selectedType == .medication {
            if mediList.isEmpty {
                // 🔹 agar empty hai to addView hatao
                addView.isHidden = true
                addViewHeightConstraint.constant = 0
            } else {
                // 🔹 agar data hai to addView dikhayo
                addView.isHidden = false
                addViewHeightConstraint.constant = 200   // ya jo bhi original height hai
            }
        } else {
            // Medication mode hi nahi hai to by default hide
            addView.isHidden = true
            addViewHeightConstraint.constant = 0
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

}
    extension UnscheduleViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return selectedType == .medication ? 2 : 1
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if selectedType == .medication {
                if section == 0 {
                    // Normal medication list ke upar spacing chahiye
                    return mediList.isEmpty ? 0.001 : 15
                } else if section == 1 {
                    // PRN medication header sirf tab dikhana hai jab list empty na ho
                    return mediList1.isEmpty ? 0.001 : 40
                }
            }
            return 0.001
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if selectedType == .medication {
                if section == 0 && !mediList.isEmpty {
                    // Sirf ek transparent view return karenge gap dene ke लिए
                    let spacer = UIView()
                    spacer.backgroundColor = .clear
                    return spacer
                } else if section == 1 && !mediList1.isEmpty {
                    // PRN Medication header
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
                    view.backgroundColor = .white
                    let lbl = UILabel(frame: CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width - 16, height: 40))
                    lbl.textColor = .black
                    lbl.font =  UIFont.robotoSlab(.regular, size: 15)
                    lbl.text = "PRN Medication"
                    view.addSubview(lbl)
                    return view
                }
            }
            return nil
        }

        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if selectedType == .medication {
                return section == 1 ? self.mediList1.count : self.mediList.count
            }
            return self.list.count + 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if selectedType == .medication {
                // ✅ Safe guard for out of range
                guard indexPath.section == 1 ? indexPath.row < self.mediList1.count : indexPath.row < self.mediList.count else {
                    print("⚠️ Index out of range: section=\(indexPath.section), row=\(indexPath.row), mediList=\(mediList.count), mediList1=\(mediList1.count)")
                    
                    return UITableViewCell()
                }
                
                let cell = tableView.dequeueReusableCell(withClassIdentifier: StatusUpdateTableCell.self, for: indexPath)
                let model = indexPath.section == 1 ? self.mediList1[indexPath.row] : self.mediList[indexPath.row]
                cell.lbltype.font = UIFont(name: "RobotoSlab-Regular", size: 12)
                cell.lbl_PRN.font = UIFont(name: "RobotoSlab-Regular", size: 12)
                cell.lblName.font = UIFont(name: "RobotoSlab-Regular", size: 12)
                cell.lblStatus.font = UIFont(name: "RobotoSlab-Regular", size: 11)
                cell.lblName.text = model.nhsMedicineName
                cell.lblStatus.text = model.status
                
                if model.status == "Scheduled" {
                    cell.lblStatus.numberOfLines = 2
                    cell.lbltype.text = "\(model.status ?? "")\n\(model.timeFrame ?? "")"
//                    cell.lbltype.font = UIFont(name: "RobotoSlab-Regular", size: 12)
                }
//
                if (model.status ?? "").isEmpty {
                    cell.viewStatus.isHidden = true
                    
                } else if model.status == "Fully Taken" {
                    cell.viewStatus.isHidden = false
                    cell.viewStatus.backgroundColor = UIColor(named: "appGreen") ?? .green
                    cell.constantViewHight.constant = 30
//                    cell.constanttrailing.constant = 90
                    cell.img_Add.isHidden = true
                } else if model.status == "Scheduled" || model.status == "Not Scheduled" {
                    cell.viewStatus.isHidden = true
                    cell.viewStatus.backgroundColor = UIColor(named: "appGray") ?? .gray
                    cell.constantViewHight.constant = 30
//                    cell.constanttrailing.constant = 90
                    cell.img_Add.isHidden = true
                } else {
                    cell.viewStatus.isHidden = false
                    cell.viewStatus.backgroundColor = UIColor(named: "appRed") ?? .red
                    cell.constantViewHight.constant = 37
//                    cell.constanttrailing.constant = 90
                    cell.img_Add.isHidden = true
                    
                }
                cell.img_Add.isHidden = false
                cell.lbltype.text = "\(model.doses ?? 0) Doses per \(model.dosePer ?? 0) \(model.timeFrame ?? "")"
                
                if indexPath.section == 0 {
                    cell.img_Add.isHidden = true
                    cell.constanttrailing.constant = 120
                    cell.lblName.numberOfLines = 2
                    cell.lblName.lineBreakMode = .byWordWrapping
                    cell.constantviewwidth.constant = 150
                    cell.constantviewstatusTrailing.constant = 53
                    cell.lbltype.numberOfLines = 2
                    cell.img_ouipop.isHidden = false

                } else {
                    cell.img_Add.isHidden = false
                    cell.constantviewwidth.constant = 194
                    cell.constanttrailing.constant = 20
                    cell.constantviewstatusTrailing.constant = 43
                    cell.lblName.numberOfLines = 0
                    cell.img_ouipop.isHidden = true

                    
                    if (model.status ?? "").isEmpty {
                        cell.constanttrailing.constant = 20
                        
                    } else {
                        
                        cell.constanttrailing.constant = 20
                    }
                }

//                if model.medicationType == "PRN" {
//                    cell.lbltype.text = "PRN \n\(model.doses ?? 0) Doses per \(model.dosePer ?? 0) \(model.timeFrame ?? "")"
//                }
                
                return cell
            }
            
            // ✅ Safe guard for list indexing
            if indexPath.row < self.list.count {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: UnscheduleVisitNotesTableCell.self, for: indexPath)
                cell.setupData(model: self.list[indexPath.row])
                cell.selectedType = self.selectedType
                cell.clickHandler = {
                    if self.visitType != .onging {
                        var style = ToastStyle()
                        style.backgroundColor = .red

                        self.view.makeToast("Changes are not allowed", duration: 2.0, position: .bottom, style: style)

                        return
                    }
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
                    vc.VisitType = "Unscheduled"
                    vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
                    vc.isEdit = true
                    vc.updateHandler = {
                        self.getDataList_APICall()
                    }
                    vc.visitUnscheduledNotes = self.list[indexPath.row]
//                    vc.transitioningDelegate = customTransitioningDelegate
                    vc.modalPresentationStyle = .pageSheet
                    self.present(vc, animated: true)
                }
                return cell
            }
            return UITableViewCell()
            
    //        // Last row -> Add Notes Cell
    //        let cell = tableView.dequeueReusableCell(withClassIdentifier: AddNotesTableViewCell.self, for: indexPath)
    //        cell.clickHandler = {
    //            self.addNote()
    //        }
    //        return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if self.visitType != .onging {
                var style = ToastStyle()
                style.backgroundColor = .red
                self.view.makeToast("Changes are not allowed", duration: 2.0, position: .bottom, style: style)
                return
            }
            
            if selectedType == .medication {
                // ✅ Safe guard for index
                guard indexPath.section == 1 ? indexPath.row < self.mediList1.count : indexPath.row < self.mediList.count else {
                    print("⚠️ Index out of range in didSelect: section=\(indexPath.section), row=\(indexPath.row)")
                    return
                }
                
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditMedicationViewController.self)
                let model = indexPath.section == 1 ? self.mediList1[indexPath.row] : self.mediList[indexPath.row]
                
                vc.medication = model
                vc.visit = self.visit
                vc.mediFlag = indexPath.section == 1
                vc.updateHandler = {
                    self.getDataList_APICall()
                }
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
                return
            }
            
//            let vc = Storyboard.Visits.instantiateViewController(withViewClass: AddEditVisitNotesViewController.self)
//            vc.VisitType = "Unscheduled"
//            vc.visitDetaiID = (self.visit?.visitDetailsID ?? "").description
//            vc.isEdit = true
//            vc.visitUnscheduledNotes = self.list[indexPath.row]
//            vc.transitioningDelegate = customTransitioningDelegate
//            vc.modalPresentationStyle = .custom
//            self.present(vc, animated: true)
        }
    }


    // MARK: API Call
    extension UnscheduleViewController {
        
//        private func getDataList_APICall() {
//            let id = (self.visit?.visitDetailsID ?? "")
//           // id = 2855
//            var api:APIType = .addAlert
//            if selectedType == .todo{
//                return
//    //            api = .getTodoDetails(todoId: id.description)
//            }else if selectedType == .medication{
//                getDataList_APICall1()
//                return
//                return
//                api = .getMedicationDetailsById(medicationId: id.description)
//            }else if selectedType == .visitnote{
//                api = .getVisitNotes(visitNotesId: id.description)
//            }
//            CustomLoader.shared.showLoader(on: self.view)
//
//            WebServiceManager.sharedInstance.callAPI(apiPath: api, method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[UnscheduleNotesModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            
//                            self?.list = data.data ?? []
//    //                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//    //                        self.addNoteView.isHidden = self.list.isEmpty
//                            self?.tableView.reloadData()
//                        }else{
//                            self?.list = []
//    //                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//    //                        self.addNoteView.isHidden = self.list.isEmpty
//                            self?.tableView.reloadData()
//                            self?.view.makeToast(data.message ?? "")
//                        }
//    //                    if self?.selectedType == .medication{
//    //                        self?.getDataListPRN_APICall()
//    //                    }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
        func getDataList_APICall() {
            let id = (self.visit?.visitDetailsID ?? "")
            var api: APIType = .addAlert
            if selectedType == .todo {
                return
            } else if selectedType == .medication {
                getDataList_APICall1()
                return
            } else if selectedType == .visitnote {
                api = .getVisitNotes(visitNotesId: id.description)
            }

            CustomLoader.shared.showLoader(on: self.view)
            WebServiceManager.sharedInstance.callAPI(apiPath: api,
                                                     method: .get,
                                                     params: [:],
                                                     isAuthenticate: false,
                                                     model: CommonRespons<[UnscheduleNotesModel]>.self) { response, successMsg in
                CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200 {
                            self?.list = data.data ?? []
                        } else {
                            self?.list = []
//                            self?.view.makeToast(data.message ?? "")
                        }

                        // ✅ Toggle here
                        if self?.selectedType == .visitnote {
                            if self?.list.isEmpty ?? true {
                                self?.viewVisitNoData.isHidden = false
                                self?.addView.isHidden = true
                            } else {
                                self?.viewVisitNoData.isHidden = true
                                self?.addView.isHidden = false
                            }
                        }

                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }

//        private func getDataList_APICall1() {
//            let id = (self.visit?.visitDetailsID ?? "")
//           // id = 2855
//            var api:APIType = .addAlert
//            if selectedType == .medication{
//                api = .getMedicationDetailsById(medicationId: id.description)
//            }else if selectedType == .visitnote{
//                api = .getVisitNotes(visitNotesId: id.description)
//            }
//            CustomLoader.shared.showLoader(on: self.view)
//
//            WebServiceManager.sharedInstance.callAPI(apiPath: api, method: .get, params: [:],isAuthenticate: false, model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            
//                            self?.mediList = data.data ?? []
//    //                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//    //                        self.addNoteView.isHidden = self.list.isEmpty
//    //                        self?.tableView.reloadData()
//                        }else{
//                            self?.mediList = []
//    //                        self.viewVisitNoData.isHidden = !self.list.isEmpty
//    //                        self.addNoteView.isHidden = self.list.isEmpty
//    //                        self?.tableView.reloadData()
//                            self?.view.makeToast(data.message ?? "")
//                        }
//                        if self?.selectedType == .medication{
//                            self?.getDataListPRN_APICall()
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
////                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
//
//
        private func getDataList_APICall1() {
            let id = (self.visit?.visitDetailsID ?? "")
            var api: APIType = .addAlert
            
            if selectedType == .medication {
                api = .getMedicationDetailsById(medicationId: id.description)
            } else if selectedType == .visitnote {
                api = .getVisitNotes(visitNotesId: id.description)
            }
            
            CustomLoader.shared.showLoader(on: self.view)
            
            WebServiceManager.sharedInstance.callAPI(
                apiPath: api,
                method: .get,
                params: [:],
                isAuthenticate: false,
                model: CommonRespons<[VisitMedicationModel]>.self
            ) { response, successMsg in
                CustomLoader.shared.hideLoader()
                
                switch response {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        if data.statusCode == 200 {
                            self.mediList = data.data ?? []
                            self.view_hide.isHidden = !self.mediList.isEmpty
                        } else if data.statusCode == 404 {
                            self.mediList = []
                            self.view_hide.isHidden = false
                        } else {
                            self.mediList = []
                            self.view_hide.isHidden = false
                            self.view.makeToast(data.message ?? "Something went wrong")
                        }

                        
                        // 🔥 अगर Medication type है तो PRN भी call करो
                        if self.selectedType == .medication {
                            self.getDataListPRN_APICall()
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.mediList = []
                        self.view_hide.isHidden = false
//                        self.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
        
        
        private func getDataListPRN_APICall() {
            CustomLoader.shared.showLoader(on: self.view)
            let params: [String: String] = [
                "client_id": self.visit?.clientID ?? "",
                "date": self.visit?.visitDate ?? ""
            ]

            WebServiceManager.sharedInstance.callAPI(
                apiPath: .getunscheduledMedicationPrn,
                queryParams: params,
                method: .get,
                params: [:],
                isAuthenticate: false,
                model: CommonRespons<[VisitMedicationModel]>.self
            ) { response, successMsg in
                CustomLoader.shared.hideLoader()

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    switch response {
                    case .success(let data):
                        if data.statusCode == 200 {
                            self.mediList1 = data.data ?? []
                            self.view_hide.isHidden = !self.mediList1.isEmpty
                        } else {
                            self.mediList1 = []
                            self.view_hide.isHidden = false
                            // self.view.makeToast(data.message ?? "")
                        }
                        
                    case .failure(_):
                        self.mediList1 = []
                        self.view_hide.isHidden = false
                        // self.view.makeToast(error.localizedDescription)
                    }

                    self.tableView.reloadData()
                }
            }
        }


//        private func getDataListPRN_APICall() {
//    //        mediList1 = []
//    //        if let data = self.loadMutaionJSONFromFile() {
//    //            self.mediList = data.data ?? [] //(self.list ?? []) + (data.data ?? [])
//    //            self.tableView.reloadData()
//    //            return;
//    //        }
//    //        return;
//
//            CustomLoader.shared.showLoader(on: self.view)
//            let params: [String: String] = ["client_id" : self.visit?.clientID ?? "",
//                                         "date" : (self.visit?.visitDate ?? "")]
//
//            WebServiceManager.sharedInstance.callAPI(apiPath: .getunscheduledMedicationPrn,
//                                                     queryParams: params,
//                                                     method: .get,
//                                                     params: [:],
//                                                     isAuthenticate: false,
//                                                     model: CommonRespons<[VisitMedicationModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            self?.mediList1 = (data.data ?? [])
//
//                            self?.tableView.reloadData()
//                        }else{
//                            self?.mediList1 = []
//                            self?.tableView.reloadData()
////                            self?.view.makeToast(data.message ?? "")
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
////                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
        
        func loadMutaionJSONFromFile() -> CommonRespons<[VisitMedicationModel]>? {
            guard let url = Bundle.main.url(forResource: "mutation", withExtension: "json") else {
                print("JSON file not found")
                return nil
            }

            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let countries = try decoder.decode(CommonRespons<[VisitMedicationModel]>.self, from: data)
                return countries
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        }

//        private func getVisitDetail_APICall() {
//            WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitDetails(visitId: (self.visit?.visitDetailsID ?? "").description,
//                                                                               userId: UserDetails.shared.user_id),
//                                                     method: .get,
//                                                     params: [:],
//                                                     isAuthenticate: true,
//                                                     model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            self?.visit = data.data?.first
//                            self?.setData()
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
        
//        private func getVisitDetail_APICall() {
//            WebServiceManager.sharedInstance.callAPI(
//                apiPath: .getVisitDetails(
//                    visitId: (self.visit?.visitDetailsID ?? "").description,
//                    userId: UserDetails.shared.user_id
//                ),
//                method: .get,
//                params: [:],
//                isAuthenticate: true,
//                model: CommonRespons<[VisitsModel]>.self
//            ) { response, successMsg in
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async { [weak self] in
//                        guard let self = self else { return }
//                        if data.statusCode == 200 {
//                            self.visit = data.data?.first
//                            self.setData()
//                            
//                            // ✅ Show/Hide lbl_hide based on data
//                            if let visitData = data.data, !visitData.isEmpty {
//                                self.view_hide.isHidden = true
//                                
//                            } else {
//                                self.view_hide.isHidden = false
//                            }
//                        } else {
//                            self.view_hide.isHidden = false
////                            self.view.makeToast(data.message ?? "")
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async { [weak self] in
//                        self?.view_hide.isHidden = false
////                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
        private func getVisitDetail_APICall() {
            WebServiceManager.sharedInstance.callAPI(
                apiPath: .getVisitDetails(
                    visitId: (self.visit?.visitDetailsID ?? "").description,
                    userId: UserDetails.shared.user_id
                ),
                method: .get,
                params: [:],
                isAuthenticate: true,
                model: CommonRespons<[VisitsModel]>.self
            ) { response, successMsg in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }

                        if data.statusCode == 200, let visitData = data.data, !visitData.isEmpty {
                            // ✅ Data Found
                            self.visit = visitData.first
                            self.setData()
                            self.view_hide.isHidden = true
                        }
                        else if data.statusCode == 404 {
                            // 🚀 No Data → show empty state
                            self.visit = nil
                            self.view_hide.isHidden = false
                        }
                        else {
                            // ❌ Other error codes
                            self.visit = nil
                            self.view_hide.isHidden = false
                            self.view.makeToast(data.message ?? "Something went wrong")
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.visit = nil
                        self.view_hide.isHidden = false
//                        self.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }

        
    }
