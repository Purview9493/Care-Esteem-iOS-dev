//
//  AlertsViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class AlertsViewController: UIViewController {

    @IBOutlet weak var lbl_alert: UILabel!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var list:[AlertModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_alert.font = UIFont(name: "RobotoSlab-Regular", size: 16)

//        self.noDataView.isHidden = true
        self.tableView.pullToRefreshScroll = { pull in
            pull.endRefreshing()
            self.getAlertList_APICall()
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAlertList_APICall()
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

        @objc func updateNotificationCount() {
            getNotoficationList_APICall()
        }
    
    @IBAction func btnCreateAlertAction(_ sender:UIButton){
        let vc = Storyboard.Alerts.instantiateViewController(withViewClass: CreateAlertViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension AlertsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: AlertListTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.list[indexPath.row].isExpand = !(self.list[indexPath.row].isExpand ?? false)
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
    }
}



// MARK: API Call
extension AlertsViewController {
    
    private func getAlertList_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getAlertList(alertId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[AlertModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.list = data.data ?? []
                        self?.noDataView.isHidden = !self!.list.isEmpty
                        self?.getNotoficationList_APICall()
                        self?.tableView.reloadData()
                    }else{
                        self?.noDataView.isHidden = !self!.list.isEmpty
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
                           
                          

                        } else {
                            print("Error Code :-",data.statusCode)
                           
                        }
                    }

                case .failure(_):
                    print("no code")
                }
            }
        }
}


