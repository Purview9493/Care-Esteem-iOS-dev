//
//  ClientDetailViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 08/03/25.
//

import UIKit

class ClientDetailViewController: UIViewController {
    @IBOutlet weak var aboutMeBtn: AGButton!
    @IBOutlet weak var careBtn: AGButton!
    @IBOutlet weak var planBtn: AGButton!
    @IBOutlet weak var img_Pluse: UIImageView!
    @IBOutlet weak var myCareTableView: AGTableView!
    @IBOutlet weak var carePlanTableView: AGTableView!
    @IBOutlet weak var btnAboutMe: AGButton!
    @IBOutlet weak var btnCareNetwork: AGButton!
    @IBOutlet weak var btnCarePlan: AGButton!
    @IBOutlet weak var imgDropDownCareNetwork: UIImageView!
    @IBOutlet weak var imgDropDownCarePlan: UIImageView!
    @IBOutlet weak var btnCreateUnschedule: AGButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var btn_uploadDoc: AGButton!
    
    
    var clientDetail:ClientDetailModel?
    var client:ClientModel?
    var list:[MyCustomListModel] = []
    var expendedIndex = -1
    var selectedType: ClientDetailType = .about
    var aboutList:[[MyPopupListModel]] = []
    var docArray: [Documents] = []
    var imageView: UIImageView!
  
     
    
    @IBAction func docBtnaction(_ sender: Any) {
        if docArray.count == 0 {
            AppDelegate.shared.window?.showToastwithImage(
                message: "No documents found",
                image: UIImage(named: "cross_toast"),
                textColor: .white,
                backgroundColor: UIColor(named: "appRed")
            )
            return
        }
        let vc = Storyboard.Clients.instantiateViewController(withViewClass: Document2VC.self)
        
        vc.docArray = self.docArray
        //        vc.modalPresentationStyle = ./*overFullScreen*/
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    enum ClientDetailType{
        case about
        case care
        case plan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.btnAboutMe.titleLabel?.text = "About me"
//        self.careBtn.titleLabel?.text = "Care Network"
//        self.planBtn.titleLabel?.text = "Care Plan"
//        self.btnAboutMe.setTitle("About me", for: .normal)
        self.btn_uploadDoc.titleLabel?.font = UIFont.robotoSlab(.regular, size: 14)
//        self.btnAboutMe.titleLabel?.font = UIFont.robotoSlab(.regular, size: 19)
//        self.btnCarePlan.titleLabel?.font = UIFont.robotoSlab(.regular, size: 19)
//        self.btnCareNetwork.titleLabel?.font = UIFont.robotoSlab(.regular, size: 19)
        self.btnCreateUnschedule.setTitle("    Create an Unscheduled Visit", for: .normal)
        self.btnCreateUnschedule.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)
        self.aboutMeBtn.setTitle("About me", for: .normal)
        self.aboutMeBtn.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)

        self.planBtn.setTitle("Care Plan", for: .normal)
        self.planBtn.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)

        self.careBtn.setTitle("Care Network", for: .normal)
        self.careBtn.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)
        self.clientNameLbl.text = self.client?.fullName ?? ""
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 42, width: 10, height: 5))
        imageView.image = UIImage(named: "polygon")
        let scroll = self.view.viewWithTag(10)
        scroll?.addSubview(imageView)
        self.lblName.text = "About \(self.client?.fullName ?? "")"
        self.getClientDetail_APICall()
        self.getRiskDetail_APICall()
        self.getPlanCare_APICall()
        self.lblName.text = client?.fullName ?? ""
        if var components = client?.fullName?.components(separatedBy: " "), components.count > 1 {
            self.lblName.text = components.last
        }
        self.myCareTableView.isHidden = true
        self.carePlanTableView.isHidden = true
        aboutList = []
        aboutList = [[
            MyPopupListModel(title:"Date of Birth",value: self.clientDetail?.about?.dateOfBirth ?? ""),
            MyPopupListModel(title:"Age",value: (self.clientDetail?.about?.age?.value as? Int ?? 0).description),
            MyPopupListModel(title:"NHs No.",value: self.clientDetail?.about?.nhsNumber ?? ""),
            MyPopupListModel(title:"Gender",value: self.clientDetail?.about?.gender ?? ""),
            MyPopupListModel(title:"Religion",value: self.clientDetail?.about?.religion ?? ""),
            MyPopupListModel(title:"Marital Status",value: self.clientDetail?.about?.maritalStatus ?? ""),
            MyPopupListModel(title:"Ethnicity",value: self.clientDetail?.about?.ethnicity ?? "")]]
        self.btnAboutMe.action = {
            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupAboutMeInfoViewController.self)
            vc.titleStr = "About \(self.client?.fullName ?? "")"
            vc.list = self.aboutList
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        
        self.aboutMeBtn.action = {
            self.btnCreateUnschedule.isHidden = false
          //  self.img_Pluse.isHidden = false
            self.selectedType = .about
            self.setData()
        }
        self.careBtn.action = {
            self.btnCreateUnschedule.isHidden = true
           // self.img_Pluse.isHidden = true
            self.selectedType = .care
            self.setData()
        }
        self.planBtn.action = {
            self.selectedType = .plan
            self.setData()
        }
        planBtn.roundCorners([.topLeft, .topRight], radius: 10)
        careBtn.roundCorners([.topLeft, .topRight], radius: 10)
        aboutMeBtn.roundCorners([.topLeft, .topRight], radius: 10)
        
        self.selectedType = .about
        self.setData()
        getdocuments()
        
        self.btnCreateUnschedule.action = {
            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupCreateUnchecduleViewController.self)
            vc.confirmHandler = {
                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                vc.client = self.client
                vc.isCheckin = true
                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        
    }
    @IBAction func btnBackAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateImageViewFrame(btn: AGButton) {
        imageView.frame =  CGRect(x: (btn.frame.origin.x + btn.frame.width / 2 ), y: 42, width: 10, height: 5)
    }
    func safeValue(_ value: String?) -> String {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (trimmed?.isEmpty == false) ? trimmed! : "N/A"
    }
    func setData() {
        if selectedType == .about {
            
            self.aboutList = [[
                MyPopupListModel(title: "Gender", value: safeValue(self.clientDetail?.about?.gender)),
                MyPopupListModel(title: "Religion", value: safeValue(self.clientDetail?.about?.religion)),
                MyPopupListModel(title: "Ethnicity", value: safeValue(self.clientDetail?.about?.ethnicity)),
                MyPopupListModel(title: "Name", value: safeValue(self.clientNameLbl.text)),
                MyPopupListModel(title: "Date of Birth", value: safeValue(self.clientDetail?.about?.dateOfBirth)),
                MyPopupListModel(title: "Age", value: safeValue((self.clientDetail?.about?.age?.value as? Int)?.description)),
                MyPopupListModel(title: "NHS No.", value: safeValue(self.clientDetail?.about?.nhsNumber)),
                MyPopupListModel(title: "Marital Status", value: safeValue(self.clientDetail?.about?.maritalStatus))
            ]]
            for item in self.aboutList.first ?? [] {
                let label = UILabel()
                label.text = "\(item.title): \(item.value)"
                
                if let robotoFont = UIFont(name: "RobotoSlab-Regular", size: 16) {
                    label.font = robotoFont
                } else {
                    label.font = UIFont.systemFont(ofSize: 16)
                    print("Roboto Slab font not found. Make sure it's added to your project and Info.plist.")
                }
            }
        
            
            
            self.setupSelected(view: aboutMeBtn)
            self.setupUnselected(view: planBtn)
            self.setupUnselected(view: careBtn)
            updateImageViewFrame(btn: aboutMeBtn)
            self.carePlanTableView.isHidden = false
            self.carePlanTableView.reloadData()
            self.myCareTableView.isHidden = true
            
        }else if selectedType == .care{
            self.setupSelected(view: careBtn)
            self.setupUnselected(view: aboutMeBtn)
            self.setupUnselected(view: planBtn)
            updateImageViewFrame(btn: careBtn)
            self.carePlanTableView.reloadData()
            self.myCareTableView.reloadData()
            
        }else if selectedType == .plan {
            self.setupSelected(view: planBtn)
            updateImageViewFrame(btn: planBtn)
            self.carePlanTableView.reloadData()
            self.myCareTableView.reloadData()
            self.setupUnselected(view: aboutMeBtn)
            self.setupUnselected(view: careBtn)
        }
    }
    
    func setupSelected(view:AGButton){
        view.backgroundColor = UIColor(named: "appGreen")
        view.setTitleColor(.white, for: .normal)
    }
    func setupUnselected(view:AGButton){
        view.backgroundColor = UIColor(named: "appBlue")?.withAlphaComponent(0.10) ?? .blue
        view.setTitleColor(UIColor(named: "appDarkText") ?? .gray, for: .normal)
    }
}
//extension ClientDetailViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if selectedType == .about {
//            return min(aboutList.count, 1)
//        }
//        if selectedType == .care {
//            return  (self.clientDetail?.myCareNetwork?.count ?? 0) + (expendedIndex == -1 ? 0 : 1)
//        }else{
//            return self.list.count
//        }
//        return 0;//self.list.count
//
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if selectedType == .about {
//            let cell = tableView.dequeueReusableCell(withClassIdentifier: AboutStackTableViewCell.self, for: indexPath)
//            
//            let model = self.aboutList[indexPath.row]
//            let imageUrl = client?.profilePhoto
//            let name = client?.fullName ?? ""   // client name
//            var initials = ""
//            let components = name.components(separatedBy: " ")
//            if let first = components.first?.first {
//                initials.append(first)
//            }
//            if let last = components.last?.first, components.count > 1 {
//                initials.append(last)
//            }
//            initials = initials.uppercased()
//            
//            if let imageUrl = imageUrl, !imageUrl.isEmpty {
//                cell.setupData(model: model, imageUrl: imageUrl, initials: initials)
//            } else {
//                cell.setupData(model: model, imageUrl: nil, initials: initials)
//            }
//            
//            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
//            return cell
//        }
//        if selectedType == .care {
//            if !(expendedIndex != -1 && (indexPath.row == expendedIndex + 1)) {
//                let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
//                var index = 0
//                if expendedIndex == -1 {
//                    index = indexPath.row
//                } else {
//                    index = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
//                }
//                cell.lblName.text = self.clientDetail?.myCareNetwork?[index].occupationType
//                cell.lblName.textColor = UIColor(named: "appGreen")
//                cell.lblName.font = UIFont(name: "RobotoSlab-Regular", size: 13)
//
//
////                cell.lblName.text = self.clientDetail?.myCareNetwork?[index].occupationType
//                let iv: UIImageView = cell.viewWithTag(2) as! UIImageView
//                iv.image = indexPath.row == expendedIndex ? UIImage(named: "upArrow") : UIImage(named: "downArrow")
//                
////                iv.image = indexPath.row == expendedIndex ? UIImage(named: "downArrow") : UIImage(named: "upArrow")
//                let call: UIImageView = cell.viewWithTag(1) as! UIImageView
//                call.accessibilityIdentifier = self.clientDetail?.myCareNetwork?[index].contactNumber
//                call.isUserInteractionEnabled = true
//                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
//                call.addGestureRecognizer(tap)
//                self.myCareTableView.layoutSubviews()
//                return cell
//            } else {
//                let array = [[
//                    MyPopupListModel(
//                        title: "Name",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].name?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].name
//                                : "N/A") ?? "N/A"
//                    ),
//                    MyPopupListModel(
//                        title: "Age",
//                        value: ((self.clientDetail?.myCareNetwork?[indexPath.row - 1].age?.value as? Int ?? 0) > 0
//                                ? (self.clientDetail?.myCareNetwork?[indexPath.row - 1].age?.value as? Int ?? 0).description
//                                : "N/A")
//                    ),
//                    MyPopupListModel(
//                        title: "Contact Number",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].contactNumber?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].contactNumber
//                                : "N/A") ?? "N/A"
//                    ),
//                    MyPopupListModel(
//                        title: "Email",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].email?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].email
//                                : "N/A") ?? "N/A"
//                    ),
//                    MyPopupListModel(
//                        title: "Address",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].address?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].address
//                                : "N/A") ?? "N/A"
//                    ),
//                    MyPopupListModel(
//                        title: "City",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].city?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].city
//                                : "N/A") ?? "N/A"
//                    ),
//                    MyPopupListModel(
//                        title: "Post Code",
//                        value: (self.clientDetail?.myCareNetwork?[indexPath.row - 1].postCode?.isEmpty == false
//                                ? self.clientDetail?.myCareNetwork?[indexPath.row - 1].postCode
//                                : "N/A") ?? "N/A"
//                    )
//
//                ]]
//                let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
//                cell.setupData(model: array.first!)
//                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
//                return cell
//            }
//
//        }else{
//        
//            let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
//            if ["ActivityRiskAssessment","BehaviourRiskAssessment","SelfAdministrationRiskAssessment","MedicationRiskAssessment","EquipmentRegister","FinancialRiskAssessment","COSHHRiskAssessment"].contains(self.list[indexPath.row].key){
//                print("Gaurav")
//                cell.setupData(riskModel: self.list[indexPath.row].risk, title: self.list[indexPath.row].title)
//                
//            }else{
//                print("Aman")
//                cell.setupData(model: self.list[indexPath.row].value, border: true, title: self.list[indexPath.row].title)
//            }
//            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
//            return cell
//        }
//    }
//    
//    @objc func handleTap(gesture:UITapGestureRecognizer){
//        let imageView = gesture.view
//        if let url = URL(string: imageView?.accessibilityIdentifier ?? "") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//                return
//            }
//        }
//        self.showToast(message: "Contact number not available")
//
//    }
//    
//    func showToast(message: String) {
//        let toastView = UIView()
//        toastView.backgroundColor = .red
//        toastView.layer.cornerRadius = 22
//        toastView.clipsToBounds = true
//        toastView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(toastView)
//        
//        NSLayoutConstraint.activate([
//            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100), // Bottom se 100 px
//            toastView.widthAnchor.constraint(equalToConstant: 300),
//            toastView.heightAnchor.constraint(equalToConstant: 45)
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
//        let iconImageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
//        iconImageView.tintColor = .white
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let toastLabel = UILabel()
//        toastLabel.text = message
//        toastLabel.textColor = .white
//        toastLabel.font = UIFont(name: "RobotoSlab-Regular", size: 16)
//        toastLabel.numberOfLines = 1
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
//
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if selectedType == .care && (indexPath.row == 0 || indexPath.row - 1 != expendedIndex) {
////            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupAboutMeInfoViewController.self)
//            if expendedIndex == -1 {
//                expendedIndex = indexPath.row
//            } else if expendedIndex == indexPath.row {
//                expendedIndex = -1
//            } else {
//                expendedIndex = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
//            }
//
//        }else{
//            if list.count <= indexPath.row{
//                return
//            }
//            return
//
//        }
//        
//    }
//}
//
//class MyCareItemTableViewCell:UITableViewCell{
//    @IBOutlet weak var bgView: AGView!
//    @IBOutlet weak var lblName: UILabel!
//}
//// MARK: API Call
//extension ClientDetailViewController {
//    
//    private func getClientDetail_APICall() {
//     //   CustomLoader.shared.showLoader(on: self.view)
//        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientDetails(clientId: (self.client?.id ?? "").description), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<ClientDetailModel>.self) { response, successMsg in
//        //    CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        self?.clientDetail = data.data
//                        self?.setData()
////                        self.myCareTableView.reloadData()
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
//    private func getRiskDetail_APICall() {
//        
//     //   CustomLoader.shared.showLoader(on: self.view)
//        let client_id = (self.client?.id ?? "").description
//        
//        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanRisk,queryParams: ["client_id":client_id], method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
//         //   CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        if let d = data.data?.first{
//                            self?.createCustomList(model: d)
//                        }
//                        self?.carePlanTableView.reloadData()
//                    }else{
//                        self?.view.makeToast(data.message ?? "")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {[weak self] in
////                    self?.view.makeToast(error.localizedDescription)
//                }
//            }
//        }
//    }
//    private func getPlanCare_APICall() {
//        
//       // CustomLoader.shared.showLoader(on: self.view)
//        let client_id = (self.client?.id ?? "").description
//        
//        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanAss(clientId: client_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
//        //    CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        if let d = data.data?.first{
//                            for (key,value) in d{
//                                if let value:[String:Any] = value.value as? [String:Any],!value.keys.isEmpty{
//                                    var temp:MyCustomListModel = MyCustomListModel()
//                                    temp.title = key.addSpaceBeforeUppercase()
//                                    temp.key = key
//                                    
//                                    let questionKeys = value.keys.filter { $0.hasPrefix("questions_name_") }
//                                    var l:[MyPopupListModel] = []
//                                    for key in questionKeys {
//                                        if let question = (value[key] as? CodableValue)?.value as? String {
//                                            let index = key.replacingOccurrences(of: "questions_name_", with: "")
//                                            let statusKey = "status_\(index)"
//                                            let commentKey = "comment_\(index)"
//                                            let comment = (value[commentKey] as? CodableValue)?.value as? String ?? "N/A"
//                                            let status = (value[statusKey] as? CodableValue)?.value as? String ?? comment
//                                            let q = question.replacingOccurrences(of: "<name>", with: self?.client?.fullName ?? "")//.replacingOccurrences(of: "<agency name>", with: UserDetails.shared.loginModel?.admin ?? "")
//                                            l.append(MyPopupListModel(title: q,value: status))
//                                        }
//                                    }
//                                    temp.value = l
//                                    self?.list.append(temp)
//                                }
//                            }
//                            self?.list = self?.list.sorted{$0.title < $1.title} ?? []
//                        }
//                        self?.carePlanTableView.reloadData()
//                        self?.carePlanTableView.layoutSubviews()
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
//    func createCustomList(model:[String: CodableValue]){
//        for (key,value) in model{
//            if let list =  value.value as? [CodableValue],!list.isEmpty{
//                var l:[RiskAssesstment] = []
//                var temp:MyCustomListModel = MyCustomListModel()
//                temp.title = key.addSpaceBeforeUppercase()
//                temp.key = key
//                
//                var m1:RiskAssesstment = RiskAssesstment()
//                var last:RiskAssesstment = RiskAssesstment()
//                last.isBottom = true
//                var index:Int = 1
//                for tt in list{
//                    debugPrint(tt.value)
//                    let t = (tt.value as? [String:CodableValue])?.toAnyObject() ?? [:]
//                    if key == "ActivityRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
//                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "BehaviourRiskAssessment"{
//                        
//                        let potential_hazards = t["potential_hazards"] as? [CodableValue] ?? []
//                        let regulatory_measures = t["regulatory_measures"] as? [CodableValue] ?? []
//                        let risk_range = t["risk_range"] as? [CodableValue] ?? []
//                        let support_methods = t["support_methods"] as? [CodableValue] ?? []
//                        let controls_adequate = t["controls_adequate"] as? [CodableValue] ?? []
//                        let level_of_risk = t["level_of_risk"] as? [CodableValue] ?? []
//                        
//                        m1.value = [MyPopupListModel(title: "Frequency Potential",value: t["frequency_potential"] as? String ?? ""),
//                                    MyPopupListModel(title: "Affected By Behaviour",value: t["affected_by_behaviour"] as? String ?? ""),
//                                    MyPopupListModel(title: "Potential Triggers",value: t["potential_triggers"] as? String ?? "")]
//                        
//                        for i in 0..<potential_hazards.count{
//                            if (potential_hazards[i].value as? String ?? "") != ""{
//                                var m:RiskAssesstment = RiskAssesstment()
//                                
//                                var array = [
//                                    MyPopupListModel(title: potential_hazards[i].value as? String ?? "",value: ""),
//                                    MyPopupListModel(title: "Level Of Risk",value: level_of_risk[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Risk Range",value: risk_range[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Support Methods",value: support_methods[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Controls Adequate",value: controls_adequate[i].value as? String ?? ""),
//                                ]
//                                if regulatory_measures.count > 0 {
//                                    array.append(MyPopupListModel(title: "Regulatory Measures",value: regulatory_measures[i].value as? String ?? ""))
//
//                                }
//                                m.value = array
//                                m.isListItem = true
//                                l.append(m)
//                            }
//                        }
//                    }else if key == "SelfAdministrationRiskAssessment"{
//                        m1.value = [
//                            MyPopupListModel(title: "How to take the medicines?",value: t["take_medicines"] as? String ?? ""),
//                            MyPopupListModel(title: "About any special instructions?",value: t["special_instructions"] as? String ?? ""),
//                            MyPopupListModel(title: "About common, possible side effects?",value: t["side_effects"] as? String ?? ""),
//                            MyPopupListModel(title: "What to do if they miss a dose?",value: t["missed_dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Any difficulty in reading the label on the medicines?",value: t["difficulty_reading_label"] as? String ?? ""),
//                            MyPopupListModel(title: "Open their medication (blister packs, bottles)?",value: t[""] as? String ?? ""),
//                            MyPopupListModel(title: "About safe storage?",value: t["safe_storage"] as? String ?? ""),
//                            MyPopupListModel(title: "Agree to notify?",value: t["agrees_to_notify"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible for reorder?",value: t["responsible_for_reorder"] as? String ?? ""),
//                        ]
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Medication \(index)",value:""),
//                            MyPopupListModel(title: "Medicine Name",value: t["medicine_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Dose",value: t["dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Route",value: t["route"] as? String ?? ""),
//                            MyPopupListModel(title: "Time/Frequency",value: t["time_frequency"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-Administration",value: t["self_administration"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-administer fully or partially?",value: t["self_administer_fully"] as? String ?? "")
//                        ]
//                        index += 1
//                        m.isListItem = true
//                        l.append(m)
//                    }else if key == "MedicationRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Ordering",value: t["ordering"] as? String ?? ""),
//                            MyPopupListModel(title: "Ordering Comments",value: t["ordering_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Collecting",value: t["collecting"] as? String ?? ""),
//                            MyPopupListModel(title: "Collecting Comments",value: t["collecting_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Verbal Prompt",value: t["verbal_prompt"] as? String ?? ""),
//                            MyPopupListModel(title: "Verbal Prompt Comments",value: t["verbal_prompt_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Assisting",value: t["assisting"] as? String ?? ""),
//                            MyPopupListModel(title: "Assisting Comments",value: t["assisting_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Administering",value: t["administering"] as? String ?? ""),
//                            MyPopupListModel(title: "Administering Comments",value: t["administering_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Specialized Support",value: t["specialized_support"] as? String ?? ""),
//                            MyPopupListModel(title: "Specialized Support Comments",value: t["specialized_support_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Time Specific",value: t["time_specific"] as? String ?? ""),
//                            MyPopupListModel(title: "Time Specific Comments",value: t["time_specific_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Controlled Drugs",value: t["controlled_drugs"] as? String ?? ""),
//                            MyPopupListModel(title: "Controlled Drugs Details",value: t["controlled_drugs_details"] as? String ?? ""),
//                            MyPopupListModel(title: "Agency Notification",value: t["agency_notification"] as? String ?? ""),
//                            MyPopupListModel(title: "Medication Collection Details",value: t["medication_collection_details"] as? String ?? ""),
//                            MyPopupListModel(title: "PRN Medication",value: t["prn_medication"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe Storage",value: t["safe_storage"] as? String ?? ""),
//                            MyPopupListModel(title: "Storage Location",value: t["storage_location"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "EquipmentRegister"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment Description",value: t["equipment_description"] as? String ?? ""),
//                            MyPopupListModel(title: "Provided by",value: t["provided_by"] as? String ?? ""),
//                            MyPopupListModel(title: "Purpose",value: t["purpose"] as? String ?? ""),
//                            MyPopupListModel(title: "Date of next test",value: t["date_of_next_test"] as? String ?? ""),
//                            MyPopupListModel(title: "Test completed on",value: t["test_completed_on"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "FinancialRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Requires Assistance",value: t["requires_assistance"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible Party",value: t["responsible_party"] as? String ?? ""),
//                            MyPopupListModel(title: "Family Member Name",value: t["family_member_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Agency Name",value: t["agency_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Local Authority Name",value: t["local_authority_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Spending Limit",value: t["spending_limit"] as? String ?? ""),
//                            MyPopupListModel(title: "Spending Details",value: t["spending_details"] as? String ?? ""),
//                            MyPopupListModel(title: "Money Spend By",value: t["money_spent_by"] as? String ?? ""),
//                            MyPopupListModel(title: "Activities Finances",value: t["activities_finances"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe Location",value: t["safe_location"] as? String ?? ""),
//                            MyPopupListModel(title: "Provide Details",value: t["provide_details"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "COSHHRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Name Of Product",value: t["name_of_product"] as? String ?? ""),
//                            MyPopupListModel(title: "Type Of Harm",value: t["type_of_harm"] as? String ?? ""),
//                            MyPopupListModel(title: "Description Substance",value: t["description_substance"] as? String ?? ""),
//                            MyPopupListModel(title: "Color",value: t["color"] as? String ?? ""),
//                            MyPopupListModel(title: "Details Substance",value: t["details_substance"] as? String ?? ""),
//                            MyPopupListModel(title: "Contact Substance",value: t["contact_substance"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
//                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }
//                    
//                    var date:[String] = []
//                    if let d = t["date_1"] as? String{
//                        date.append(d)
//                    }
//                    if let d = t["date_2"] as? String{
//                        date.append(d)
//                    }
//                    last.date = date.joined(separator: "\n")
//                    var name:[String] = []
//                    if let d = t["sign_1"] as? String{
//                        name.append(d)
//                    }
//                    if let d = t["sign_2"] as? String{
//                        name.append(d)
//                    }
//                    last.name = name.joined(separator: "\n")
//                }
//                if key == "SelfAdministrationRiskAssessment" || key == "BehaviourRiskAssessment"{
//                    l.insert(m1, at: 0)
//                }
//                l.append(last)
//                temp.risk = l
//                self.list.append(temp)
//            }
//        }
//        self.list = self.list.sorted{$0.title < $1.title}
//        self.carePlanTableView.reloadData()
//        self.carePlanTableView.layoutSubviews()
//    }
//    
//    private func getdocuments() {
//      //  CustomLoader.shared.showLoader(on: self.view)
//        guard let hashToken = UserDetails.shared.loginModel?.hashToken else {
//           return
//        }
//        let param = ["client_id": self.client?.id ?? "",
//                     APIParameters.hashToken: hashToken]
//        WebServiceManager.sharedInstance.callAPI(apiPath: .getUploadedDocuments,  queryParams: param, method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[Documents]>.self) { response, successMsg in
//       //     CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        self?.docArray = data.data ?? []
////                        self.setData()
////                        self.myCareTableView.reloadData()
//                    }else{
////                        self?.view.makeToast(data.message ?? "")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async { 
////                    self?.view.makeToast(error.localizedDescription)
//                }
//            }
//        }
//    }
//}
//


extension ClientDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == .about {
            return min(aboutList.count, 1)
        }
        if selectedType == .care {
            return  (self.clientDetail?.myCareNetwork?.count ?? 0) + (expendedIndex == -1 ? 0 : 1)
        }else{
            return self.list.count
        }
        return 0;//self.list.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType == .about {
            let cell = tableView.dequeueReusableCell(withClassIdentifier: AboutStackTableViewCell.self, for: indexPath)
            
            let model = self.aboutList[indexPath.row]
            let imageUrl = client?.profilePhoto
            let name = client?.fullName ?? ""   // client name
            var initials = ""
            let components = name.components(separatedBy: " ")
            if let first = components.first?.first {
                initials.append(first)
            }
            if let last = components.last?.first, components.count > 1 {
                initials.append(last)
            }
            initials = initials.uppercased()
            
            if let imageUrl = imageUrl, !imageUrl.isEmpty {
                cell.setupData(model: model, imageUrl: imageUrl, initials: initials)
            } else {
                cell.setupData(model: model, imageUrl: nil, initials: initials)
            }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            return cell
        }
        if selectedType == .care {
            if !(expendedIndex != -1 && (indexPath.row == expendedIndex + 1)) {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: MyCareItemTableViewCell.self,for: indexPath)
                var index = 0
                if expendedIndex == -1 {
                    index = indexPath.row
                } else {
                    index = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
                }
                cell.lblName.text = self.clientDetail?.myCareNetwork?[index].occupationType
                cell.lblName.textColor = UIColor(named: "appGreen")
                cell.lblName.font = UIFont(name: "RobotoSlab-Regular", size: 13)
                
                
                //                cell.lblName.text = self.clientDetail?.myCareNetwork?[index].occupationType
                let iv: UIImageView = cell.viewWithTag(2) as! UIImageView
                iv.image = indexPath.row == expendedIndex ? UIImage(named: "upArrow") : UIImage(named: "downArrow")
                
                //                iv.image = indexPath.row == expendedIndex ? UIImage(named: "downArrow") : UIImage(named: "upArrow")
                let call: UIImageView = cell.viewWithTag(1) as! UIImageView
                call.accessibilityIdentifier = self.clientDetail?.myCareNetwork?[index].contactNumber
                call.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
                call.addGestureRecognizer(tap)
                self.myCareTableView.layoutSubviews()
                return cell
            } else {
                let array = [[
                    MyPopupListModel(
                        title: "Name",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].name)
                    ),
                    MyPopupListModel(
                        title: "Age",
                        value: {
                            let age = self.clientDetail?.myCareNetwork?[indexPath.row - 1].age?.value as? Int ?? 0
                            return age > 0 ? "          \(age)" : "          N/A"
                        }()
                    ),
                    MyPopupListModel(
                        title: "Contact Number",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].contactNumber)
                    ),
                    MyPopupListModel(
                        title: "Email",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].email)
                    ),
                    MyPopupListModel(
                        title: "Address",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].address)
                    ),
                    MyPopupListModel(
                        title: "City",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].city)
                    ),
                    MyPopupListModel(
                        title: "Post Code",
                        value: formattedValue(self.clientDetail?.myCareNetwork?[indexPath.row - 1].postCode)
                    )
                ]]

                let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
                cell.setupData(model: array.first!)
                cell.stack.backgroundColor = .clear
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
                return cell
            }
            
        }else{
            
            // ✅ CARE PLAN Section (list)
            if indexPath.row < self.list.count {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: InfoAboutStackTableViewCell.self,for: indexPath)
                let item = self.list[indexPath.row]
                if ["ActivityRiskAssessment","BehaviourRiskAssessment","SelfAdministrationRiskAssessment","MedicationRiskAssessment","EquipmentRegister","FinancialRiskAssessment","COSHHRiskAssessment"].contains(item.key),
                   !item.risk.isEmpty {
                    cell.setupData(riskModel: item.risk, title: item.title)
                } else if !item.value.isEmpty {
                    cell.setupData(model: item.value, border: true, title: item.title)
                } else {
                    // ❌ अगर कुछ भी data नहीं है → skip कर दो
                    cell.isHidden = true
                }
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
                return cell
            }
            
            return UITableViewCell()
        }
    }
    @objc func handleTap(gesture:UITapGestureRecognizer){
        let imageView = gesture.view
        if let url = URL(string: imageView?.accessibilityIdentifier ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
        self.showToast(message: "Contact number not available")

    }
    func formattedValue(_ text: String?) -> String {
        if let t = text, !t.isEmpty {
            return "          " + t
        } else {
            return "          N/A"
        }
    }
    func showToast(message: String) {
        let toastView = UIView()
        toastView.backgroundColor = .red
        toastView.layer.cornerRadius = 22
        toastView.clipsToBounds = true
        toastView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100), // Bottom se 100 px
            toastView.widthAnchor.constraint(equalToConstant: 300),
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



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedType == .care && (indexPath.row == 0 || indexPath.row - 1 != expendedIndex) {
//            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupAboutMeInfoViewController.self)
            if expendedIndex == -1 {
                expendedIndex = indexPath.row
            } else if expendedIndex == indexPath.row {
                expendedIndex = -1
            } else {
                expendedIndex = indexPath.row > expendedIndex ? indexPath.row - 1 : indexPath.row
            }
            tableView.reloadData()

        }else{
            if list.count <= indexPath.row{
                return
            }
            return

        }
        
    }
}

class MyCareItemTableViewCell:UITableViewCell{
    @IBOutlet weak var bgView: AGView!
    @IBOutlet weak var lblName: UILabel!
}
// MARK: API Call
extension ClientDetailViewController {
    
    private func getClientDetail_APICall() {
     //   CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientDetails(clientId: (self.client?.id ?? "").description), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<ClientDetailModel>.self) { response, successMsg in
        //    CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.clientDetail = data.data
                        self?.setData()
//                        self.myCareTableView.reloadData()
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
    
    
    
    

    private func getRiskDetail_APICall() {
            let client_id = (self.client?.id ?? "").description
            
            WebServiceManager.sharedInstance.callAPI(
                apiPath: .getClientCarePlanRisk,
                queryParams: ["client_id": client_id],
                method: .get,
                params: [:],
                isAuthenticate: true,
                model: CommonRespons<[[String: CodableValue1]]>.self
            ) { response, successMsg in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200 {
                            if let d = data.data?.first {
                                print("📦 RAW API RESPONSE (Risk):", d)
                                for (key, value) in d {
                                    let unwrapped = self?.unwrapCodableValue(value)
                                    print("👉 Key: \(key), Value: \(unwrapped ?? "nil")")
                                }
                                self?.createCustomList(model: d)
                                self?.carePlanTableView.reloadData()
                            }
                        } else {
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
    // MARK: - Helper to unwrap CodableValue safely
       
        func unwrapCodableValue(_ codable: CodableValue1) -> Any {
            if let dict = codable.value as? [String: CodableValue1] {
                var result: [String: Any] = [:]
                for (k,v) in dict {
                    result[k] = unwrapCodableValue(v)
                }
                return result
            } else if let arr = codable.value as? [CodableValue1] {
                return arr.map { unwrapCodableValue($0) }
            } else {
                return codable.value ?? ""
            }
        }
    
    private func getPlanCare_APICall() {
            
           // CustomLoader.shared.showLoader(on: self.view)
            let client_id = (self.client?.id ?? "").description
            
            WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanAss(clientId: client_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
            //    CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
                            if let d = data.data?.first{
                                print("📦 API FULL RESPONSE:", response)   // पूरा raw response

                                for (key,value) in d{
                                    if let value:[String:Any] = value.value as? [String:Any],!value.keys.isEmpty{
                                        var temp:MyCustomListModel = MyCustomListModel()
                                        temp.title = key.addSpaceBeforeUppercase()
                                        temp.key = key
                                        
                                        let questionKeys = value.keys.filter { $0.hasPrefix("questions_name_") }
                                        var l:[MyPopupListModel] = []
                                        for key in questionKeys {
                                            if let question = (value[key] as? CodableValue)?.value as? String {
                                                let index = key.replacingOccurrences(of: "questions_name_", with: "")
                                                let statusKey = "status_\(index)"
                                                let commentKey = "comment_\(index)"
                                                let comment = (value[commentKey] as? CodableValue)?.value as? String ?? "N/A"
                                                let status = (value[statusKey] as? CodableValue)?.value as? String ?? comment
                                                let q = question.replacingOccurrences(of: "<name>", with: self?.client?.fullName ?? "")//.replacingOccurrences(of: "<agency name>", with: UserDetails.shared.loginModel?.admin ?? "")
                                                l.append(MyPopupListModel(title: q,value: status))
                                            }
                                        }
                                        temp.value = l
                                        self?.list.append(temp)
                                    }
                                }
                                self?.list = self?.list.sorted{$0.title < $1.title} ?? []
                            }
                            self?.carePlanTableView.reloadData()
                            self?.carePlanTableView.layoutSubviews()
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
    
    
    private func createCustomList(model: [String: CodableValue1]) {
        for (key, value) in model {
            print("👉 Processing Key: \(key)")

            var temp = MyCustomListModel()
            temp.title = key.addSpaceBeforeUppercase()
            temp.key = key
            var l: [RiskAssesstment] = []

            // अगर array है तो parse करो
            if let list = value.value as? [CodableValue], !list.isEmpty {
                var m1 = RiskAssesstment()
                var last = RiskAssesstment()
                last.isBottom = true
                var index = 1

                for (i, item) in list.enumerated() {
                    let t = (item.value as? [String: CodableValue])?.toAnyObject() ?? [:]

                    if key == "ActivityRiskAssessment" {
                        var m = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Activity", value: t["activity"] as? String ?? ""),
                            MyPopupListModel(title: "Task/Support Required", value: t["task_support_required"] as? String ?? ""),
                            MyPopupListModel(title: "Risk", value: t["risk_level"] as? String ?? ""),
                            MyPopupListModel(title: "Risk Range", value: t["range"] as? String ?? ""),
                            MyPopupListModel(title: "Equipment", value: t["equipment"] as? String ?? ""),
                            MyPopupListModel(title: "Action to be taken", value: t["action_to_be_taken"] as? String ?? "")
                        ]
                        l.append(m)

                    } else if key == "BehaviourRiskAssessment" {
                        let potential_hazards = t["potential_hazards"] as? [CodableValue] ?? []
                        let regulatory_measures = t["regulatory_measures"] as? [CodableValue] ?? []
                        let risk_range = t["risk_range"] as? [CodableValue] ?? []
                        let support_methods = t["support_methods"] as? [CodableValue] ?? []
                        let controls_adequate = t["controls_adequate"] as? [CodableValue] ?? []
                        let level_of_risk = t["level_of_risk"] as? [CodableValue] ?? []

                        m1.value = [
                            MyPopupListModel(title: "Frequency Potential", value: t["frequency_potential"] as? String ?? ""),
                            MyPopupListModel(title: "Affected By Behaviour", value: t["affected_by_behaviour"] as? String ?? ""),
                            MyPopupListModel(title: "Potential Triggers", value: t["potential_triggers"] as? String ?? "")
                        ]

                        for i in 0..<potential_hazards.count {
                            if (potential_hazards[i].value as? String ?? "") != "" {
                                var m = RiskAssesstment()
                                var array = [
                                    MyPopupListModel(title: potential_hazards[i].value as? String ?? "", value: ""),
                                    MyPopupListModel(title: "Level Of Risk", value: level_of_risk[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Risk Range", value: risk_range[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Support Methods", value: support_methods[i].value as? String ?? ""),
                                    MyPopupListModel(title: "Controls Adequate", value: controls_adequate[i].value as? String ?? "")
                                ]
                                if regulatory_measures.count > 0 {
                                    array.append(MyPopupListModel(title: "Regulatory Measures", value: regulatory_measures[i].value as? String ?? ""))
                                }
                                m.value = array
                                m.isListItem = true
                                l.append(m)
                            }
                        }

                    } else if key == "SelfAdministrationRiskAssessment" {
                        m1.value = [
                            MyPopupListModel(title: "How to take the medicines?", value: t["take_medicines"] as? String ?? ""),
                            MyPopupListModel(title: "About any special instructions?", value: t["special_instructions"] as? String ?? ""),
                            MyPopupListModel(title: "About common, possible side effects?", value: t["side_effects"] as? String ?? ""),
                            MyPopupListModel(title: "What to do if they miss a dose?", value: t["missed_dose"] as? String ?? ""),
                            MyPopupListModel(title: "Any difficulty in reading the label?", value: t["difficulty_reading_label"] as? String ?? ""),
                            MyPopupListModel(title: "About safe storage?", value: t["safe_storage"] as? String ?? ""),
                            MyPopupListModel(title: "Agree to notify?", value: t["agrees_to_notify"] as? String ?? ""),
                            MyPopupListModel(title: "Responsible for reorder?", value: t["responsible_for_reorder"] as? String ?? "")
                        ]

                        var m = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Medication \(index)", value: ""),
                            MyPopupListModel(title: "Medicine Name", value: t["medicine_name"] as? String ?? ""),
                            MyPopupListModel(title: "Dose", value: t["dose"] as? String ?? ""),
                            MyPopupListModel(title: "Route", value: t["route"] as? String ?? ""),
                            MyPopupListModel(title: "Time/Frequency", value: t["time_frequency"] as? String ?? ""),
                            MyPopupListModel(title: "Self-Administration", value: t["self_administration"] as? String ?? ""),
                            MyPopupListModel(title: "Self-administer fully?", value: t["self_administer_fully"] as? String ?? "")
                        ]
                        index += 1
                        m.isListItem = true
                        l.append(m)

                    } else if key == "MedicationRiskAssessment" {
                        var m = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Ordering", value: t["ordering"] as? String ?? ""),
                            MyPopupListModel(title: "Collecting", value: t["collecting"] as? String ?? ""),
                            MyPopupListModel(title: "Verbal Prompt", value: t["verbal_prompt"] as? String ?? ""),
                            MyPopupListModel(title: "Assisting", value: t["assisting"] as? String ?? ""),
                            MyPopupListModel(title: "Administering", value: t["administering"] as? String ?? ""),
                            MyPopupListModel(title: "Specialized Support", value: t["specialized_support"] as? String ?? ""),
                            MyPopupListModel(title: "Time Specific", value: t["time_specific"] as? String ?? ""),
                            MyPopupListModel(title: "Controlled Drugs", value: t["controlled_drugs"] as? String ?? ""),
                            MyPopupListModel(title: "Agency Notification", value: t["agency_notification"] as? String ?? ""),
                            MyPopupListModel(title: "Safe Storage", value: t["safe_storage"] as? String ?? "")
                        ]
                        l.append(m)

                    } else if key == "EquipmentRegister" {
                        var m = RiskAssesstment()
                        m.isListItem = true
                        m.value = [
                            MyPopupListModel(title: "Equipment \(i+1)", value: ""),
                            MyPopupListModel(title: "Equipment", value: t["equipment"] as? String ?? "N/A"),
                            MyPopupListModel(title: "Equipment Description", value: t["equipment_description"] as? String ?? "N/A"),
                            MyPopupListModel(title: "Provided By", value: t["provided_by"] as? String ?? "N/A"),
                            MyPopupListModel(title: "Purpose", value: t["purpose"] as? String ?? "N/A"),
                            MyPopupListModel(title: "Date of Next Test", value: t["date_of_next_test"] as? String ?? "N/A"),
                            MyPopupListModel(title: "Test Completed On", value: t["test_completed_on"] as? String ?? "N/A")
                        ]
                        l.append(m)

                    } else if key == "FinancialRiskAssessment" {
                        var m = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Requires Assistance", value: t["requires_assistance"] as? String ?? ""),
                            MyPopupListModel(title: "Responsible Party", value: t["responsible_party"] as? String ?? ""),
                            MyPopupListModel(title: "Family Member Name", value: t["family_member_name"] as? String ?? ""),
                            MyPopupListModel(title: "Local Authority Name", value: t["local_authority_name"] as? String ?? ""),
                            MyPopupListModel(title: "Spending Limit", value: t["spending_limit"] as? String ?? ""),
                            MyPopupListModel(title: "Spending Details", value: t["spending_details"] as? String ?? ""),
                            MyPopupListModel(title: "Activities Finances", value: t["activities_finances"] as? String ?? ""),
                            MyPopupListModel(title: "Safe Location", value: t["safe_location"] as? String ?? "")
                        ]
                        l.append(m)

                    } else if key == "COSHHRiskAssessment" {
                        var m = RiskAssesstment()
                        m.value = [
                            MyPopupListModel(title: "Name Of Product", value: t["name_of_product"] as? String ?? ""),
                            MyPopupListModel(title: "Type Of Harm", value: t["type_of_harm"] as? String ?? ""),
                            MyPopupListModel(title: "Description Substance", value: t["description_substance"] as? String ?? ""),
                            MyPopupListModel(title: "Color", value: t["color"] as? String ?? ""),
                            MyPopupListModel(title: "Details Substance", value: t["details_substance"] as? String ?? ""),
                            MyPopupListModel(title: "Contact Substance", value: t["contact_substance"] as? String ?? "")
                        ]
                        l.append(m)
                    }

                    // signatures (सबके नीचे)
                    var date:[String] = []
                    if let d = t["date_1"] as? String { date.append(d) }
                    if let d = t["date_2"] as? String { date.append(d) }
                    last.date = date.joined(separator: "\n")

                    var name:[String] = []
                    if let d = t["sign_1"] as? String { name.append(d) }
                    if let d = t["sign_2"] as? String { name.append(d) }
                    last.name = name.joined(separator: "\n")
                }

                if key == "SelfAdministrationRiskAssessment" || key == "BehaviourRiskAssessment" {
                    l.insert(m1, at: 0)
                }
                l.append(last)
            } else {
                // अगर data nil है तो placeholder
                
            }

            temp.risk = l
            self.list.append(temp)
        }

        self.list = self.list.sorted { $0.title < $1.title }
        self.carePlanTableView.reloadData()
        self.carePlanTableView.layoutSubviews()
    }

  
//    private func createCustomListRisk(model: [String: CodableValue1]) {
//        for (key, value) in model {
//            print("👉 Processing Key: \(key)")
//
//            var temp = MyCustomListModel()
//            temp.title = key.addSpaceBeforeUppercase()
//            temp.key = key
//            var l: [RiskAssesstment] = []
//
//            // अगर data array है
//            if let list = value.value as? [CodableValue], !list.isEmpty {
//                var m1 = RiskAssesstment()
//                var last = RiskAssesstment()
//                last.isBottom = true
//                var index = 1
//
//                for (i, item) in list.enumerated() {
//                    let t = (item.value as? [String:CodableValue])?.toAnyObject() ?? [:]
//
//                    switch key {
//                    case "ActivityRiskAssessment":
//                        var m = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Activity", value: t["activity"] as? String ?? ""),
//                            MyPopupListModel(title: "Task/Support Required", value: t["task_support_required"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk", value: t["risk_level"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk Range", value: t["range"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment", value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Action to be taken", value: t["action_to_be_taken"] as? String ?? "")
//                        ]
//                        l.append(m)
//
//                    case "BehaviourRiskAssessment":
//                        let potential_hazards = t["potential_hazards"] as? [CodableValue] ?? []
//                        let regulatory_measures = t["regulatory_measures"] as? [CodableValue] ?? []
//                        let risk_range = t["risk_range"] as? [CodableValue] ?? []
//                        let support_methods = t["support_methods"] as? [CodableValue] ?? []
//                        let controls_adequate = t["controls_adequate"] as? [CodableValue] ?? []
//                        let level_of_risk = t["level_of_risk"] as? [CodableValue] ?? []
//
//                        m1.value = [
//                            MyPopupListModel(title: "Frequency Potential", value: t["frequency_potential"] as? String ?? ""),
//                            MyPopupListModel(title: "Affected By Behaviour", value: t["affected_by_behaviour"] as? String ?? ""),
//                            MyPopupListModel(title: "Potential Triggers", value: t["potential_triggers"] as? String ?? "")
//                        ]
//
//                        for i in 0..<potential_hazards.count {
//                            if (potential_hazards[i].value as? String ?? "") != "" {
//                                var m = RiskAssesstment()
//                                var array = [
//                                    MyPopupListModel(title: potential_hazards[i].value as? String ?? "", value: ""),
//                                    MyPopupListModel(title: "Level Of Risk", value: level_of_risk[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Risk Range", value: risk_range[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Support Methods", value: support_methods[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Controls Adequate", value: controls_adequate[i].value as? String ?? "")
//                                ]
//                                if regulatory_measures.count > 0 {
//                                    array.append(MyPopupListModel(title: "Regulatory Measures", value: regulatory_measures[i].value as? String ?? ""))
//                                }
//                                m.value = array
//                                m.isListItem = true
//                                l.append(m)
//                            }
//                        }
//
//                    case "SelfAdministrationRiskAssessment":
//                        m1.value = [
//                            MyPopupListModel(title: "How to take the medicines?", value: t["take_medicines"] as? String ?? ""),
//                            MyPopupListModel(title: "Special instructions?", value: t["special_instructions"] as? String ?? ""),
//                            MyPopupListModel(title: "Side effects?", value: t["side_effects"] as? String ?? ""),
//                            MyPopupListModel(title: "Missed dose?", value: t["missed_dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Reading label difficulty?", value: t["difficulty_reading_label"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe storage?", value: t["safe_storage"] as? String ?? ""),
//                            MyPopupListModel(title: "Agrees to notify?", value: t["agrees_to_notify"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible for reorder?", value: t["responsible_for_reorder"] as? String ?? "")
//                        ]
//                        var m = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Medication \(index)", value: ""),
//                            MyPopupListModel(title: "Medicine Name", value: t["medicine_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Dose", value: t["dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Route", value: t["route"] as? String ?? ""),
//                            MyPopupListModel(title: "Time/Frequency", value: t["time_frequency"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-Administration", value: t["self_administration"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-administer fully?", value: t["self_administer_fully"] as? String ?? "")
//                        ]
//                        index += 1
//                        m.isListItem = true
//                        l.append(m)
//
//                    case "MedicationRiskAssessment":
//                        var m = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Ordering", value: t["ordering"] as? String ?? ""),
//                            MyPopupListModel(title: "Collecting", value: t["collecting"] as? String ?? ""),
//                            MyPopupListModel(title: "Verbal Prompt", value: t["verbal_prompt"] as? String ?? ""),
//                            MyPopupListModel(title: "Assisting", value: t["assisting"] as? String ?? ""),
//                            MyPopupListModel(title: "Administering", value: t["administering"] as? String ?? ""),
//                            MyPopupListModel(title: "Specialized Support", value: t["specialized_support"] as? String ?? ""),
//                            MyPopupListModel(title: "Controlled Drugs", value: t["controlled_drugs"] as? String ?? ""),
//                            MyPopupListModel(title: "Agency Notification", value: t["agency_notification"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe Storage", value: t["safe_storage"] as? String ?? "")
//                        ]
//                        l.append(m)
//
//                    case "EquipmentRegister":
//                        var m = RiskAssesstment()
//                        m.isListItem = true
//                        m.value = [
//                            MyPopupListModel(title: "Equipment \(i+1)", value: ""),
//                            MyPopupListModel(title: "Equipment", value: t["equipment"] as? String ?? "N/A"),
//                            MyPopupListModel(title: "Description", value: t["equipment_description"] as? String ?? "N/A"),
//                            MyPopupListModel(title: "Provided By", value: t["provided_by"] as? String ?? "N/A"),
//                            MyPopupListModel(title: "Purpose", value: t["purpose"] as? String ?? "N/A"),
//                            MyPopupListModel(title: "Date of Next Test", value: t["date_of_next_test"] as? String ?? "N/A"),
//                            MyPopupListModel(title: "Test Completed On", value: t["test_completed_on"] as? String ?? "N/A")
//                        ]
//                        l.append(m)
//
//                    case "FinancialRiskAssessment":
//                        var m = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Requires Assistance", value: t["requires_assistance"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible Party", value: t["responsible_party"] as? String ?? ""),
//                            MyPopupListModel(title: "Family Member", value: t["family_member_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Authority", value: t["local_authority_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Spending Limit", value: t["spending_limit"] as? String ?? "")
//                        ]
//                        l.append(m)
//
//                    case "COSHHRiskAssessment":
//                        var m = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Product", value: t["name_of_product"] as? String ?? ""),
//                            MyPopupListModel(title: "Type Of Harm", value: t["type_of_harm"] as? String ?? ""),
//                            MyPopupListModel(title: "Description", value: t["description_substance"] as? String ?? ""),
//                            MyPopupListModel(title: "Color", value: t["color"] as? String ?? ""),
//                            MyPopupListModel(title: "Details", value: t["details_substance"] as? String ?? "")
//                        ]
//                        l.append(m)
//
//                    default:
//                        break
//                    }
//
//                    // signatures
//                    var date:[String] = []
//                    if let d = t["date_1"] as? String { date.append(d) }
//                    if let d = t["date_2"] as? String { date.append(d) }
//                    last.date = date.joined(separator: "\n")
//
//                    var name:[String] = []
//                    if let d = t["sign_1"] as? String { name.append(d) }
//                    if let d = t["sign_2"] as? String { name.append(d) }
//                    last.name = name.joined(separator: "\n")
//                }
//
//                if key == "SelfAdministrationRiskAssessment" || key == "BehaviourRiskAssessment" {
//                    l.insert(m1, at: 0)
//                }
//                l.append(last)
//            } else {
//                // empty placeholder
//                var m = RiskAssesstment()
//                m.value = [MyPopupListModel(title: "No Data Available", value: "")]
//                l.append(m)
//            }
//
//            temp.risk = l
//            self.list.append(temp)
//        }
//
//        self.list = self.list.sorted { $0.title < $1.title }
//        self.carePlanTableView.reloadData()
//        self.carePlanTableView.layoutSubviews()
//    }


    
    
    
    
    
    
//    private func createCustomList(model: [String: CodableValue1]) {
//        for (key, value) in model {
//            let unwrapped = unwrapCodableValue(value)
//            print("👉 Key: \(key), Unwrapped: \(unwrapped)")
//            if let list =  value.value as? [CodableValue],!list.isEmpty{
//                var l:[RiskAssesstment] = []
//                var temp:MyCustomListModel = MyCustomListModel()
//                temp.title = key.addSpaceBeforeUppercase()
//                temp.key = key
//
//                var m1:RiskAssesstment = RiskAssesstment()
//                var last:RiskAssesstment = RiskAssesstment()
//                last.isBottom = true
//                var index:Int = 1
//                for tt in list{
//                    debugPrint(tt.value)
//                    let t = (tt.value as? [String:CodableValue])?.toAnyObject() ?? [:]
//                    if key == "ActivityRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
//                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "BehaviourRiskAssessment"{
//
//                        let potential_hazards = t["potential_hazards"] as? [CodableValue] ?? []
//                        let regulatory_measures = t["regulatory_measures"] as? [CodableValue] ?? []
//                        let risk_range = t["risk_range"] as? [CodableValue] ?? []
//                        let support_methods = t["support_methods"] as? [CodableValue] ?? []
//                        let controls_adequate = t["controls_adequate"] as? [CodableValue] ?? []
//                        let level_of_risk = t["level_of_risk"] as? [CodableValue] ?? []
//
//                        m1.value = [MyPopupListModel(title: "Frequency Potential",value: t["frequency_potential"] as? String ?? ""),
//                                    MyPopupListModel(title: "Affected By Behaviour",value: t["affected_by_behaviour"] as? String ?? ""),
//                                    MyPopupListModel(title: "Potential Triggers",value: t["potential_triggers"] as? String ?? "")]
//
//                        for i in 0..<potential_hazards.count{
//                            if (potential_hazards[i].value as? String ?? "") != ""{
//                                var m:RiskAssesstment = RiskAssesstment()
//
//                                var array = [
//                                    MyPopupListModel(title: potential_hazards[i].value as? String ?? "",value: ""),
//                                    MyPopupListModel(title: "Level Of Risk",value: level_of_risk[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Risk Range",value: risk_range[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Support Methods",value: support_methods[i].value as? String ?? ""),
//                                    MyPopupListModel(title: "Controls Adequate",value: controls_adequate[i].value as? String ?? ""),
//                                ]
//                                if regulatory_measures.count > 0 {
//                                    array.append(MyPopupListModel(title: "Regulatory Measures",value: regulatory_measures[i].value as? String ?? ""))
//
//                                }
//                                m.value = array
//                                m.isListItem = true
//                                l.append(m)
//                            }
//                        }
//                    }else if key == "SelfAdministrationRiskAssessment"{
//                        m1.value = [
//                            MyPopupListModel(title: "How to take the medicines?",value: t["take_medicines"] as? String ?? ""),
//                            MyPopupListModel(title: "About any special instructions?",value: t["special_instructions"] as? String ?? ""),
//                            MyPopupListModel(title: "About common, possible side effects?",value: t["side_effects"] as? String ?? ""),
//                            MyPopupListModel(title: "What to do if they miss a dose?",value: t["missed_dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Any difficulty in reading the label on the medicines?",value: t["difficulty_reading_label"] as? String ?? ""),
//                            MyPopupListModel(title: "Open their medication (blister packs, bottles)?",value: t[""] as? String ?? ""),
//                            MyPopupListModel(title: "About safe storage?",value: t["safe_storage"] as? String ?? ""),
//                            MyPopupListModel(title: "Agree to notify?",value: t["agrees_to_notify"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible for reorder?",value: t["responsible_for_reorder"] as? String ?? ""),
//                        ]
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Medication \(index)",value:""),
//                            MyPopupListModel(title: "Medicine Name",value: t["medicine_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Dose",value: t["dose"] as? String ?? ""),
//                            MyPopupListModel(title: "Route",value: t["route"] as? String ?? ""),
//                            MyPopupListModel(title: "Time/Frequency",value: t["time_frequency"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-Administration",value: t["self_administration"] as? String ?? ""),
//                            MyPopupListModel(title: "Self-administer fully or partially?",value: t["self_administer_fully"] as? String ?? "")
//                        ]
//                        index += 1
//                        m.isListItem = true
//                        l.append(m)
//                    }else if key == "MedicationRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Ordering",value: t["ordering"] as? String ?? ""),
//                            MyPopupListModel(title: "Ordering Comments",value: t["ordering_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Collecting",value: t["collecting"] as? String ?? ""),
//                            MyPopupListModel(title: "Collecting Comments",value: t["collecting_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Verbal Prompt",value: t["verbal_prompt"] as? String ?? ""),
//                            MyPopupListModel(title: "Verbal Prompt Comments",value: t["verbal_prompt_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Assisting",value: t["assisting"] as? String ?? ""),
//                            MyPopupListModel(title: "Assisting Comments",value: t["assisting_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Administering",value: t["administering"] as? String ?? ""),
//                            MyPopupListModel(title: "Administering Comments",value: t["administering_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Specialized Support",value: t["specialized_support"] as? String ?? ""),
//                            MyPopupListModel(title: "Specialized Support Comments",value: t["specialized_support_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Time Specific",value: t["time_specific"] as? String ?? ""),
//                            MyPopupListModel(title: "Time Specific Comments",value: t["time_specific_comments"] as? String ?? ""),
//                            MyPopupListModel(title: "Controlled Drugs",value: t["controlled_drugs"] as? String ?? ""),
//                            MyPopupListModel(title: "Controlled Drugs Details",value: t["controlled_drugs_details"] as? String ?? ""),
//                            MyPopupListModel(title: "Agency Notification",value: t["agency_notification"] as? String ?? ""),
//                            MyPopupListModel(title: "Medication Collection Details",value: t["medication_collection_details"] as? String ?? ""),
//                            MyPopupListModel(title: "PRN Medication",value: t["prn_medication"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe Storage",value: t["safe_storage"] as? String ?? ""),
//                            MyPopupListModel(title: "Storage Location",value: t["storage_location"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "EquipmentRegister"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment Description",value: t["equipment_description"] as? String ?? ""),
//                            MyPopupListModel(title: "Provided by",value: t["provided_by"] as? String ?? ""),
//                            MyPopupListModel(title: "Purpose",value: t["purpose"] as? String ?? ""),
//                            MyPopupListModel(title: "Date of next test",value: t["date_of_next_test"] as? String ?? ""),
//                            MyPopupListModel(title: "Test completed on",value: t["test_completed_on"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "FinancialRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Requires Assistance",value: t["requires_assistance"] as? String ?? ""),
//                            MyPopupListModel(title: "Responsible Party",value: t["responsible_party"] as? String ?? ""),
//                            MyPopupListModel(title: "Family Member Name",value: t["family_member_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Agency Name",value: t["agency_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Local Authority Name",value: t["local_authority_name"] as? String ?? ""),
//                            MyPopupListModel(title: "Spending Limit",value: t["spending_limit"] as? String ?? ""),
//                            MyPopupListModel(title: "Spending Details",value: t["spending_details"] as? String ?? ""),
//                            MyPopupListModel(title: "Money Spend By",value: t["money_spent_by"] as? String ?? ""),
//                            MyPopupListModel(title: "Activities Finances",value: t["activities_finances"] as? String ?? ""),
//                            MyPopupListModel(title: "Safe Location",value: t["safe_location"] as? String ?? ""),
//                            MyPopupListModel(title: "Provide Details",value: t["provide_details"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else if key == "COSHHRiskAssessment"{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Name Of Product",value: t["name_of_product"] as? String ?? ""),
//                            MyPopupListModel(title: "Type Of Harm",value: t["type_of_harm"] as? String ?? ""),
//                            MyPopupListModel(title: "Description Substance",value: t["description_substance"] as? String ?? ""),
//                            MyPopupListModel(title: "Color",value: t["color"] as? String ?? ""),
//                            MyPopupListModel(title: "Details Substance",value: t["details_substance"] as? String ?? ""),
//                            MyPopupListModel(title: "Contact Substance",value: t["contact_substance"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }else{
//                        var m:RiskAssesstment = RiskAssesstment()
//                        m.value = [
//                            MyPopupListModel(title: "Activity",value: t["activity"] as? String ?? ""),
//                            MyPopupListModel(title: "Task/Support Required",value: t["task_support_required"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk",value: t["risk_level"] as? String ?? ""),
//                            MyPopupListModel(title: "Risk Range",value: t["range"] as? String ?? ""),
//                            MyPopupListModel(title: "Equipment",value: t["equipment"] as? String ?? ""),
//                            MyPopupListModel(title: "Action to be taken",value: t["action_to_be_taken"] as? String ?? ""),
//                        ]
//                        l.append(m)
//                    }
//
//                    var date:[String] = []
//                    if let d = t["date_1"] as? String{
//                        date.append(d)
//                    }
//                    if let d = t["date_2"] as? String{
//                        date.append(d)
//                    }
//                    last.date = date.joined(separator: "\n")
//                    var name:[String] = []
//                    if let d = t["sign_1"] as? String{
//                        name.append(d)
//                    }
//                    if let d = t["sign_2"] as? String{
//                        name.append(d)
//                    }
//                    last.name = name.joined(separator: "\n")
//                }
//                if key == "SelfAdministrationRiskAssessment" || key == "BehaviourRiskAssessment"{
//                    l.insert(m1, at: 0)
//                }
//                l.append(last)
//                temp.risk = l
//                self.list.append(temp)
//            }
//        }
//        self.list = self.list.sorted{$0.title < $1.title}
//        self.carePlanTableView.reloadData()
//        self.carePlanTableView.layoutSubviews()
//    }
    
    private func getdocuments() {
      //  CustomLoader.shared.showLoader(on: self.view)
        guard let hashToken = UserDetails.shared.loginModel?.hashToken else {
           return
        }
        let param = ["client_id": self.client?.id ?? "",
                     APIParameters.hashToken: hashToken]
        WebServiceManager.sharedInstance.callAPI(apiPath: .getUploadedDocuments,  queryParams: param, method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[Documents]>.self) { response, successMsg in
       //     CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.docArray = data.data ?? []
//                        self.setData()
//                        self.myCareTableView.reloadData()
                    }else{
//                        self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
//                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}


// MARK: - CodableValue
struct CodableValue1: Codable {
    let value: Any?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = nil
        } else if let intValue = try? container.decode(Int.self) {
            self.value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            self.value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            self.value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
        } else if let dictValue = try? container.decode([String: CodableValue].self) {
            self.value = dictValue
        } else if let arrayValue = try? container.decode([CodableValue].self) {
            self.value = arrayValue
        } else {
            print("⚠️ Unsupported type in CodableValue")
            self.value = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let dictValue = value as? [String: CodableValue] {
            try container.encode(dictValue)
        } else if let arrayValue = value as? [CodableValue] {
            try container.encode(arrayValue)
        } else {
            try container.encodeNil()
        }
    }
}


