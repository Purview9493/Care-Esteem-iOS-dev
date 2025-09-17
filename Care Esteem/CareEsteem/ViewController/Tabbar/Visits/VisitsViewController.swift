//
//  VisitsViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//
import UIKit
import CoreLocation

var notificationCount:Int = 0

enum VisitType {
    case completed
    case notcompleted
    case onging
    case upcoming
    case none
}
struct VisitsSectionModel {
    var title:String = ""
    var type:VisitType = .none
    var isExpand:Bool = false
    var data:[VisitsModel] = []
}
class VisitsViewController: UIViewController {
    
    @IBOutlet weak var tableView: AGTableView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btnPrev: AGButton!
    @IBOutlet weak var btnNext: AGButton!
    @IBOutlet weak var viewDate1: AGView!
    @IBOutlet weak var viewDate2: AGView!
    @IBOutlet weak var viewDate3: AGView!
    @IBOutlet weak var viewDate4: AGView!
    @IBOutlet weak var viewDate5: AGView!
    @IBOutlet weak var viewDate6: AGView!
    @IBOutlet weak var viewDate7: AGView!
    @IBOutlet weak var lblDate1: UILabel!
    @IBOutlet weak var lblDate2: UILabel!
    @IBOutlet weak var lblDate3: UILabel!
    @IBOutlet weak var lblDate4: UILabel!
    @IBOutlet weak var lblDate5: UILabel!
    @IBOutlet weak var lblDate6: UILabel!
    @IBOutlet weak var lblDate7: UILabel!
    @IBOutlet weak var btnDate1: AGButton!
    @IBOutlet weak var btnDate2: AGButton!
    @IBOutlet weak var btnDate3: AGButton!
    @IBOutlet weak var btnDate4: AGButton!
    @IBOutlet weak var btnDate5: AGButton!
    @IBOutlet weak var btnDate6: AGButton!
    @IBOutlet weak var btnDate7: AGButton!
    @IBOutlet weak var lblMonth: UILabel!
    
    var time12:String = ""
    var leftCount = 0
    var rightCount = 0
    var list:[VisitsSectionModel] = []//[VisitsSectionModel(title:"Not Completed Visits",type:.notcompleted),VisitsSectionModel(title:"Completed Visits",type:.completed),VisitsSectionModel(title:"Ongoing Visits",type:.onging),VisitsSectionModel(title:"Upcoming Visits",type:.upcoming)]
    var selectedDate:Date = Date()
    var date:Date = Date()
    var startOfWeek:Date = Date()
    let locationManager = CLLocationManager()
    var imageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermission()
        self.btnPrev.action = {
            if self.leftCount == 3 {
                // ✅ Already tapped 3 times → show toast
                self.view.showToastwithImage(message: "Cannot navigate beyond the previous 3 weeks", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
                return
            }
            self.leftCount += 1
            self.rightCount -= 1
            var dateComponent = DateComponents()
            dateComponent.day = -7
            self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()

//            self.setupData()
//            // ✅ after setupData has updated startOfWeek
//                self.selectedDate = self.startOfWeek
//                self.setupData()
            self.updateSelectedDate()
        }
        
        self.btnNext.action = {
            if self.rightCount == 3 {
                // ✅ Already tapped 3 times → show toast
                self.view.showToastwithImage(message: "Cannot navigate beyond the next 3 weeks", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
                return }
            self.rightCount += 1
            self.leftCount -= 1
            var dateComponent = DateComponents()
            dateComponent.day = 7
            self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()
//            self.setupData()
//            // ✅ after setupData has updated startOfWeek
//                self.selectedDate = self.startOfWeek
//                self.setupData()
            self.updateSelectedDate()
//            self.btnDate1.action = {
//                self.selectedDate = self.startOfWeek
//                self.setupData()
               // self.getVisiteList_APICall()
           // }
        }
        

        
        self.btnDate1.action = {
            self.selectedDate = self.startOfWeek
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate2.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 1
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate3.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 2
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate4.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 3
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate5.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 4
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate6.action = {
            var dateComponent = DateComponents()
            dateComponent.day = 5
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        self.btnDate7.action  = {
            var dateComponent = DateComponents()
            dateComponent.day = 6
            self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
            self.setupData()
            self.getVisiteList_APICall()
        }
        imageView = UIImageView(frame: CGRect(x: 90, y: tableView.frame.origin.y, width:  self.view.frame.width - 180, height:  tableView.frame.height - 100))
        imageView?.isHidden = true
        imageView?.image = UIImage(named: "noData")
        imageView?.contentMode = .scaleAspectFit
        // self.view.addSubview(imageView!)
         
         // do not using force for adding imageview  like this
         
         if let imageView = imageView {
             self.view.addSubview(imageView)
         }
       
    }
        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            requestLocationPermission()
//            self.btnPrev.action = {
//                if self.leftCount == 3 {
//                    // ✅ Already tapped 3 times → show toast
//                    self.view.showToastwithImage(message: "Cannot navigate beyond the previous 3 weeks", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
//                    return
//                }
//                self.leftCount += 1
//                self.rightCount -= 1
//                var dateComponent = DateComponents()
//                dateComponent.day = -7
//                self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()
//
//    //            self.setupData()
//    //            // ✅ after setupData has updated startOfWeek
//    //                self.selectedDate = self.startOfWeek
//    //                self.setupData()
//                self.updateSelectedDate()
//            }
//            
//            self.btnNext.action = {
//                if self.rightCount == 3 {
//                    // ✅ Already tapped 3 times → show toast
//                    self.view.showToastwithImage(message: "Cannot navigate beyond the next 3 weeks", image: UIImage(systemName: "info.circle"), textColor: .white, backgroundColor: UIColor(named: "appYellow"))
//                    return }
//                self.rightCount += 1
//                self.leftCount -= 1
//                var dateComponent = DateComponents()
//                dateComponent.day = 7
//                self.date = Calendar.current.date(byAdding: dateComponent, to: self.date) ?? Date()
//    //            self.setupData()
//    //            // ✅ after setupData has updated startOfWeek
//    //                self.selectedDate = self.startOfWeek
//    //                self.setupData()
//                self.updateSelectedDate()
//    //            self.btnDate1.action = {
//    //                self.selectedDate = self.startOfWeek
//    //                self.setupData()
//                   // self.getVisiteList_APICall()
//               // }
//            }
//            
//
//            
//            self.btnDate1.action = {
//                self.selectedDate = self.startOfWeek
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate2.action = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 1
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate3.action = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 2
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate4.action = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 3
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate5.action = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 4
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate6.action = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 5
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            self.btnDate7.action  = {
//                var dateComponent = DateComponents()
//                dateComponent.day = 6
//                self.selectedDate = Calendar.current.date(byAdding: dateComponent, to: self.startOfWeek) ?? Date()
//                self.setupData()
//                self.getVisiteList_APICall()
//            }
//            imageView = UIImageView(frame: CGRect(x: 90, y: tableView.frame.origin.y, width:  self.view.frame.width - 180, height:  tableView.frame.height - 100))
//            imageView?.isHidden = true
//            imageView?.image = UIImage(named: "noData")
//            imageView?.contentMode = .scaleAspectFit
//            // self.view.addSubview(imageView!)
//             
//             // do not using force for adding imageview  like this
//             
//             if let imageView = imageView {
//                 self.view.addSubview(imageView)
//             }
//           
//        }
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            if let ongoingIndex = list.firstIndex(where: { $0.type == .completed }) {
//                    list[ongoingIndex].isExpand = false
//                    UIView.performWithoutAnimation {
//                        tableView.reloadData()
//                        tableView.layoutIfNeeded()
//                    }
//                }
//            
//             getNotoficationList_APICall()
//             let stackview: UIStackView = (self.view.viewWithTag(3) as? UIStackView)!
//             let spacing = (self.view.frame.width - 40 - 36 * 7) / 6
//             stackview.spacing = spacing
//             navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//             self.scroll.pullToRefreshScroll = { pull in
//                 self.imageView?.isHidden = true
//                // self.getVisiteList_APICall()
//                 DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        
//                     self.getVisiteList_APICall()
//                     }
//
//             }
//             
//            
//             selectedDate = Date()
//             date = Date()
//             self.setupData()
//           
//         
//            
//             print("---- Check Visit Reload ----")
//           // getNotoficationList_APICall()
//           
//    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
//    //            self?.getVisiteList_APICall()
//    //        })
//        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotoficationList_APICall()
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
        
        let stackview: UIStackView = (self.view.viewWithTag(3) as? UIStackView)!
        let spacing = (self.view.frame.width - 40 - 36 * 7) / 6
        stackview.spacing = spacing
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.scroll.pullToRefreshScroll = { pull in
            self.imageView?.isHidden = true
            // self.getVisiteList_APICall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.getVisiteList_APICall()
            }
            
        }
        
        
        selectedDate = Date()
        date = Date()
        self.setupData()
        
        
        
        print("---- Check Visit Reload ----")
        // getNotoficationList_APICall()
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
        //            self?.getVisiteList_APICall()
        //        })
    }
    
    @objc func updateNotificationCount() {
           // print("App moved to foreground – call API here")
            getNotoficationList_APICall()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            NotificationCenter.default.removeObserver(self, name: .updateCount, object: nil)
               NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
           }
//        func requestLocationPermission() {
//            // Ask user for permission
//            locationManager.requestWhenInUseAuthorization()
//            
//            // OR if you need background updates
//            // locationManager.requestAlwaysAuthorization()
//        }
//        func updateSelectedDate() {
//           self.setupData()
//           
//           // Check if current week contains today
//           let today = Date()
//           let calendar = Calendar.current
//           
//           if calendar.isDate(today, equalTo: self.startOfWeek, toGranularity: .weekOfYear) {
//               // ✅ Select today if it's in this week
//               self.selectedDate = today
//           } else {
//               // ✅ Otherwise select Monday (startOfWeek)
//               self.selectedDate = self.startOfWeek
//           }
//           
//           self.setupData()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
//                self?.getVisiteList_APICall()
//            })
//       }
//        func setupData() {
//            let views = [viewDate1, viewDate2, viewDate3, viewDate4, viewDate5, viewDate6, viewDate7]
//            let labels = [lblDate1, lblDate2, lblDate3, lblDate4, lblDate5, lblDate6, lblDate7]
//            
//            for view in views {
//                setupUnselected(view: view!)
//            }
//            
//            // Find the Sunday of the current week
//            let calendar = Calendar.current
//            let weekday = calendar.component(.weekday, from: self.date)
//            // Adjust startOfWeek to Monday
//            let daysFromMonday = (weekday + 5) % 7
//            self.startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: self.date)!
//
//          //  self.startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: self.date)!
//
//            for i in 0..<7 {
//                if let newDate = calendar.date(byAdding: .day, value: i, to: self.startOfWeek) {
//                    let day = convertDateToString(date: newDate, format: "EEE", timeZone: TimeZone(identifier: "Europe/London"))
//                    
//                    let date = convertDateToString(date: newDate, format: "dd", timeZone: TimeZone(identifier: "Europe/London"))
//                    labels[i]?.text = day.prefix(2) + "\n\n" + date
//                    labels[i]?.font = UIFont.robotoSlab(.regular, size: 12)
//                   
//                    if calendar.isDate(newDate, inSameDayAs: self.selectedDate) {
//                        print("Day :- ",selectedDate)
//                        print("Date :- ",newDate)
//                        setupSelected(view: views[i]!)
//                    } else {
//                        print("Error Day :- ",selectedDate)
//                        print("Error Date :- ",newDate)
//                    }
//                }
//            }
//            
//            if let endDate = Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek) {
//                lblMonth.text = convertDateToString(date: self.startOfWeek, format: "MMMM dd", timeZone: TimeZone(identifier: "Europe/London")) + " to " + convertDateToString(date: endDate, format: "MMMM dd yyyy", timeZone: TimeZone(identifier: "Europe/London"))
//            }
//        }

    func requestLocationPermission() {
        // Ask user for permission
        locationManager.requestWhenInUseAuthorization()
        
        // OR if you need background updates
        // locationManager.requestAlwaysAuthorization()
    }
    func updateSelectedDate() {
       self.setupData()
       
       // Check if current week contains today
       let today = Date()
       let calendar = Calendar.current
       
       if calendar.isDate(today, equalTo: self.startOfWeek, toGranularity: .weekOfYear) {
           // ✅ Select today if it's in this week
           self.selectedDate = today
       } else {
           // ✅ Otherwise select Monday (startOfWeek)
           self.selectedDate = self.startOfWeek
       }
       
       self.setupData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {[weak self] in
            self?.getVisiteList_APICall()
        })
   }
    func setupData() {
        let views = [viewDate1, viewDate2, viewDate3, viewDate4, viewDate5, viewDate6, viewDate7]
        let labels = [lblDate1, lblDate2, lblDate3, lblDate4, lblDate5, lblDate6, lblDate7]
        
        for view in views {
            setupUnselected(view: view!)
        }
        
        // Find the Sunday of the current week
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self.date)
        // Adjust startOfWeek to Monday
        let daysFromMonday = (weekday + 5) % 7
        self.startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: self.date)!

      //  self.startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: self.date)!

        for i in 0..<7 {
            if let newDate = calendar.date(byAdding: .day, value: i, to: self.startOfWeek) {
                let day = convertDateToString(date: newDate, format: "EEE", timeZone: TimeZone(identifier: "Europe/London"))
                
                let date = convertDateToString(date: newDate, format: "dd", timeZone: TimeZone(identifier: "Europe/London"))
                labels[i]?.text = day.prefix(2) + "\n\n" + date
                labels[i]?.font = UIFont.robotoSlab(.regular, size: 12)
               
                if calendar.isDate(newDate, inSameDayAs: self.selectedDate) {
                    print("Day :- ",selectedDate)
                    print("Date :- ",newDate)
                    setupSelected(view: views[i]!)
                } else {
                    print("Error Day :- ",selectedDate)
                    print("Error Date :- ",newDate)
                }
            }
        }
        
        if let endDate = Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek) {
            lblMonth.text = convertDateToString(date: self.startOfWeek, format: "MMMM dd", timeZone: TimeZone(identifier: "Europe/London")) + " to " + convertDateToString(date: endDate, format: "MMMM dd yyyy", timeZone: TimeZone(identifier: "Europe/London"))
        }
    }
        func setupSelected(view:AGView){
            view.backgroundColor = UIColor(named: "appGreen")
            view.borderWidth = 0
            for t in view.subviews{
                if let ttt = t as? UILabel{
                    ttt.textColor = .white
                }
            }
        }
        func setupUnselected(view:AGView){
            view.backgroundColor = .clear
            view.borderWidth = 2
            for t in view.subviews{
                if let ttt = t as? UILabel{
                    ttt.textColor = .black
                }
            }
        }
    }

    extension VisitsViewController:UITableViewDelegate,UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int{
            return self.list.count
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == self.list.count - 1 {
                return self.list[section].data.count
            } else if self.list[section].isExpand {
                return self.list[section].data.count
            } else {
                return 0
            }
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if list[section].data.count == 0 {
                return 0
            }
            if list.count == section + 1 {
                return 0
            }
            return 55
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
            let cell = tableView.dequeueReusableCell(withClassIdentifier: VisitsSectionTableCell.self)
            cell.setupData(model: self.list[section])
            cell.clickHandler = {
                self.list[section].isExpand = !self.list[section].isExpand
                self.tableView.reloadData()
            }
            self.tableView.layoutSubviews()
            return cell
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if self.list[indexPath.section].type == .completed {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: CompletedVisitsTableCell.self,for: indexPath)
                //                cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
                // 🔹 Sort visits before binding
                let sortedList = cell.sortVisitsByStartTime(visits: self.list[indexPath.section].data)
                let visit = sortedList[indexPath.row]
                cell.setupData(model: visit)
                self.tableView.layoutSubviews()
                return cell
            }else if self.list[indexPath.section].type == .onging {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: OngoingVisitsTableCell.self,for: indexPath)
                cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
                self.tableView.layoutSubviews()
                return cell
            }else if self.list[indexPath.section].type == .upcoming {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: UpcomingVisitsTableCell.self,for: indexPath)
                cell.ongoingCount = self.list.first { $0.type == .onging }?.data.count ?? 0
                if indexPath.row == self.list[indexPath.section].data.count - 1 {
                    cell.setupData(model: self.list[indexPath.section].data[indexPath.row],
                                   isLast: true)
                } else {
                    cell.setupData(model: self.list[indexPath.section].data[indexPath.row],
                                   isLast: false, placeID: self.list[indexPath.section].data[indexPath.row + 1].placeID)
                }
               
                self.tableView.layoutSubviews()
                return cell
            }else if self.list[indexPath.section].type == .notcompleted {
                let cell = tableView.dequeueReusableCell(withClassIdentifier: NotCompletedVisitsTableCell.self,for: indexPath)
                cell.setupData(model: self.list[indexPath.section].data[indexPath.row])
                self.tableView.layoutSubviews()
                return cell
            }else{
                return UITableViewCell()
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if self.list[indexPath.section].type == .onging{
                if self.list[indexPath.section].data[indexPath.row].visitType == "Unscheduled"{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                    vc.visit =  self.list[indexPath.section].data[indexPath.row]
                    vc.visitType = self.list[indexPath.section].type
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                    vc.visit =  self.list[indexPath.section].data[indexPath.row]
                    vc.visitType = self.list[indexPath.section].type
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if self.list[indexPath.section].type == .completed {
                if self.list[indexPath.section].data[indexPath.row].visitType == "Unscheduled"{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: UnscheduleViewController.self)
                    vc.visit =  self.list[indexPath.section].data[indexPath.row]
                    vc.visitType = self.list[indexPath.section].type
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = Storyboard.Visits.instantiateViewController(withViewClass: ScheduleViewController.self)
                    vc.visit =  self.list[indexPath.section].data[indexPath.row]
                    vc.visitType = self.list[indexPath.section].type
                    vc.time1 = self.time12
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }


    // MARK: API Call
    extension VisitsViewController {
        
        func alert(model: [VisitsModel]) {
            return
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(model)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON Output:")
                    print(jsonString)
                    
                    let alert = UIAlertController(title: "This text share with us", message: jsonString, preferredStyle: .alert)
                    
                    // Copy action
                    let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
                        UIPasteboard.general.string = jsonString
                        print("Text copied to clipboard")
                    }
                    
                    // Cancel action
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    alert.addAction(copyAction)
                    alert.addAction(cancelAction)
                    
                    present(alert, animated: true)
                }
            } catch {
                print("Error encoding JSON: \(error.localizedDescription)")
            }
        }
        
        private func getVisiteList_APICall() {
            let londonTimeZone = TimeZone(identifier: "Europe/London")!
            
            let selectedDateString = convertDateToString(
                date: selectedDate,
                format: "yyyy-MM-dd",
                timeZone: londonTimeZone
            )
           // CustomLoader.shared.showLoader(on: self.view)
            WebServiceManager.sharedInstance.callAPI(
                apiPath: .getVisitList(userId: UserDetails.shared.user_id),
                queryParams: [APIParameters.Visits.visitDate: selectedDateString],
                method: .get,
                params: [:],
                isAuthenticate: true,
                model: CommonRespons<[VisitsModel]>.self
                
            ) { response, successMsg in
            //    CustomLoader.shared.hideLoader()
               // self.imageView?.isHidden = true
                self.scroll.endRefreshing()
                
                switch response {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        if data.statusCode == 200 {
                            var completed: [VisitsModel] = []
                            var notCompleted: [VisitsModel] = []
                            var ongoing: [VisitsModel] = []
                            var upcoming: [VisitsModel] = []
                            print("✅ Raw Visit List Data:")
                     

                            for t in data.data ?? [] {
                                let encoder = JSONEncoder()
                                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                                
                                if let jsonData = try? encoder.encode(data),
                                   let jsonString = String(data: jsonData, encoding: .utf8) {
                                    print("✅ Full Visit List (Pretty Printed):\n\(jsonString)")
                                }

                                let hasStart = !(t.actualStartTime?.first ?? "").isEmpty
                                let hasEnd = !(t.actualEndTime?.first ?? "").isEmpty
                                
                                if !hasStart && !hasEnd {
                                    let datetime = "\(t.visitDate ?? "") \(t.plannedStartTime ?? "")"
                                    if let createdAt = convertStringToDatee(
                                        dateString: datetime,
                                        format: "yyyy-MM-dd HH:mm",
                                        timeZone: TimeZone(identifier: "Europe/London")
                                    ) {
                                        let now = Date()
                                        let hoursDifference = Calendar.current.dateComponents(
                                            [.hour],
                                            from: createdAt,
                                            to: now
                                        ).hour ?? 0
                                        
                                        if hoursDifference >= 4 {
                                            notCompleted.append(t)
                                        } else {
                                            upcoming.append(t)
                                        }
                                    } else {
                                        upcoming.append(t)
                                    }
                                } else if hasStart && !hasEnd {
                                    ongoing.append(t)
                                } else if hasStart && hasEnd {
                                    completed.append(t)
                                }
                            }
                            
                            let currentC = self.list.first { $0.type == .completed }?.isExpand ?? false
                            let currentO = self.list.first { $0.type == .onging }?.isExpand ?? false
                            let currentU = self.list.first { $0.type == .upcoming }?.isExpand ?? false
                            let currentNC = self.list.first { $0.type == .notcompleted }?.isExpand ?? false
                            
                            self.list = [
                                VisitsSectionModel(title: "Not Completed Visits", type: .notcompleted, isExpand: currentNC, data: notCompleted),
                                VisitsSectionModel(title: "Completed Visits", type: .completed, isExpand: currentC, data: completed),
                                VisitsSectionModel(title: "Ongoing Visits", type: .onging, isExpand: currentO, data: ongoing),
                                VisitsSectionModel(title: "Upcoming Visits", type: .upcoming, isExpand: currentU, data: upcoming)
                            ]
                            
                            self.alert(model: upcoming)
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                            self.imageView?.isHidden = true
                            
                            if upcoming.isEmpty && ongoing.isEmpty && completed.isEmpty && notCompleted.isEmpty {
                                self.tableView.isHidden = true
                                self.imageView?.isHidden = false
                            }
                        } else {
                           // self.view.makeToast(data.message ?? "")
                            self.list = []
                            self.tableView.reloadData()
                            self.tableView.isHidden = self.list.isEmpty
                            self.imageView?.isHidden = !self.list.isEmpty
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.view.makeToast(error.localizedDescription)
                        self.list = []
                        self.tableView.reloadData()
                        self.tableView.isHidden = self.list.isEmpty
                        self.imageView?.isHidden = !self.list.isEmpty
                    }
                }
            }
        }
        func convertDateToStringg(date: Date, format: String, timeZone: TimeZone? = nil) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone ?? TimeZone(identifier: "Europe/London")
            return formatter.string(from: date)
        }

        func convertStringToDatee(dateString: String, format: String, timeZone: TimeZone? = nil) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone ?? TimeZone(identifier: "Europe/London")
            return formatter.date(from: dateString)
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
                               // You can include an optional userInfo dictionary to pass data
                            NotificationCenter.default.post(name: .customNotification,
                                                            object: nil,
                                                            userInfo: ["message": "Data from the sender!",
                                                                       "count": array.count])
                            self.updateSelectedDate()
                          

                        } else {
                            self.updateSelectedDate()
                            print("Error Code :-",data.statusCode)
                        }
                    }

                case .failure(_):
                    print("no code")
                }
            }
        }

    }
