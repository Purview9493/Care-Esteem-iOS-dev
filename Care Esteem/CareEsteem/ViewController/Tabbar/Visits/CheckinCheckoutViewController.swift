//
//  CheckinCheckoutViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

var stepRecordText = ""
//var checkinAPITagg = ""

class CheckinCheckoutViewController: UIViewController {
    
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var btnChecknOut: AGButton!
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var viewCheckInOut: AGView!
    
    @IBOutlet weak var viewGooleMap: AGView!
    @IBOutlet weak var viewQRCode: AGView!
    
    @IBOutlet weak var btnGooleMap: AGButton!
    @IBOutlet weak var btnQRCode: AGButton!
    
    @IBOutlet weak var viewDisplayGooleMap: GMSMapView!
    @IBOutlet weak var viewDisplayQRCode: QRScannerView!
    @IBOutlet weak var lbl_tittle: UILabel!
    
    
    var isCheckin = true
        var isGoogleMap = true
        var isForceSign = false
        var visit:VisitsModel?
        var client:ClientModel?
        var currentLocation:CLLocationCoordinate2D?
        var visitLocation:CLLocationCoordinate2D?
        private var radius:CLLocationDistance = 100
        private var clientId: String = ""
        private var visitDetailId:String = ""
        
        private var dispatchWorkItem: DispatchWorkItem?
        
       // @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
        var visitCheckinTime:Date?
        var visitCheckOutTime:Date?
        var clientProfile_image_url : String?
        
        var isEarly:Bool?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Make the image circular
            self.imageview.layer.masksToBounds = true
            self.imageview.layer.cornerRadius = self.imageview.frame.size.width / 2
              print("Gaurav :- ",isCheckin)
            // Load profile image
            if isCheckin == false {
                self.imageview.isHidden = false
                self.lbl_tittle.isHidden = true
               // visit?.clientName ?? (self.client?.fullName ?? "")
                print("Photo :- ",visit?.clientProfile_image_url)
                if let photo = visit?.clientProfile_image_url, let url = URL(string: photo) {
                    print("image :-", photo)
                    self.imageview.sd_setImage(with: url)
                } else {
                    print("Error :-")
                    self.imageview.isHidden = true
                    self.lbl_tittle.isHidden = false
                    // No photo key: fallback to initials
                    let fullName = visit?.clientName ?? (self.client?.fullName ?? "")
                    let initials = getInitials(from: fullName)
                    self.lbl_tittle.text = initials
                    self.lbl_tittle.font = UIFont.robotoSlab(.regular, size: 20)
                    self.lbl_tittle.textColor = UIColor.white
                    self.lbl_tittle.backgroundColor = UIColor(named: "appGreen")
                    self.lbl_tittle.layer.cornerRadius = 25
                    self.lbl_tittle.clipsToBounds = true
                }
            } else{
                self.lbl_tittle.isHidden = true
                self.imageview.isHidden = false
    //            if let array = visit?.profilePhotoName, array.count > 0, let firstUrlString = array.first, let url = URL(string: firstUrlString ?? "") {
    //                print("array-image :-", array.first)
    //                self.imageview.sd_setImage(with: url)
    //            }
                print("Photo :- ",visit?.clientProfile_image_url)
                if let photo = visit?.clientProfile_image_url, let url = URL(string: photo) {
                    print("image :-", photo)
                    self.imageview.sd_setImage(with: url)
                }
                else {
                    print("Error :-")
                    self.imageview.isHidden = true
                    self.lbl_tittle.isHidden = false
                    // No photo key: fallback to initials
                    let fullName = visit?.clientName ?? (self.client?.fullName ?? "")
                    let initials = getInitials(from: fullName)
                    self.lbl_tittle.text = initials
                    self.lbl_tittle.font = UIFont.robotoSlab(.regular, size: 20)
                    self.lbl_tittle.textColor = UIColor.white
                    self.lbl_tittle.backgroundColor = UIColor(named: "appGreen")
                    self.lbl_tittle.layer.cornerRadius = 25
                    self.lbl_tittle.clipsToBounds = true
                }
            }
            

    //        if let array = visit?.profilePhotoName, array.count > 0 {
    //            let url: URL = URL(string: "https://www.google.com")!
    //            self.imageview.layer.cornerRadius = self.imageview.frame.size.width / 2
    //            self.imageview.clipsToBounds = true
    //            self.imageview.sd_setImage(with: URL(string: (array.first ?? "") ?? ""),
    //                                       placeholderImage: UIImage(named: "logo1"))
    //        } else if let photo = client?.profilePhoto {
    //            self.imageview.sd_setImage(with: URL(string: photo),
    //                                       placeholderImage: UIImage(named: "logo1"))
    //        }
            self.nameLbl.text = visit?.clientName ?? (self.client?.fullName ?? "")
            self.descLbl.text = self.isCheckin ? "Check in" : "Check out"
    //        stepRecordText = stepRecordText + " \(self.visit?.visitDate ?? "") \(self.visit?.plannedStartTime ?? "")"
    //        let alert = UIAlertController(title: "This text share with us", message: "1 \(self.visit?.visitDate ?? "") \(self.visit?.plannedStartTime ?? "")", preferredStyle: .alert)
            
            // Copy action
    //        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
    //            UIPasteboard.general.string = "1 \(self.visit?.visitDate ?? "") \(self.visit?.plannedStartTime ?? "")"
    //            print("Text copied to clipboard")
    //        }
    //
    //        // Cancel action
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    //
    //        alert.addAction(copyAction)
    //        alert.addAction(cancelAction)
    //
    //        present(alert, animated: true)
            self.visitCheckinTime = convertStringToDate(dateString: "\(self.visit?.visitDate ?? "") \(self.visit?.plannedStartTime ?? "")", format: "yyyy-MM-dd HH:mm") ?? Date()
            self.visitCheckOutTime = convertStringToDate(dateString: "\(self.visit?.visitDate ?? "") \(self.visit?.plannedEndTime ?? "")", format: "yyyy-MM-dd HH:mm")  ?? Date()
            self.viewCheckInOut.isHidden = true
            
            if self.isCheckin{
                self.lblType1.text = "Check in"
            }else{
                self.lblType1.text = "Check out"
            }
            self.viewDisplayGooleMap.isMyLocationEnabled = true
            self.viewDisplayGooleMap.settings.myLocationButton = true
            if let visit = self.visit{
                self.visitDetailId = visit.visitDetailsID ?? ""
                self.radius = CLLocationDistance(Double("\(self.visit?.radius?.value ?? 0)")!)
                self.clientId = visit.clientID ?? ""
                self.fetchPlaceDetails(placeID: self.visit?.placeID ?? "")
            }else{
                self.radius = CLLocationDistance(Double("\(self.client?.radius?.value ?? 0)")!)
                self.clientId = self.client?.id ?? ""
                self.fetchPlaceDetails(placeID: self.client?.placeID ?? "")
            }
            
            self.btnChecknOut.action = {
                print("isEarly :- ",self.isEarly)
                print("isCheckIn :- ",self.isCheckin)
                let isInside = self.checkIfUserIsInsideRadius(userLocation: self.visitLocation!, center: self.currentLocation!, radius: self.radius)
                if isInside{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                       // self.forcesign()
                        let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckInPopupViewController.self)
                        vc.isCheckin = self.isCheckin
                        vc.confirmHandler = {
                          //  self.isEarly = true
                         //   self.isCheckin ? "Check in" : "Check out"
                            if self.isCheckin == true {
                                print("CheckIn SuccessFully")
                                self.updateVisitCheckinTime_APICall()
                            } else {
                                print("CheckOut SuccessFully")
                                self.updateVisitCheckOutTime_APICall()
                            }
                          
                        }
                        vc.transitioningDelegate = customTransitioningDelegate
                        vc.modalPresentationStyle = .custom
                        self.present(vc, animated: true)
                        
                    })
                }else{
                    self.view.makeToast("Your current location is not within he client's radius. Please reach out to the client location for further assistance.",
                                        duration: 4)
                }
            }
            let iv: UIImageView = self.view?.viewWithTag(12) as? UIImageView ?? UIImageView()
            let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()
            
            self.btnGooleMap.action = {
                viw.isHidden = false
                iv.isHidden = false
               // self.btnChecknOut.isHidden = false
                self.updateLocation()
                self.lblType1.isHidden = false
                self.isGoogleMap = true
                self.setupData()
                self.dispatchWorkItem?.cancel()
            }
            
            self.btnQRCode.action = {
                self.setupScannerView()
                iv.isHidden = true
                viw.isHidden = true
                self.btnChecknOut.isHidden = true
                self.lblType1.isHidden = true
                self.isGoogleMap = false
                self.setupData()
                self.setupDispatch()
                if let workItem = self.dispatchWorkItem {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0,execute: workItem)
                }
            }
            
           
            self.setupData()
            self.updateLocation()
          //  self.viewDisplayQRCode.turnOffCamera()
          // update location
        }
        func updateLocation () {
            AGLocationManager.oneTime.updateLocation(complitionHandler: { (result) in
                switch result{
                case .success(let t):
                    self.currentLocation = t.coordinate
                    
                    if self.visitLocation != nil {
                        let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()

                        let isInside = self.checkIfUserIsInsideRadius(userLocation: self.visitLocation!, center: self.currentLocation!, radius: self.radius)
                        if isInside{
                            self.btnChecknOut.isHidden = false
                            viw.isHidden = false
                          //  self.bottomConstraint.constant = 90
                        }else{
                            viw.isHidden = true
                           // self.bottomConstraint.constant = 20
                            self.btnChecknOut.isHidden = true
                        }
                    }
                    
                    // Define start and end locations
                    self.viewDisplayGooleMap.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: t.coordinate, zoom: 12)))
                    break
                case .failer( _ ):
                    break
                }
            })
        }
        
        // first letter of first name and first letter of last name function

        func getInitials(from fullName: String) -> String {
            let nameComponents = fullName.components(separatedBy: " ").filter { !$0.isEmpty }

            guard let first = nameComponents.first?.first else { return "" }
            let last = nameComponents.count > 1 ? nameComponents.last?.first : nil

            let initials = "\(first)\(last ?? Character(""))"
            return initials.uppercased()
        }
        func setupDispatch(){
            // Before dispatching any work, cancel any existing work item
            dispatchWorkItem?.cancel()
            dispatchWorkItem = DispatchWorkItem {
                var checkin = self.isCheckin
                if self.client != nil {
                    checkin = true
                }
                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                vc.strImage = "logo_app"
                if checkin{
                    vc.strTitle = "Force Check in"
                    vc.strMessage = "Are you sure want to force check in?"
                }else{
                    vc.strImage = "force_checkin"
                    vc.strTitle = "Force Check out"
                    vc.strMessage = "GPS and QR Code didn't work. \n Do you want to force check out?"
                }
                stepRecordText = stepRecordText + " step 1 -\(checkin)"

                vc.buttonClickHandler = {
                    self.isForceSign = true
                    self.forcesign()
                }
                
                vc.otherButtonClickHandler = {
                    self.navigationController?.popViewController(animated: true)
                }
                
                vc.transitioningDelegate = customTransitioningDelegate
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true)
            }
            
        }
        func fetchPlaceDetails(placeID: String) {
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(placeID) { (place, error) in
                if let error = error {
                    print("❌ Error fetching place details: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    let latitude = place.coordinate.latitude
                    let longitude = place.coordinate.longitude
                    self.visitLocation = place.coordinate
                    if let _ = self.visitLocation , let _ = self.currentLocation {
                        let isInside = self.checkIfUserIsInsideRadius(userLocation: self.visitLocation!, center: self.currentLocation!, radius: self.radius)
                        let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()
                        if isInside{
                            self.btnChecknOut.isHidden = false
                            viw.isHidden = false
                          //  self.bottomConstraint.constant = 90
                        }else{
                            viw.isHidden = true
                            self.btnChecknOut.isHidden = true
                          //  self.bottomConstraint.constant = 20
                        }
                    }
                    let camera = GMSCameraPosition.camera(
                        withLatitude: place.coordinate.latitude,
                        longitude: place.coordinate.longitude,
                        zoom: 17
                    )
                    self.viewDisplayGooleMap.camera = camera
                    // Define center point
                    let circleCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.coordinate.latitude), longitude: CLLocationDegrees(place.coordinate.longitude))
                    // Draw the circle
                    self.drawCircle(at: circleCenter, radius: self.radius) // 1000 meters (1 km)
                    if let currentLocation = self.currentLocation{
                        self.viewCheckInOut.isHidden = false
                        self.fetchRoute(from: currentLocation, to: place.coordinate)
                    }
                    print("✅ Latitude: \(latitude), Longitude: \(longitude)")
                } else {
                    print("❌ Place not found")
                }
            }
        }
         func checkIfUserIsInsideRadius(userLocation: CLLocationCoordinate2D, center: CLLocationCoordinate2D, radius: CLLocationDistance) -> Bool {
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let centerCLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            let distance = userCLLocation.distance(from: centerCLLocation) // Distance in meters
            print("User distance from center: \(distance) meters")
            
            return distance <= radius
        }
         override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if !self.isGoogleMap{
                print("notGoogleMap :- ",self.isGoogleMap)
                viewDisplayQRCode.startScanning()
            } else {
                viewDisplayQRCode.stopScanning()
                print("isGoogleMap :- ",self.isGoogleMap)
                
            }
        }
         override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            viewDisplayQRCode.stopScanning()
        }
        private func setupScannerView() {
            viewDisplayQRCode.onQRCodeScanned = { [weak self] scannedCode in
                debugPrint("scannedCode",scannedCode)
                self?.validateQR_APICall(qrCode: scannedCode)
            }
        }
        func setupData(){
            self.setupUnselected(view: self.viewGooleMap)
            self.setupUnselected(view: self.viewQRCode)
            self.viewDisplayGooleMap.isHidden = true
            self.viewDisplayQRCode.isHidden = true
            
            if self.isGoogleMap{
                self.viewDisplayQRCode.shouldEnableCamera = false
                self.viewDisplayQRCode.stopScanning()
                self.setupSelected(view: self.viewGooleMap)
                self.viewDisplayGooleMap.isHidden = false
                self.viewDisplayQRCode.isHidden = true
            }else{
                self.viewDisplayQRCode.shouldEnableCamera = true
                self.viewDisplayQRCode.startScanning()
                self.setupSelected(view: self.viewQRCode)
                self.viewDisplayGooleMap.isHidden = true
                self.viewDisplayQRCode.isHidden = false
            }
        }
        func setupSelected(view:AGView){
            view.backgroundColor = UIColor(named: "appGreen")
            for t in view.subviews{
                if let ttt = t as? UILabel{
                    ttt.textColor = .white
                }
            }
        }
        func setupUnselected(view:AGView){
            view.backgroundColor = .clear
            for t in view.subviews{
                if let ttt = t as? UILabel{
                    ttt.textColor = UIColor(named: "appGreen") ?? .black
                }
            }
        }
        func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
            
            
            //        let marker = GMSMarker()
            //        marker.position = start
            //        marker.map = self.viewDisplayGooleMap
            //
            let marker1 = GMSMarker()
            marker1.position = end
            marker1.map = self.viewDisplayGooleMap
            
            let origin = "\(start.latitude),\(start.longitude)"
            let destination = "\(end.latitude),\(end.longitude)"
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyARBGwVdA-hbVCGTY8VHLRlvTTa8pfo2Go"
            
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let routes = json["routes"] as? [[String: Any]],
                       let route = routes.first,
                       let overviewPolyline = route["overview_polyline"] as? [String: Any],
                       let points = overviewPolyline["points"] as? String {
                        
                      //  DispatchQueue.main.async {[weak self] in
                          //  self?.drawPath(from: points)
                        //}
                    }
                } catch {
                    print("Error parsing route data: \(error)")
                }
            }.resume()
        }
        func drawPath(from encodedPath: String) {
            let path = GMSPath(fromEncodedPath: encodedPath)
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 4.0
            polyline.map = viewDisplayGooleMap
        }
        func drawCircle(at center: CLLocationCoordinate2D, radius: CLLocationDistance) {
            let circle = GMSCircle(position: center, radius: radius)
            circle.fillColor = (UIColor(named: "appRed") ?? .blue).withAlphaComponent(0.2) // Light transparent blue
            circle.strokeColor = UIColor(red: 1, green: 0.251, blue: 0.506, alpha: 0.266)// Outline color
            circle.strokeWidth = 2.0 // Outline width
            circle.map = viewDisplayGooleMap
        }
        func redirectDetailScreen(){
            if self.isCheckin {
                CustomLoader.shared.showLoader(on: self.view)
                WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitDetails(visitId: self.visitDetailId.description,userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
                    CustomLoader.shared.hideLoader()
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async {[weak self] in
                            if data.statusCode == 200{
                                self?.tabBarController?.selectedIndex = 0
                                self?.navigationController?.popToRootViewController(animated: false)
                                self?.visit = data.data?.first
                                if self?.client != nil{
                                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                                    vc.visit =  data.data?.first
                                    vc.visitType = .onging
                                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                                }else{
                                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                                    vc.visit =  data.data?.first
                                    vc.visitType = .onging
                                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                                }
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
            }else{
                if let viewControllers = self.navigationController?.viewControllers {
                    for controller in viewControllers {
                        if controller is ScheduleViewController || controller is UnscheduleViewController { // Replace with actual ViewController class
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }else if controller is VisitsViewController{ // Replace with actual ViewController class
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
            
        }
        private func validateQR_APICall(qrCode:String) {
            
            CustomLoader.shared.showLoader(on: self.view)
            WebServiceManager.sharedInstance.callAPI(apiPath: .verifyQRCode(clientId: self.clientId.description), method: .post, params: [APIParameters.Clients.qrCode:qrCode],isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
                            self?.dispatchWorkItem?.cancel()
    //                        self?.forcesign()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                self?.forcesign()
                            })
                        }else{
                            self?.view.makeToast(data.message ?? "")
                            self?.viewDisplayQRCode.startScanning()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
        
    //    func forcesign(){
    //        stepRecordText = stepRecordText + " step 2 -"
    //
    //        if self.client == nil{
    //            stepRecordText = stepRecordText + " step 3"
    //
    //            if self.isCheckin{
    //                stepRecordText = stepRecordText + " step 5 -"
    //                print("Visit Difference time :- ", visit?.totalActualTimeDiff ?? "")
    //                print("Visit PlannedStartTime :- ", visit?.plannedStartTime ?? "")
    //                print("Visit PlannedEndTime :- ", visit?.plannedEndTime ?? "")
    //                print("Visit TotalPlannedTime :- ", visit?.totalPlannedTime ?? "")
    //
    //                if self.visit?.visitType == "Scheduled"{
    //                    stepRecordText = stepRecordText + " step 6 - \(self.visitCheckinTime)"
    //
    //                    if let cIn = self.visitCheckinTime {
    //                        stepRecordText = stepRecordText + " step 7 "
    //
    //                        if cIn > Date() {
    //                            stepRecordText = stepRecordText + " step 8 "
    //
    //                            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
    //                            vc.strImage = "early_checkin"
    //                            vc.strTitle = "Early Check In"
    //                            vc.strButton = "Yes"
    //                            vc.strCancelButton = "No"
    //                            vc.strMessage = "You’re checking in earlier than planned time. Do you want to continue?"
    //                            vc.buttonClickHandler = {
    //                                self.isEarly = true
    //                                self.updateVisitCheckinTime_APICall()
    //                            }
    //                            vc.transitioningDelegate = customTransitioningDelegate
    //                            vc.modalPresentationStyle = .custom
    //                            self.present(vc, animated: true)
    //                            stepRecordText = stepRecordText + " step 9"
    //
    //                        } else if cIn < Date() {
    //                            stepRecordText = stepRecordText + " step 10"
    //
    //                            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
    //                            vc.strImage = "logout_3542033 1"
    //                            vc.strTitle = "Late Check In"
    //                            vc.strButton = "Yes"
    //                            vc.strCancelButton = "No"
    //                            vc.strMessage = "You’re checking in later than planned time. Do you want to continue?"
    //                            vc.buttonClickHandler = {
    //                                self.isEarly = false
    //                                self.updateVisitCheckinTime_APICall()
    //                            }
    //                            vc.transitioningDelegate = customTransitioningDelegate
    //                            vc.modalPresentationStyle = .custom
    //                            self.present(vc, animated: true)
    //                        }else{
    //                            stepRecordText = stepRecordText + " step 11"
    //
    //                            self.updateVisitCheckinTime_APICall()
    //                        }
    //                    }
    //                }else{
    //                    self.updateVisitCheckinTime_APICall()
    //                }
    //
    //            }else{
    //                stepRecordText = stepRecordText + " step 4"
    //
    //                if self.visit?.visitType == "Scheduled"{
    //                    stepRecordText = stepRecordText + " step 12"
    //
    //                    if let cOut = self.visitCheckOutTime{
    //                        stepRecordText = stepRecordText + " step 13"
    //
    //                        if cOut > Date(){
    //                            stepRecordText = stepRecordText + " step 14"
    //
    //                            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
    //                            vc.strImage = "early_checkin"
    //                            vc.strTitle = "Early Check Out"
    //                            vc.strButton = "Yes"
    //                            vc.strCancelButton = "No"
    //                            vc.strMessage = "You’re checking out earlier than planned time. Do you want to continue?"
    //                            vc.buttonClickHandler = {
    //                                self.isEarly = true
    //                                self.updateVisitCheckOutTime_APICall()
    //                            }
    //                            vc.transitioningDelegate = customTransitioningDelegate
    //                            vc.modalPresentationStyle = .custom
    //                            self.present(vc, animated: true)
    //                        }else if cOut < Date(){
    //                            stepRecordText = stepRecordText + " step 15"
    //                            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
    //                            vc.strImage = "logout_3542033 1"
    //                            vc.strTitle = "Late Check Out"
    //                            vc.strButton = "Yes"
    //                            vc.strCancelButton = "No"
    //                            vc.strMessage = "You’re checking out later than planned time. Do you want to continue?"
    //                            vc.buttonClickHandler = {
    //                                self.isEarly = false
    //                                self.updateVisitCheckOutTime_APICall()
    //                            }
    //                            vc.transitioningDelegate = customTransitioningDelegate
    //                            vc.modalPresentationStyle = .custom
    //                            self.present(vc, animated: true)
    //                        }else{
    //                            stepRecordText = stepRecordText + " step 16"
    //
    //                            self.updateVisitCheckOutTime_APICall()
    //                        }
    //                    }
    //                }else{
    //                    stepRecordText = stepRecordText + " step 17"
    //
    //                    self.updateVisitCheckOutTime_APICall()
    //                }
    //            }
    //        }else{
    //            stepRecordText = stepRecordText + " step 18 "
    //
    //            self.createUnscheduleVisit_APICall()
    //        }
    //    }
        
        func forcesign() {
            stepRecordText += " step 2 -"

            // If client == nil -> normal scheduled flow, else unscheduled flow
            if self.client == nil {
                stepRecordText += " step 3"

                // ---------- CHECK-IN FLOW ----------
                if self.isCheckin {
                    stepRecordText += " step 5 -"
                    guard let plannedStart = self.visitCheckinTime,
                          let plannedEnd = self.visitCheckOutTime else {
                        stepRecordText += " fallback-no-planned-times-checkin"
                        self.updateVisitCheckinTime_APICall()
                        return
                    }

                    // thresholds = 20 mins (1200 seconds)
                    let bufferSeconds: TimeInterval = 20 * 60
                    let earlyThreshold = plannedStart.addingTimeInterval(-bufferSeconds)
                    let lateThreshold = plannedStart.addingTimeInterval(bufferSeconds)

                    let now = Date()
                    stepRecordText += " plannedStart:\(plannedStart) plannedEnd:\(plannedEnd) buffer:\(Int(bufferSeconds))s"

                    if self.visit?.visitType == "Scheduled" {
                        stepRecordText += " step 6 - \(String(describing: self.visitCheckinTime))"

                        if now < earlyThreshold {
                            // More than 20 min early -> show popup
                            stepRecordText += " step early-checkin"
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                                vc.strImage = "early_checkin"
                                vc.strTitle = "Early Check In"
                                vc.strButton = "Yes"
                                vc.strCancelButton = "No"
                                vc.strMessage = "You’re checking in earlier than planned time. Do you want to continue?"
                                vc.buttonClickHandler = {
                                    self.isEarly = true
                                    self.updateVisitCheckinTime_APICall()
                                }
                                vc.otherButtonClickHandler = {}
                                vc.transitioningDelegate = customTransitioningDelegate
                                vc.modalPresentationStyle = .custom
                                self.present(vc, animated: true)
                            }
                        } else if now > lateThreshold {
                            // More than 20 min late -> show popup
                            stepRecordText += " step late-checkin"
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                                vc.strImage = "logout_3542033 1"
                                vc.strTitle = "Late Check In"
                                vc.strButton = "Yes"
                                vc.strCancelButton = "No"
                                vc.strMessage = "You’re checking in later than planned time. Do you want to continue?"
                                vc.buttonClickHandler = {
                                    self.isEarly = false
                                    self.updateVisitCheckinTime_APICall()
                                }
                                vc.otherButtonClickHandler = {}
                                vc.transitioningDelegate = customTransitioningDelegate
                                vc.modalPresentationStyle = .custom
                                self.present(vc, animated: true)
                            }
                        } else {
                            // Within ±20 mins -> proceed directly
                            stepRecordText += " step on-time-checkin"
                            self.updateVisitCheckinTime_APICall()
                        }
                    } else {
                        stepRecordText += " step not-scheduled-checkin"
                        self.updateVisitCheckinTime_APICall()
                    }
                }

                // ---------- CHECK-OUT FLOW ----------
                else {
                    stepRecordText += " step 4"

                    guard let plannedStart = self.visitCheckinTime,
                          let plannedEnd = self.visitCheckOutTime else {
                        stepRecordText += " fallback-no-planned-times-checkout"
                        self.updateVisitCheckOutTime_APICall()
                        return
                    }

                    // thresholds = 20 mins (1200 seconds)
                    let bufferSeconds: TimeInterval = 20 * 60
                    let earlyThreshold = plannedEnd.addingTimeInterval(-bufferSeconds)
                    let lateThreshold = plannedEnd.addingTimeInterval(bufferSeconds)

                    let now = Date()
                    stepRecordText += " plannedStart:\(plannedStart) plannedEnd:\(plannedEnd) buffer:\(Int(bufferSeconds))s"

                    if self.visit?.visitType == "Scheduled" {
                        stepRecordText += " step 12"

                        if now < earlyThreshold {
                            // More than 20 min early -> show popup
                            stepRecordText += " step early-checkout"
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                                vc.strImage = "early_checkin"
                                vc.strTitle = "Early Check Out"
                                vc.strButton = "Yes"
                                vc.strCancelButton = "No"
                                vc.strMessage = "You’re checking out earlier than planned time. Do you want to continue?"
                                vc.buttonClickHandler = {
                                    self.isEarly = true
                                    self.updateVisitCheckOutTime_APICall()
                                }
                                vc.otherButtonClickHandler = {}
                                vc.transitioningDelegate = customTransitioningDelegate
                                vc.modalPresentationStyle = .custom
                                self.present(vc, animated: true)
                            }
                        } else if now > lateThreshold {
                            // More than 20 min late -> show popup
                            stepRecordText += " step late-checkout"
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                                vc.strImage = "logout_3542033 1"
                                vc.strTitle = "Late Check Out"
                                vc.strButton = "Yes"
                                vc.strCancelButton = "No"
                                vc.strMessage = "You’re checking out later than planned time. Do you want to continue?"
                                vc.buttonClickHandler = {
                                    self.isEarly = false
                                    self.updateVisitCheckOutTime_APICall()
                                }
                                vc.otherButtonClickHandler = {}
                                vc.transitioningDelegate = customTransitioningDelegate
                                vc.modalPresentationStyle = .custom
                                self.present(vc, animated: true)
                            }
                        } else {
                            // Within ±20 mins -> proceed directly
                            stepRecordText += " step on-time-checkout"
                            self.updateVisitCheckOutTime_APICall()
                        }
                    } else {
                        stepRecordText += " step not-scheduled-checkout"
                        self.updateVisitCheckOutTime_APICall()
                    }
                }
            }
            // ---------- UNSCHEDULED ----------
            else {
                stepRecordText += " step 18 "
                self.createUnscheduleVisit_APICall()
            }
        }


        
        private func updateVisitCheckinTime_APICall() {
            
            CustomLoader.shared.showLoader(on: self.view)
            guard let hashToken = UserDetails.shared.loginModel?.hashToken else {
               return
            }
            print("HashToken :- ",hashToken)
           // checkinAPITagg = "checkin"
          //  print("checkinAPITagg :- ",checkinAPITagg)
            let params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
                         // APIParameters.hashToken:hashToken,
                          APIParameters.Visits.status: "checkin",
                          APIParameters.Visits.userId: UserDetails.shared.user_id,
                          APIParameters.Visits.clientId: self.clientId,
                          APIParameters.Visits.actualStartTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                    timeZone: TimeZone(identifier: "Europe/London")),
                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
            
            WebServiceManager.sharedInstance.callAPI(apiPath: .updateVisitCheckinTime,
                                                     method: .post,
                                                     params: params,
                                                     isAuthenticate: true,
                                                     model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
                CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
    //                DispatchQueue.main.async {
                        if data.statusCode == 200{
                          
                            if self.isForceSign{
                                var uatId = ""
                                if let id = data.data?.first?.id {
                                    uatId = id
                                }
                                self.createForceCheckin_APICall(uatId: uatId,
                                                                isCheckin: true)
                                if let e = self.isEarly{
                                    self.createEarlyLateCheckin_APICall(uatId: uatId,
                                                                        isCheckin: true,
                                                                        isEarly:e)
                                }
                            }else{
                                self.redirectDetailScreen()
                                if let e = self.isEarly{
                                    var uatId = ""
                                    if let id = data.data?.first?.id {
                                        uatId = id
                                    }
                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: true,isEarly:e)
                                }
                            }
                        }else{
                            self.view.makeToast(data.message ?? "")
                        }
    //                }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
        
        private func updateVisitCheckOutTime_APICall() {
            
            let params = [APIParameters.Visits.actualEndTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                                  timeZone: TimeZone(identifier: "Europe/London")),
                          APIParameters.Visits.status: "checkout",
                          APIParameters.Visits.updatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
                                                                              timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
            
            CustomLoader.shared.showLoader(on: self.view)
            WebServiceManager.sharedInstance.callAPI(apiPath: .updateVisitCheckoutTime(userId:UserDetails.shared.user_id,
                                                                                       visitId: self.visitDetailId.description),
                                                     method: .put, params: params,
                                                     isAuthenticate: true,
                                                     model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
                CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                        if data.statusCode == 200{
                            var uatId = ""
                            if let id = data.data?.first?.id {
                                uatId = id
                            }
                            self.view.showToastwithImage(message: data.message ?? "", image: UIImage(named: "tick_toast"), textColor: .white, backgroundColor: .systemGreen)
                            if self.isForceSign{
                                self.createForceCheckin_APICall(uatId: data.data?.first?.id, isCheckin: false)
                                if let e = self.isEarly{
                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: false,isEarly:e)
                                }
                            }else{
                                self.redirectDetailScreen()
                                if let e = self.isEarly{
                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: false,isEarly:e)
                                }
                            }
                        }else{
                            self.view.makeToast(data.message ?? "")
                        }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
        
        private func createUnscheduleVisit_APICall() {
            CustomLoader.shared.showLoader(on: self.view)
            let params = [APIParameters.UnscheduledVisits.clientId: self.clientId,
                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
                          APIParameters.UnscheduledVisits.visitDate: convertDateToString(date: Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London")),
                          APIParameters.UnscheduledVisits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London")),
                          APIParameters.UnscheduledVisits.actualStartTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
            
            
            WebServiceManager.sharedInstance.callAPI(apiPath: .createUnscheduledVisit, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
                CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
                            self?.visitDetailId = data.userActualTimeData?.first?.visitDetailsID ?? ""
                            self?.redirectDetailScreen()
                          //  self?.updateVisitCheckinTime_APICall()
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
         private func createForceCheckin_APICall(uatId:String?,isCheckin:Bool) {
            
            var params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
                          APIParameters.Visits.clientId: self.clientId,
                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
                          APIParameters.Visits.alert_type: isCheckin ? "Force Check In" : "Force Check Out",
                          APIParameters.Visits.alert_status: "Action Required",
                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
            if let uatId = uatId{
                params[APIParameters.Visits.uat_id] = uatId
            }
            WebServiceManager.sharedInstance.callAPI(apiPath: .addAlertCheckInOut, method: .post, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200 {
                            self?.redirectDetailScreen()
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
         private func createEarlyLateCheckin_APICall(uatId:String?,isCheckin:Bool,isEarly:Bool) {
            print("IsCheckIn :- ",isCheckin)
            var params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
                          APIParameters.Visits.clientId: self.clientId,
                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
                          APIParameters.Visits.alert_type: isCheckin ? isEarly ? "Early Check In" : "Late Check In"  : isEarly ? "Early Check Out" : "Late Check Out",
                          APIParameters.Visits.alert_status: "Action Required",
                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
            ] as [String : Any]
            if let uatId = uatId{
                params[APIParameters.Visits.uat_id] = uatId
            }
            WebServiceManager.sharedInstance.callAPI(apiPath: .addAlertCheckInOut, method: .post, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
    //                        for controller in (self?.navigationController!.viewControllers ?? []) as Array {
    //                            if controller.isKind(of: VisitsViewController.self) {
    //                                self?.navigationController!.popToViewController(controller, animated: true)
    //                            }
    //                        }
                            
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
    
    
    
    
    
    
//         override func viewDidLoad() {
//            super.viewDidLoad()
//            
//            print("Gaurav :- ", isCheckin)
//            
//            // Load profile image
//            setupProfileImage()
//            
//            // Labels setup
//            self.nameLbl.text = visit?.clientName ?? (self.client?.fullName ?? "No Name")
//            self.descLbl.text = self.isCheckin ? "Check in" : "Check out"
//            
//            // Visit checkin / checkout times
//            self.visitCheckinTime = convertStringToDate(
//                dateString: "\(self.visit?.visitDate ?? "") \(self.visit?.plannedStartTime ?? "")",
//                format: "yyyy-MM-dd HH:mm"
//            ) ?? Date()
//            
//            self.visitCheckOutTime = convertStringToDate(
//                dateString: "\(self.visit?.visitDate ?? "") \(self.visit?.plannedEndTime ?? "")",
//                format: "yyyy-MM-dd HH:mm"
//            ) ?? Date()
//            
//            self.viewCheckInOut.isHidden = true
//            
//            if self.isCheckin {
//                self.lblType1.text = "Check in"
//            } else {
//                self.lblType1.text = "Check out"
//            }
//            
//            // Google map
//            self.viewDisplayGooleMap.isMyLocationEnabled = true
//            self.viewDisplayGooleMap.settings.myLocationButton = true
//            
//            if let visit = self.visit {
//                self.visitDetailId = visit.visitDetailsID ?? ""
//                self.radius = CLLocationDistance(Double("\(visit.radius?.value ?? 0)")!)
//                self.clientId = visit.clientID ?? ""
//                self.fetchPlaceDetails(placeID: visit.placeID ?? "")
//            } else {
//                self.radius = CLLocationDistance(Double("\(self.client?.radius?.value ?? 0)")!)
//                self.clientId = self.client?.id ?? ""
//                self.fetchPlaceDetails(placeID: self.client?.placeID ?? "")
//            }
//            
//            // Button Action for Check in / Check out
//            self.btnChecknOut.action = {
//                print("isEarly :- ", self.isEarly)
//                print("isCheckIn :- ", self.isCheckin)
//                let isInside = self.checkIfUserIsInsideRadius(
//                    userLocation: self.visitLocation!,
//                    center: self.currentLocation!,
//                    radius: self.radius
//                )
//                if isInside {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                        let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckInPopupViewController.self)
//                        vc.isCheckin = self.isCheckin
//                        vc.confirmHandler = {
//                            if self.isCheckin {
//                                print("CheckIn SuccessFully")
//                                self.updateVisitCheckinTime_APICall()
//                            } else {
//                                print("CheckOut SuccessFully")
//                                self.updateVisitCheckOutTime_APICall()
//                            }
//                        }
//                        vc.transitioningDelegate = customTransitioningDelegate
//                        vc.modalPresentationStyle = .custom
//                        self.present(vc, animated: true)
//                    })
//                } else {
//                    self.view.makeToast(
//                        "Your current location is not within the client's radius. Please reach out to the client location for further assistance.",
//                        duration: 4
//                    )
//                }
//            }
//            
//            let iv: UIImageView = self.view?.viewWithTag(12) as? UIImageView ?? UIImageView()
//            let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()
//            
//            // Google map button
//            self.btnGooleMap.action = {
//                viw.isHidden = false
//                iv.isHidden = false
//                self.updateLocation()
//                self.lblType1.isHidden = false
//                self.isGoogleMap = true
//                self.setupData()
//                self.dispatchWorkItem?.cancel()
//            }
//            
//            // QR Code button
//            self.btnQRCode.action = {
//                iv.isHidden = true
//                viw.isHidden = true
//                self.btnChecknOut.isHidden = true
//                self.lblType1.isHidden = true
//                self.isGoogleMap = false
//                self.setupData()
//                self.setupDispatch()
//                if let workItem = self.dispatchWorkItem {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem)
//                }
//            }
//            
////            self.setupScannerView()
//            self.setupData()
//            self.updateLocation()
//        }
//
//        // MARK: - Setup Profile Image
//        private func setupProfileImage() {
//            if let photo = visit?.clientProfile_image_url ?? client?.profilePhoto,
//               let url = URL(string: photo) {
//                print("Photo URL :- ", photo)
//                self.imageview.sd_setImage(with: url)
//                self.imageview.isHidden = false
//                self.lbl_tittle.isHidden = true
//            } else {
//                print("No Photo Found")
//                self.imageview.isHidden = true
//                self.lbl_tittle.isHidden = false
//                let fullName = visit?.clientName ?? client?.fullName ?? "No Name"
//                let initials = getInitials(from: fullName)
//                self.lbl_tittle.text = initials
//                self.lbl_tittle.font = UIFont.robotoSlab(.regular, size: 20)
//                self.lbl_tittle.textColor = .white
//                self.lbl_tittle.backgroundColor = UIColor(named: "appGreen")
//                self.lbl_tittle.layer.cornerRadius = 25
//                self.lbl_tittle.clipsToBounds = true
//            }
//        }
//
//        // MARK: - Make Image Circular
//        override func viewDidLayoutSubviews() {
//            super.viewDidLayoutSubviews()
//            self.imageview.layer.cornerRadius = self.imageview.frame.size.width / 2
//            self.imageview.clipsToBounds = true
//        }
//
//    
//    
//    func Loadprofileimage () {
//        
//    }
//    
//    
//        func updateLocation () {
//            AGLocationManager.oneTime.updateLocation(complitionHandler: { (result) in
//                switch result{
//                case .success(let t):
//                    self.currentLocation = t.coordinate
//                    
//                    if self.visitLocation != nil {
//                        let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()
//
//                        let isInside = self.checkIfUserIsInsideRadius(userLocation: self.visitLocation!, center: self.currentLocation!, radius: self.radius)
//                        if isInside{
//                            self.btnChecknOut.isHidden = false
//                            viw.isHidden = false
//                          //  self.bottomConstraint.constant = 90
//                        }else{
//                            viw.isHidden = true
//                           // self.bottomConstraint.constant = 20
//                            self.btnChecknOut.isHidden = true
//                        }
//                    }
//                    
//                    // Define start and end locations
//                    self.viewDisplayGooleMap.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withTarget: t.coordinate, zoom: 12)))
//                    break
//                case .failer( _ ):
//                    break
//                }
//            })
//        }
//        
//        // first letter of first name and first letter of last name function
//
//        func getInitials(from fullName: String) -> String {
//            let nameComponents = fullName.components(separatedBy: " ").filter { !$0.isEmpty }
//
//            guard let first = nameComponents.first?.first else { return "" }
//            let last = nameComponents.count > 1 ? nameComponents.last?.first : nil
//
//            let initials = "\(first)\(last ?? Character(""))"
//            return initials.uppercased()
//        }
//        func setupDispatch(){
//            // Before dispatching any work, cancel any existing work item
//            dispatchWorkItem?.cancel()
//            dispatchWorkItem = DispatchWorkItem {
//                var checkin = self.isCheckin
//                if self.client != nil {
//                    checkin = true
//                }
//                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                vc.strImage = "logo_app"
//                if checkin{
//                    vc.strTitle = "Force Check In"
//                    vc.strMessage = "Are you sure want to force check in?"
//                }else{
//                    vc.strImage = "force_checkin"
//                    vc.strTitle = "Force Check out"
//                    vc.strMessage = "GPS and QR Code didn't work. \n Do you want to force check out?"
//                }
//                stepRecordText = stepRecordText + " step 1 -\(checkin)"
//
//                vc.buttonClickHandler = {
//                    self.isForceSign = true
//                    self.forcesign()
//                }
//                
//                vc.otherButtonClickHandler = {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                
//                vc.transitioningDelegate = customTransitioningDelegate
//                vc.modalPresentationStyle = .custom
//                self.present(vc, animated: true)
//            }
//            
//        }
//        func fetchPlaceDetails(placeID: String) {
//            let placesClient = GMSPlacesClient.shared()
//            placesClient.lookUpPlaceID(placeID) { (place, error) in
//                if let error = error {
//                    print("❌ Error fetching place details: \(error.localizedDescription)")
//                    return
//                }
//                if let place = place {
//                    let latitude = place.coordinate.latitude
//                    let longitude = place.coordinate.longitude
//                    self.visitLocation = place.coordinate
//                    if let _ = self.visitLocation , let _ = self.currentLocation {
//                        let isInside = self.checkIfUserIsInsideRadius(userLocation: self.visitLocation!, center: self.currentLocation!, radius: self.radius)
//                        let viw: UIView = self.view?.viewWithTag(7) as? UIView ?? UIView()
//                        if isInside{
//                            self.btnChecknOut.isHidden = false
//                            viw.isHidden = false
//                          //  self.bottomConstraint.constant = 90
//                        }else{
//                            viw.isHidden = true
//                            self.btnChecknOut.isHidden = true
//                          //  self.bottomConstraint.constant = 20
//                        }
//                    }
//                    let camera = GMSCameraPosition.camera(
//                        withLatitude: place.coordinate.latitude,
//                        longitude: place.coordinate.longitude,
//                        zoom: 17
//                    )
//                    self.viewDisplayGooleMap.camera = camera
//                    // Define center point
//                    let circleCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.coordinate.latitude), longitude: CLLocationDegrees(place.coordinate.longitude))
//                    // Draw the circle
//                    self.drawCircle(at: circleCenter, radius: self.radius) // 1000 meters (1 km)
//                    if let currentLocation = self.currentLocation{
//                        self.viewCheckInOut.isHidden = false
//                        self.fetchRoute(from: currentLocation, to: place.coordinate)
//                    }
//                    print("✅ Latitude: \(latitude), Longitude: \(longitude)")
//                } else {
//                    print("❌ Place not found")
//                }
//            }
//        }
//         func checkIfUserIsInsideRadius(userLocation: CLLocationCoordinate2D, center: CLLocationCoordinate2D, radius: CLLocationDistance) -> Bool {
//            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
//            let centerCLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
//            
//            let distance = userCLLocation.distance(from: centerCLLocation) // Distance in meters
//            print("User distance from center: \(distance) meters")
//            
//            return distance <= radius
//        }
//         override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            if !self.isGoogleMap{
//                viewDisplayQRCode.startScanning()
//            }
//        }
//         override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            viewDisplayQRCode.stopScanning()
//        }
//        private func setupScannerView() {
//            viewDisplayQRCode.onQRCodeScanned = { [weak self] scannedCode in
//                debugPrint("scannedCode",scannedCode)
//                self?.validateQR_APICall(qrCode: scannedCode)
//            }
//        }
//        func setupData(){
//            self.setupUnselected(view: self.viewGooleMap)
//            self.setupUnselected(view: self.viewQRCode)
//            self.viewDisplayGooleMap.isHidden = true
//            self.viewDisplayQRCode.isHidden = true
//            
//            if self.isGoogleMap{
//                self.viewDisplayQRCode.stopScanning()
//                self.setupSelected(view: self.viewGooleMap)
//                self.viewDisplayGooleMap.isHidden = false
//                self.viewDisplayQRCode.isHidden = true
//            }else{
//                self.viewDisplayQRCode.startScanning()
//                self.setupSelected(view: self.viewQRCode)
//                self.viewDisplayGooleMap.isHidden = true
//                self.viewDisplayQRCode.isHidden = false
//            }
//        }
//        func setupSelected(view:AGView){
//            view.backgroundColor = UIColor(named: "appGreen")
//            for t in view.subviews{
//                if let ttt = t as? UILabel{
//                    ttt.textColor = .white
//                }
//            }
//        }
//        func setupUnselected(view:AGView){
//            view.backgroundColor = .clear
//            for t in view.subviews{
//                if let ttt = t as? UILabel{
//                    ttt.textColor = UIColor(named: "appGreen") ?? .black
//                }
//            }
//        }
//        func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
//            
//            
//            //        let marker = GMSMarker()
//            //        marker.position = start
//            //        marker.map = self.viewDisplayGooleMap
//            //
//            let marker1 = GMSMarker()
//            marker1.position = end
//            marker1.map = self.viewDisplayGooleMap
//            
//            let origin = "\(start.latitude),\(start.longitude)"
//            let destination = "\(end.latitude),\(end.longitude)"
//            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyARBGwVdA-hbVCGTY8VHLRlvTTa8pfo2Go"
//            
//            guard let url = URL(string: urlString) else { return }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else { return }
//                
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let routes = json["routes"] as? [[String: Any]],
//                       let route = routes.first,
//                       let overviewPolyline = route["overview_polyline"] as? [String: Any],
//                       let points = overviewPolyline["points"] as? String {
//                        
////                        DispatchQueue.main.async {[weak self] in
////                            self?.drawPath(from: points)
////                        }
//                    }
//                } catch {
//                    print("Error parsing route data: \(error)")
//                }
//            }.resume()
//        }
//        func drawPath(from encodedPath: String) {
//            let path = GMSPath(fromEncodedPath: encodedPath)
//            let polyline = GMSPolyline(path: path)
//            polyline.strokeColor = .blue
//            polyline.strokeWidth = 4.0
//            polyline.map = viewDisplayGooleMap
//        }
//        func drawCircle(at center: CLLocationCoordinate2D, radius: CLLocationDistance) {
//            let circle = GMSCircle(position: center, radius: radius)
//            circle.fillColor = (UIColor(named: "appRed") ?? .blue).withAlphaComponent(0.2) // Light transparent blue
//            circle.strokeColor = UIColor(red: 1, green: 0.251, blue: 0.506, alpha: 0.266)// Outline color
//            circle.strokeWidth = 2.0 // Outline width
//            circle.map = viewDisplayGooleMap
//        }
//        func redirectDetailScreen(){
//            if self.isCheckin {
//                CustomLoader.shared.showLoader(on: self.view)
//                WebServiceManager.sharedInstance.callAPI(apiPath: .getVisitDetails(visitId: self.visitDetailId.description,userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[VisitsModel]>.self) { response, successMsg in
//                    CustomLoader.shared.hideLoader()
//                    switch response {
//                    case .success(let data):
//                        DispatchQueue.main.async {[weak self] in
//                            if data.statusCode == 200{
//                                self?.tabBarController?.selectedIndex = 0
//                                self?.navigationController?.popToRootViewController(animated: false)
//                                self?.visit = data.data?.first
//                                if self?.client != nil{
//                                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
//                                    vc.visit =  data.data?.first
//                                    vc.visitType = .onging
//                                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//                                }else{
//                                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
//                                    vc.visit =  data.data?.first
//                                    vc.visitType = .onging
//                                    AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//                                }
//                            }else{
//                                self?.view.makeToast(data.message ?? "")
//                            }
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {[weak self] in
//                            self?.view.makeToast(error.localizedDescription)
//                        }
//                    }
//                }
//            }else{
//                if let viewControllers = self.navigationController?.viewControllers {
//                    for controller in viewControllers {
//                        if controller is ScheduleViewController || controller is UnscheduleViewController { // Replace with actual ViewController class
//                            self.navigationController?.popToViewController(controller, animated: true)
//                            break
//                        }else if controller is VisitsViewController{ // Replace with actual ViewController class
//                            self.navigationController?.popToViewController(controller, animated: true)
//                            break
//                        }
//                    }
//                }
//            }
//            
//        }
//        private func validateQR_APICall(qrCode:String) {
//            
//            CustomLoader.shared.showLoader(on: self.view)
//            WebServiceManager.sharedInstance.callAPI(apiPath: .verifyQRCode(clientId: self.clientId.description), method: .post, params: [APIParameters.Clients.qrCode:qrCode],isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            self?.dispatchWorkItem?.cancel()
//    //                        self?.forcesign()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                                self?.forcesign()
//                            })
//                        }else{
//                            self?.view.makeToast(data.message ?? "")
//                            self?.viewDisplayQRCode.startScanning()
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        
//        func forcesign(){
//            stepRecordText = stepRecordText + " step 2 -"
//
//            if self.client == nil{
//                stepRecordText = stepRecordText + " step 3"
//
//                if self.isCheckin{
//                    stepRecordText = stepRecordText + " step 5 -"
//
//                    if self.visit?.visitType == "Scheduled"{
//                        stepRecordText = stepRecordText + " step 6 - \(self.visitCheckinTime)"
//
//                        if let cIn = self.visitCheckinTime {
//                            stepRecordText = stepRecordText + " step 7 "
//
//                            if cIn > Date(){
//                                stepRecordText = stepRecordText + " step 8 "
//
//                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                                vc.strImage = "early_checkin"
//                                vc.strTitle = "Early Check In"
//                                vc.strButton = "Yes"
//                                vc.strCancelButton = "No"
//                                vc.strMessage = "You’re checking in earlier than planned time. Do you want to continue?"
//                                vc.buttonClickHandler = {
//                                    self.isEarly = true
//                                    self.updateVisitCheckinTime_APICall()
//                                }
//                                vc.transitioningDelegate = customTransitioningDelegate
//                                vc.modalPresentationStyle = .custom
//                                self.present(vc, animated: true)
//                                stepRecordText = stepRecordText + " step 9"
//
//                            }else if cIn < Date() {
//                                stepRecordText = stepRecordText + " step 10"
//
//                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                                vc.strImage = "logout_3542033 1"
//                                vc.strTitle = "Late Check In"
//                                vc.strButton = "Yes"
//                                vc.strCancelButton = "No"
//                                vc.strMessage = "You’re checking in later than planned time. Do you want to continue?"
//                                vc.buttonClickHandler = {
//                                    self.isEarly = false
//                                    self.updateVisitCheckinTime_APICall()
//                                }
//                                vc.transitioningDelegate = customTransitioningDelegate
//                                vc.modalPresentationStyle = .custom
//                                self.present(vc, animated: true)
//                            }else{
//                                stepRecordText = stepRecordText + " step 11"
//
//                                self.updateVisitCheckinTime_APICall()
//                            }
//                        }
//                    }else{
//                        self.updateVisitCheckinTime_APICall()
//                    }
//                    
//                }else{
//                    stepRecordText = stepRecordText + " step 4"
//
//                    if self.visit?.visitType == "Scheduled"{
//                        stepRecordText = stepRecordText + " step 12"
//
//                        if let cOut = self.visitCheckOutTime{
//                            stepRecordText = stepRecordText + " step 13"
//
//                            if cOut > Date(){
//                                stepRecordText = stepRecordText + " step 14"
//
//                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                                vc.strImage = "early_checkin"
//                                vc.strTitle = "Early Check Out"
//                                vc.strButton = "Yes"
//                                vc.strCancelButton = "No"
//                                vc.strMessage = "You’re checking out earlier than planned time. Do you want to continue?"
//                                vc.buttonClickHandler = {
//                                    self.isEarly = true
//                                    self.updateVisitCheckOutTime_APICall()
//                                }
//                                vc.transitioningDelegate = customTransitioningDelegate
//                                vc.modalPresentationStyle = .custom
//                                self.present(vc, animated: true)
//                            }else if cOut < Date(){
//                                stepRecordText = stepRecordText + " step 15"
//                                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                                vc.strImage = "logout_3542033 1"
//                                vc.strTitle = "Late Check Out"
//                                vc.strButton = "Yes"
//                                vc.strCancelButton = "No"
//                                vc.strMessage = "You’re checking out later than planned time. Do you want to continue?"
//                                vc.buttonClickHandler = {
//                                    self.isEarly = false
//                                    self.updateVisitCheckOutTime_APICall()
//                                }
//                                vc.transitioningDelegate = customTransitioningDelegate
//                                vc.modalPresentationStyle = .custom
//                                self.present(vc, animated: true)
//                            }else{
//                                stepRecordText = stepRecordText + " step 16"
//
//                                self.updateVisitCheckOutTime_APICall()
//                            }
//                        }
//                    }else{
//                        stepRecordText = stepRecordText + " step 17"
//
//                        self.updateVisitCheckOutTime_APICall()
//                    }
//                }
//            }else{
//                stepRecordText = stepRecordText + " step 18 "
//
//                self.createUnscheduleVisit_APICall()
//            }
//        }
//        private func updateVisitCheckinTime_APICall() {
//            
//            CustomLoader.shared.showLoader(on: self.view)
//            guard let hashToken = UserDetails.shared.loginModel?.hashToken else {
//               return
//            }
//            print("HashToken :- ",hashToken)
//           // checkinAPITagg = "checkin"
//          //  print("checkinAPITagg :- ",checkinAPITagg)
//            let params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
//                         // APIParameters.hashToken:hashToken,
//                          APIParameters.Visits.status: "checkin",
//                          APIParameters.Visits.userId: UserDetails.shared.user_id,
//                          APIParameters.Visits.clientId: self.clientId,
//                          APIParameters.Visits.actualStartTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
//                                                                                    timeZone: TimeZone(identifier: "Europe/London")),
//                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//            ] as [String : Any]
//            
//            WebServiceManager.sharedInstance.callAPI(apiPath: .updateVisitCheckinTime,
//                                                     method: .post,
//                                                     params: params,
//                                                     isAuthenticate: true,
//                                                     model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//    //                DispatchQueue.main.async {
//                        if data.statusCode == 200{
//                          
//                            if self.isForceSign{
//                                var uatId = ""
//                                if let id = data.data?.first?.id {
//                                    uatId = id
//                                }
//                                self.createForceCheckin_APICall(uatId: uatId,
//                                                                isCheckin: true)
//                                if let e = self.isEarly{
//                                    self.createEarlyLateCheckin_APICall(uatId: uatId,
//                                                                        isCheckin: true,
//                                                                        isEarly:e)
//                                }
//                            }else{
//                                self.redirectDetailScreen()
//                                if let e = self.isEarly{
//                                    var uatId = ""
//                                    if let id = data.data?.first?.id {
//                                        uatId = id
//                                    }
//                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: true,isEarly:e)
//                                }
//                            }
//                        }else{
//                            self.view.makeToast(data.message ?? "")
//                        }
//    //                }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        
//        private func updateVisitCheckOutTime_APICall() {
//            
//            let params = [APIParameters.Visits.actualEndTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
//                                                                                  timeZone: TimeZone(identifier: "Europe/London")),
//                          APIParameters.Visits.status: "checkout",
//                          APIParameters.Visits.updatedAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",
//                                                                              timeZone: TimeZone(identifier: "Europe/London"))
//            ] as [String : Any]
//            
//            CustomLoader.shared.showLoader(on: self.view)
//            WebServiceManager.sharedInstance.callAPI(apiPath: .updateVisitCheckoutTime(userId:UserDetails.shared.user_id,
//                                                                                       visitId: self.visitDetailId.description),
//                                                     method: .put, params: params,
//                                                     isAuthenticate: true,
//                                                     model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                        if data.statusCode == 200{
//                            var uatId = ""
//                            if let id = data.data?.first?.id {
//                                uatId = id
//                            }
//                            self.view.showToastwithImage(message: data.message ?? "", image: UIImage(named: "tick_toast"), textColor: .white, backgroundColor: .systemGreen)
//                            if self.isForceSign{
//                                self.createForceCheckin_APICall(uatId: data.data?.first?.id, isCheckin: false)
//                                if let e = self.isEarly{
//                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: false,isEarly:e)
//                                }
//                            }else{
//                                self.redirectDetailScreen()
//                                if let e = self.isEarly{
//                                    self.createEarlyLateCheckin_APICall(uatId: uatId, isCheckin: false,isEarly:e)
//                                }
//                            }
//                        }else{
//                            self.view.makeToast(data.message ?? "")
//                        }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        
//        private func createUnscheduleVisit_APICall() {
//            CustomLoader.shared.showLoader(on: self.view)
//            let params = [APIParameters.UnscheduledVisits.clientId: self.clientId,
//                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
//                          APIParameters.UnscheduledVisits.visitDate: convertDateToString(date: Date(), format: "yyyy-MM-dd",timeZone: TimeZone(identifier: "Europe/London")),
//                          APIParameters.UnscheduledVisits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London")),
//                          APIParameters.UnscheduledVisits.actualStartTime: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//            ] as [String : Any]
//            
//            
//            WebServiceManager.sharedInstance.callAPI(apiPath: .createUnscheduledVisit, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[VisitsDetailModel]>.self) { response, successMsg in
//                CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            self?.visitDetailId = data.userActualTimeData?.first?.visitDetailsID ?? ""
////                            self?.updateVisitCheckinTime_APICall()
//                            self?.redirectDetailScreen()
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
//         private func createForceCheckin_APICall(uatId:String?,isCheckin:Bool) {
//            
//            var params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
//                          APIParameters.Visits.clientId: self.clientId,
//                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
//                          APIParameters.Visits.alert_type: isCheckin ? "Force Check In" : "Force Check Out",
//                          APIParameters.Visits.alert_status: "Action Required",
//                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//            ] as [String : Any]
//            if let uatId = uatId{
//                params[APIParameters.Visits.uat_id] = uatId
//            }
//            WebServiceManager.sharedInstance.callAPI(apiPath: .addAlertCheckInOut, method: .post, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200 {
//                            self?.redirectDetailScreen()
//                        }else{
//                            self?.view.makeToast(data.message ?? "")
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {[weak self] in
//                        self?.view.makeToast(error.localizedDescription)
//                    }
//                }
//        }
//    }
//         private func createEarlyLateCheckin_APICall(uatId:String?,isCheckin:Bool,isEarly:Bool) {
//            print("IsCheckIn :- ",isCheckin)
//            var params = [APIParameters.Visits.visit_details_id: self.visitDetailId,
//                          APIParameters.Visits.clientId: self.clientId,
//                          APIParameters.UnscheduledVisits.userId: UserDetails.shared.user_id,
//                          APIParameters.Visits.alert_type: isCheckin ? isEarly ? "Early Check In" : "Late Check In"  : isEarly ? "Early Check Out" : "Late Check Out",
//                          APIParameters.Visits.alert_status: "Action Required",
//                          APIParameters.Visits.createdAt: convertDateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss",timeZone: TimeZone(identifier: "Europe/London"))
//            ] as [String : Any]
//            if let uatId = uatId{
//                params[APIParameters.Visits.uat_id] = uatId
//            }
//            WebServiceManager.sharedInstance.callAPI(apiPath: .addAlertCheckInOut, method: .post, params: params,isAuthenticate: true, model: EmptyReponse.self) { response, successMsg in
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//    //                        for controller in (self?.navigationController!.viewControllers ?? []) as Array {
//    //                            if controller.isKind(of: VisitsViewController.self) {
//    //                                self?.navigationController!.popToViewController(controller, animated: true)
//    //                            }
//    //                        }
//                            
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
