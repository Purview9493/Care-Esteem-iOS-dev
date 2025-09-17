//
//  ClientDetail2VC.swift
//  CareEsteem
//
//

import UIKit

class ClientDetail2VC: UIViewController {

    @IBOutlet weak var main_tableView: UITableView!
    @IBOutlet weak var btn_about: AGButton!
    @IBOutlet weak var btn_careNetwork: AGButton!
    @IBOutlet weak var btn_carePlan: AGButton!
    @IBOutlet weak var btn_unScheduled: AGButton!
    @IBOutlet weak var lbl_clientName: UILabel!
    @IBOutlet weak var btn_upLoadDoc: AGButton!
    
    
    var carePlanData: [CarePlanData] = []
     var sections: [CarePlanSectionUI] = []
    
    
    var clientDetail:ClientDetailModel?
    var client:ClientModel?
    var list:[MyCustomListModel] = []
    var expendedIndex = -1
    var selectedType: ClientDetailType = .about
    var aboutList:[[MyPopupListModel]] = []
    var docArray: [Documents] = []
    var imageView: UIImageView!
    
    enum ClientDetailType{
        case about
        case care
        case plan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main_tableView.estimatedRowHeight = 80
        main_tableView.rowHeight = UITableView.automaticDimension
        
        self.btn_upLoadDoc.titleLabel?.font = UIFont.robotoSlab(.regular, size: 14)
        self.btn_about.setTitle("About me", for: .normal)
        self.btn_about.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)
        self.btn_carePlan.setTitle("Care Plan", for: .normal)
        self.btn_carePlan.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)
        self.btn_careNetwork.setTitle("Care Network", for: .normal)
        self.lbl_clientName.text = self.client?.fullName ?? ""
        self.btn_careNetwork.titleLabel?.font = UIFont.robotoSlab(.regular, size: 15)
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 42, width: 10, height: 5))
        imageView.image = UIImage(named: "polygon")
        let scroll = self.view.viewWithTag(1105)
        scroll?.addSubview(imageView)
        
        self.getClientDetail_APICall()
        self.getRiskDetail_APICall()
        self.getPlanCare_APICall()
        aboutList = []
        aboutList = [[
            MyPopupListModel(title:"Date of Birth",value: self.clientDetail?.about?.dateOfBirth ?? ""),
            MyPopupListModel(title:"Age",value: (self.clientDetail?.about?.age?.value as? Int ?? 0).description),
            MyPopupListModel(title:"NHs No.",value: self.clientDetail?.about?.nhsNumber ?? ""),
            MyPopupListModel(title:"Gender",value: self.clientDetail?.about?.gender ?? ""),
            MyPopupListModel(title:"Religion",value: self.clientDetail?.about?.religion ?? ""),
            MyPopupListModel(title:"Marital Status",value: self.clientDetail?.about?.maritalStatus ?? ""),
            MyPopupListModel(title:"Ethnicity",value: self.clientDetail?.about?.ethnicity ?? "")]]
        btn_carePlan.roundCorners([.topLeft, .topRight], radius: 10)
        btn_careNetwork.roundCorners([.topLeft, .topRight], radius: 10)
        btn_about.roundCorners([.topLeft, .topRight], radius: 10)
        
        self.selectedType = .about
        self.setData()
        self.getdocuments()
        // Do any additional setup after loading the view.
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
                MyPopupListModel(title: "Name", value: safeValue(self.lbl_clientName.text)),
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
        
            
            
            self.setupSelected(view: btn_about)
            self.setupUnselected(view: btn_carePlan)
            self.setupUnselected(view: btn_careNetwork)
            updateImageViewFrame(btn: btn_about)
            self.main_tableView.isHidden = false
            self.btn_unScheduled.isHidden = false
            self.main_tableView.reloadData()
          
            
        }else if selectedType == .care{
            self.setupSelected(view: btn_careNetwork)
            self.setupUnselected(view: btn_about)
            self.setupUnselected(view: btn_carePlan)
            updateImageViewFrame(btn: btn_careNetwork)
            self.btn_unScheduled.isHidden = true
            self.main_tableView.reloadData()
          
            
        }else if selectedType == .plan {
            self.setupSelected(view: btn_carePlan)
            updateImageViewFrame(btn: btn_carePlan)
            self.main_tableView.reloadData()
            self.setupUnselected(view: btn_about)
            self.btn_unScheduled.isHidden = true
            self.setupUnselected(view: btn_careNetwork)
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
    
    @IBAction func tapOnAboutButton(_ sender: Any) {
        self.btn_unScheduled.isHidden = false
      //  self.img_Pluse.isHidden = false
        self.selectedType = .about
        self.setData()
    }
    
    @IBAction func tapOnCareNetworkButton(_ sender: Any) {
        self.btn_unScheduled.isHidden = true
       // self.img_Pluse.isHidden = true
        self.selectedType = .care
        self.setData()
    }
    
    @IBAction func tapOnCarePlanButton(_ sender: Any) {
        self.btn_unScheduled.isHidden = true
        self.selectedType = .plan
        self.setData()
    }
    
    @IBAction func tapOnUnscheduledButton(_ sender: Any) {
        getCheckInValidation_APICall()
    }
    
    @IBAction func tapOnUploadDocsButton(_ sender: Any) {
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
    
}

extension ClientDetail2VC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
            if selectedType == .plan {
                return sections.count + list.count
            //sectionKeys.count
            }
            return 1
            }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if selectedType == .plan {
                if section < sections.count {
                    return sections[section].title
                } else {
                    let index = section - sections.count
                    if list.indices.contains(index), !list[index].title.trimmingCharacters(in: .whitespaces).isEmpty {
                        return list[index].title
                    } else {
                        return nil // ✅ Avoid title and hide header
                    }
                }
            }
            return nil
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedType == .plan { return 50 }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if selectedType == .plan {
                let title: String?
                if section < sections.count {
                    title = sections[section].title
                } else {
                    let index = section - sections.count
                    guard list.indices.contains(index) else { return nil }
                    title = list[index].title
                }
                
                guard let safeTitle = title?.trimmingCharacters(in: .whitespaces), !safeTitle.isEmpty else {
                    return nil // ✅ Don’t return header if title is empty
                }
                
                let container = UIView()
                container.backgroundColor = .white
                
                let mainStack = UIStackView()
                mainStack.axis = .vertical
                mainStack.spacing = 8
                mainStack.translatesAutoresizingMaskIntoConstraints = false
                mainStack.layer.borderWidth = 1
                mainStack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
                mainStack.layer.cornerRadius = 10
                mainStack.clipsToBounds = true

                let titleLabel = UILabel()
                titleLabel.text = safeTitle
                titleLabel.font = UIFont.robotoSlab(.bold, size: 16)
                titleLabel.textAlignment = .center
                titleLabel.textColor = UIColor(named: "appGreen")
                titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
                mainStack.addArrangedSubview(titleLabel)

                container.addSubview(mainStack)
                NSLayoutConstraint.activate([
                    mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                    mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
                ])
                return container
            }
    //        if selectedType == .plan {
    //            guard section < sections.count else {
    //                print("❌ Invalid section: \(section), available: \(sections.count)")
    //                let container = UIView()
    //                container.backgroundColor = .white // Important to prevent overlapping
    //
    //                let mainStack = UIStackView()
    //                mainStack.axis = .vertical
    //                mainStack.spacing = 8
    //                mainStack.translatesAutoresizingMaskIntoConstraints = false
    //                mainStack.layer.borderWidth = 1
    //                mainStack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
    //                mainStack.layer.cornerRadius = 10
    //                mainStack.clipsToBounds = true
    //
    //                // 🔹 Title
    //                let titleLabel = UILabel()
    ////                if section < sections.count {
    ////                    titleLabel.text = sections[section].title
    ////                } else {
    //                    let index = section-sections.count
    //                    titleLabel.text = list[index].title
    //               // }
    //
    //                titleLabel.font = UIFont.robotoSlab(.bold, size: 16)
    //                titleLabel.textAlignment = .center
    //                titleLabel.textColor = UIColor(named: "appGreen")
    //                titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    //
    //                mainStack.addArrangedSubview(titleLabel)
    //
    //                // 🔹 Rows (Questions)
    //    //            for (index, question) in sections[section].questions.enumerated() {
    //    //                let qView = setupDataCarePlanView(question: question, index: index + 1)
    //    //                mainStack.addArrangedSubview(qView)
    //    //            }
    //    //
    //                container.addSubview(mainStack)
    //
    //                NSLayoutConstraint.activate([
    //                    mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
    //                    mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
    //                    mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
    //                    mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
    //                ])
    //
    //                return container
    //
    //            }
    //            let container = UIView()
    //            container.backgroundColor = .white // Important to prevent overlapping
    //
    //            let mainStack = UIStackView()
    //            mainStack.axis = .vertical
    //            mainStack.spacing = 8
    //            mainStack.translatesAutoresizingMaskIntoConstraints = false
    //            mainStack.layer.borderWidth = 1
    //            mainStack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
    //            mainStack.layer.cornerRadius = 10
    //            mainStack.clipsToBounds = true
    //
    //            // 🔹 Title
    //            let titleLabel = UILabel()
    //           // if section < sections.count {
    //                titleLabel.text = sections[section].title
    //           // } else {
    //           //     let index = section-sections.count
    //           //     titleLabel.text = list[index].title
    //          //  }
    //
    //            titleLabel.font = UIFont.robotoSlab(.bold, size: 16)
    //            titleLabel.textAlignment = .center
    //            titleLabel.textColor = UIColor(named: "appGreen")
    //            titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    //
    //            mainStack.addArrangedSubview(titleLabel)
    //
    //            // 🔹 Rows (Questions)
    ////            for (index, question) in sections[section].questions.enumerated() {
    ////                let qView = setupDataCarePlanView(question: question, index: index + 1)
    ////                mainStack.addArrangedSubview(qView)
    ////            }
    ////
    //            container.addSubview(mainStack)
    //
    //            NSLayoutConstraint.activate([
    //                mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
    //                mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
    //                mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
    //                mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
    //            ])
    //
    //            return container
    //        }
            return nil
        }
    func setupDataCarePlanView(question: AssessmentQuestion, index: Int) -> UIView {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 12
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

            // 🔹 Question Label (Top)
            let qLabel = UILabel()
            qLabel.text = "Q\(index): \(question.questionName)"
            qLabel.numberOfLines = 0
            qLabel.font = UIFont.robotoSlab(.regular, size: 16)
            qLabel.textColor = .black
            qLabel.textAlignment = .left
            stack.addArrangedSubview(qLabel)

            // 🔹 Answer Label (Middle / Center)
            let aLabel = UILabel()
            aLabel.text = question.status
            aLabel.numberOfLines = 0
            aLabel.font = UIFont.robotoSlab(.regular, size: 15)
            aLabel.textColor = .black
            aLabel.textAlignment = .left   // ✅ Centered in middle
            stack.addArrangedSubview(aLabel)

            // 🔹 Comment Label (Bottom)
            if !question.comment.isEmpty {
                let cLabel = UILabel()
                cLabel.text = question.comment
                cLabel.numberOfLines = 0
                cLabel.font = UIFont.robotoSlab(.regular, size: 14)
                cLabel.textColor = .black
                cLabel.textAlignment = .left
                stack.addArrangedSubview(cLabel)
            }
            return stack
        }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if selectedType == .about {
                return min(aboutList.count, 1)
            }
            if selectedType == .care {
                return  (self.clientDetail?.myCareNetwork?.count ?? 0) + (expendedIndex == -1 ? 0 : 1)
            }else
            {
                if section < sections.count {
                    return sections[section].questions.count
                } else {
                    if section < sections.count {
                        return sections[section].questions.count
                    } else {
                        let listIndex = section - sections.count
                        return list.indices.contains(listIndex) ? list[listIndex].risk.count : 0
                    }
                }
            }
    //        {
    //            // return sections[section].questions.count
    //            if section < sections.count {
    //                return sections[section].questions.count
    //            } else {
    //                return list.count
    //            }
    //            //self.list.count
    //        }

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
                self.main_tableView.layoutSubviews()
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
//                cell.stack.backgroundColor = .clear
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
                return cell
            }
            
        }else{
            if indexPath.section < sections.count {
                // ✅ CARE PLAN Section (list)
                
                let cell = tableView.dequeueReusableCell(withClassIdentifier: CarePlanTableViewCell.self, for: indexPath)
                let question = sections[indexPath.section].questions[indexPath.row]
                let qView = setupDataCarePlanView(question: question, index: indexPath.row + 1)
                
                // Remove previous content
                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                
                qView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(qView)
                NSLayoutConstraint.activate([
                    qView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                    qView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                    qView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    qView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
                ])
                cell.backgroundColor = .white // Prevent overlapping
                cell.contentView.layer.borderWidth = 1
                cell.contentView.layer.borderColor = UIColor(named: "appGreen")?.cgColor
                cell.contentView.layer.cornerRadius = 10
                return cell

            } else {
//            {
//                // ✅ Custom List Section
////                let cell = tableView.dequeueReusableCell(withClassIdentifier: CarePlanTableViewCell.self, for: indexPath)
////                let item = list[indexPath.row]
////                let stack = UIStackView()
////                stack.axis = .vertical
////                stack.spacing = 8
////                stack.translatesAutoresizingMaskIntoConstraints = false
////                for (i, risk) in item.risk.enumerated() {
////                    let label = UILabel()
////                    label.numberOfLines = 0
////                    label.font = UIFont.robotoSlab(.regular, size: 15)
////                    label.text = risk.value.map { "\($0.title): \($0.value)" }.joined(separator: "\n")
////                    stack.addArrangedSubview(label)
////                }
////                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
////                cell.contentView.addSubview(stack)
////                NSLayoutConstraint.activate([
////                    stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
////                    stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
////                    stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
////                    stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
////                ])
////                return cell
//                let cell = tableView.dequeueReusableCell(withClassIdentifier: CarePlanTableViewCell.self, for: indexPath)
//                let item = list[indexPath.row]
//
//                // Remove old views from contentView
//                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
//
//                // Create vertical stack
//                let stack = UIStackView()
//                stack.axis = .vertical
//                stack.spacing = 8
//                stack.translatesAutoresizingMaskIntoConstraints = false
//
//                for (i, risk) in item.risk.enumerated() {
//                    // For each key-value pair in risk.value
//                    for (j, pair) in risk.value.enumerated() {
//                        let rowStack = UIStackView()
//                        rowStack.axis = .horizontal
//                        rowStack.alignment = .top
//                        rowStack.spacing = 4
//                        rowStack.distribution = .fill
//                        rowStack.translatesAutoresizingMaskIntoConstraints = false
//
//                        let isFirst = j == 0
//
//                        let titleLabel = UILabel()
//                        titleLabel.text = pair.title
//                        titleLabel.font = isFirst ? UIFont.robotoSlab(.bold, size: 15) : UIFont.robotoSlab(.regular, size: 15)
//                        //UIFont.boldSystemFont(ofSize: 15) : UIFont.systemFont(ofSize: 15)
//                        titleLabel.numberOfLines = 0
//                        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//
//                        let colonLabel = UILabel()
//                        colonLabel.text = ":"
//                        colonLabel.font = isFirst ? UIFont.robotoSlab(.bold, size: 15) : UIFont.robotoSlab(.regular, size: 15)
//                        colonLabel.textAlignment = .center
//                        colonLabel.setContentHuggingPriority(.required, for: .horizontal)
//
//                        let valueLabel = UILabel()
//                        valueLabel.text = pair.value
//                        valueLabel.font = isFirst ? UIFont.robotoSlab(.bold, size: 15) : UIFont.robotoSlab(.regular, size: 15)
//                        valueLabel.numberOfLines = 0
//                        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//                        valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//
//                        rowStack.addArrangedSubview(titleLabel)
//                        rowStack.addArrangedSubview(colonLabel)
//                        rowStack.addArrangedSubview(valueLabel)
//
//                        stack.addArrangedSubview(rowStack)
//                        if j >= 1 && j < risk.value.count - 1 && i < item.risk.count - 1 {
//                            let separator = UIView()
//                            separator.translatesAutoresizingMaskIntoConstraints = false
//                            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//                            separator.backgroundColor = .lightGray
//                            stack.addArrangedSubview(separator)
//                        }
//                    }
//                }
//                // Add stack to contentView
//                cell.contentView.addSubview(stack)
//                NSLayoutConstraint.activate([
//                    stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
//                    stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
//                    stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
//                    stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
//                ])
//                return cell
//            }
                
                    // ✅ Custom List Section
                    let cell = tableView.dequeueReusableCell(withClassIdentifier: CarePlanTableViewCell.self, for: indexPath)
                    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                    
                    let listIndex = indexPath.section - sections.count
                    guard list.indices.contains(listIndex) else { return cell }
                    let item = list[listIndex]
                    let riskItem = item.risk[indexPath.row]
                    
                    let stack = UIStackView()
                    stack.axis = .vertical
                    stack.spacing = 8
                    stack.translatesAutoresizingMaskIntoConstraints = false
                    
                    for (i, risk) in item.risk.enumerated() {
                        for (j, pair) in risk.value.enumerated() {
                            let rowStack = UIStackView()
                            rowStack.axis = .horizontal
                            rowStack.alignment = .top
                            rowStack.spacing = 4
                            rowStack.distribution = .fill
                            rowStack.translatesAutoresizingMaskIntoConstraints = false
                            
                            let isFirst = j == 0
                            
                            let titleLabel = UILabel()
                            titleLabel.text = pair.title
                            titleLabel.font = isFirst ? .robotoSlab(.bold, size: 15): .robotoSlab(.regular, size: 15)
//                            titleLabel.font = isFirst ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15)
                            titleLabel.numberOfLines = 0
                            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                            
                            let colonLabel = UILabel()
                            colonLabel.text = " :"
                            colonLabel.font = titleLabel.font
                            colonLabel.textAlignment = .center
                            colonLabel.setContentHuggingPriority(.required, for: .horizontal)
                            
                            let valueLabel = UILabel()
                            valueLabel.text = pair.value
                            valueLabel.font = titleLabel.font
                            valueLabel.textAlignment = .left
                            valueLabel.numberOfLines = 0
                            valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
                            valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
                            
                            rowStack.addArrangedSubview(titleLabel)
                            rowStack.addArrangedSubview(colonLabel)
                            rowStack.addArrangedSubview(valueLabel)
                            
                            stack.addArrangedSubview(rowStack)
                            
                            // Optional: Separator for visual clarity
                            if j >= 1 && j < risk.value.count - 1 && i < item.risk.count - 1 {
                                let separator = UIView()
                                separator.backgroundColor = .lightGray
                                separator.translatesAutoresizingMaskIntoConstraints = false
                                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                                stack.addArrangedSubview(separator)
                            }
                        }
                    }
                    
                    cell.contentView.addSubview(stack)
                    NSLayoutConstraint.activate([
                        stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                        stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                        stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                        stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
                    ])
                    
                    return cell
                }
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
        self.view.showToast(message: "Contact number not available")

    }
    
    func formattedValue(_ text: String?) -> String {
        if let t = text, !t.isEmpty {
            return "          " + t
        } else {
            return "          N/A"
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

// MARK: API Call
extension ClientDetail2VC {
    
    private func getClientDetail_APICall() {
     //   CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getClientDetails(clientId: (self.client?.id ?? "").description), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<ClientDetailModel>.self) { response, successMsg in
        //    CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.clientDetail = data.data
                        self?.main_tableView.reloadData()
                        self?.main_tableView.layoutSubviews()
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
                // "314bf3cb6f1141f68f6ff5e0"
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
                                // 👉 JSON format में print करने के लिए:
                                             if let jsonData = try? JSONEncoder().encode(data),
                                                let jsonString = String(data: jsonData, encoding: .utf8) {
                                                 print("📦 CarePlan JSON:\n\(jsonString)")
                                             }
                                self?.createCustomList(model: d)
                                
                                self?.main_tableView.reloadData()
                                self?.main_tableView.layoutSubviews()
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
    private func getCheckInValidation_APICall() {
         //   CustomLoader.shared.showLoader(on: self.view)
            WebServiceManager.sharedInstance.callAPI(apiPath: .checkinValidation(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CheckInResponse.self) { response, successMsg in
            //    CustomLoader.shared.hideLoader()
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {[weak self] in
                        if data.statusCode == 200{
                            let vc = Storyboard.Clients.instantiateViewController(withViewClass: PopupCreateUnchecduleViewController.self)
                            vc.confirmHandler = {
                                let vc = Storyboard.Visits.instantiateViewController(withViewClass: CheckinCheckoutViewController.self)
                                vc.client = self?.client
                                vc.isCheckin = true
                                AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                            }
                            vc.transitioningDelegate = customTransitioningDelegate
                            vc.modalPresentationStyle = .custom
                            self?.present(vc, animated: true)

                        }else{
                            AppDelegate.shared.window?.showToastwithImage(message: data.message ?? "", image: UIImage(named: "cross_toast"), textColor: .white, backgroundColor: UIColor(named: "appRed"))
                           // self?.view.showToast(message: data.message ?? "")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {[weak self] in
                        
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
    
    
    
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
           let client_id = (self.client?.id ?? "").description
           
           WebServiceManager.sharedInstance.callAPI(
            // "ec0f4840ccc34177821f1952"
               apiPath: .getClientCarePlanAss(clientId: client_id),
               method: .get,
               params: [:],
               isAuthenticate: true,
               model: CarePlanResponse.self   // 👈 अब Custom Model
           ) { response, successMsg in
               switch response {
               case .success(let data):
                   DispatchQueue.main.async { [weak self] in
                       if data.statusCode == 200 {
                         //  print("sections count :- ",self?.sections.count)
                         //  print("✅ CarePlan Data:", data)
                           // 👉 JSON format में print करने के लिए:
                                        if let jsonData = try? JSONEncoder().encode(data),
                                           let jsonString = String(data: jsonData, encoding: .utf8) {
                                          //  print("📦 CarePlan JSON:\n\(jsonString)")
                                        }
                           self?.carePlanData = data.data
                   self?.sections = self?.carePlanData.first?.toSections() ?? []
                           self?.main_tableView.reloadData()
                           self?.main_tableView.layoutSubviews()
                       } else {
                           self?.view.makeToast(data.message)
                       }
                   }
               case .failure(let error):
                   DispatchQueue.main.async { [weak self] in
                       self?.view.makeToast(error.localizedDescription)
                   }
               }
           }
       }
    
//    private func getPlanCare_APICall() {
//
//           // CustomLoader.shared.showLoader(on: self.view)
//            let client_id = (self.client?.id ?? "").description
//
//            WebServiceManager.sharedInstance.callAPI(apiPath: .getClientCarePlanAss(clientId: client_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[[String: CodableValue]]>.self) { response, successMsg in
//            //    CustomLoader.shared.hideLoader()
//                switch response {
//                case .success(let data):
//                    DispatchQueue.main.async {[weak self] in
//                        if data.statusCode == 200{
//                            if let d = data.data?.first{
//                                print("📦 API FULL RESPONSE:", response)   // पूरा raw response
//
//                                for (key,value) in d{
//                                    if let value:[String:Any] = value.value as? [String:Any],!value.keys.isEmpty{
//                                        var temp:MyCustomListModel = MyCustomListModel()
//                                        temp.title = key.addSpaceBeforeUppercase()
//                                        temp.key = key
//
//                                        let questionKeys = value.keys.filter { $0.hasPrefix("questions_name_") }
//                                        var l:[MyPopupListModel] = []
//                                        for key in questionKeys {
//                                            if let question = (value[key] as? CodableValue)?.value as? String {
//                                                let index = key.replacingOccurrences(of: "questions_name_", with: "")
//                                                let statusKey = "status_\(index)"
//                                                let commentKey = "comment_\(index)"
//                                                let comment = (value[commentKey] as? CodableValue)?.value as? String ?? "N/A"
//                                                let status = (value[statusKey] as? CodableValue)?.value as? String ?? comment
//                                                let q = question.replacingOccurrences(of: "<name>", with: self?.client?.fullName ?? "")//.replacingOccurrences(of: "<agency name>", with: UserDetails.shared.loginModel?.admin ?? "")
//                                                l.append(MyPopupListModel(title: q,value: status))
//                                            }
//                                        }
//                                        temp.value = l
//                                        self?.list.append(temp)
//                                    }
//                                }
//                                self?.list = self?.list.sorted{$0.title < $1.title} ?? []
//                            }
//                            self?.carePlanTableView.reloadData()
//                            self?.carePlanTableView.layoutSubviews()
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

                        // signatures
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
        self.main_tableView.reloadData()
        self.main_tableView.layoutSubviews()
        }
    

    }

