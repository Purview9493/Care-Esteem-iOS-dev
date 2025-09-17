//
//  NotificationViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var appHeaderView: AppHeaderView!
    @IBOutlet weak var btn_clearAll: UIButton!
    @IBOutlet weak var lbl_2: UILabel!
    @IBOutlet weak var lbl_1: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_clearAll: UILabel!
    
    @IBOutlet weak var lbl_header: UILabel!
    var list:[NotificationModel] = []
    var flag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_1.font =  UIFont.robotoSlab(.regular, size: 16)
        self.lbl_2.font =  UIFont.robotoSlab(.regular, size: 16)
        self.lbl_clearAll.font = UIFont.robotoSlab(.regular, size: 15)
        self.lbl_header.font =  UIFont.robotoSlab(.regular, size: 16)
        
        self.noDataView.isHidden = false
        self.lblAttribute()
        
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

        @objc func updateNotificationCount() {
            getNotoficationList_APICall()
        }
    
    func lblAttribute() {
        
        let boldText1 = "notified"
        let boldText2 = "schedule"
        let normalText = "You will be "
        let normalText1 = " if there are any changes to your "
       
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 15, weight: .Regular),
            .foregroundColor: UIColor(named: "appDarkText") ?? .black
        ]
        let normalString = NSMutableAttributedString(string: normalText, attributes: normalAttrs)
        
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.loraFont(size: 15, weight: .Regular),
            .foregroundColor: UIColor(named: "appGreen") ?? .green
        ]
        
        let attributedString1 = NSMutableAttributedString(string: boldText1, attributes: boldAttrs)
        let attributedString2 = NSMutableAttributedString(string: boldText2, attributes: boldAttrs)
        
        normalString.append(attributedString1)
        normalString.append(NSMutableAttributedString(string: normalText1, attributes: normalAttrs))
        normalString.append(attributedString2)
        
        noSubTitle.attributedText = normalString

    }
    
    @IBAction func tapOnClearAllButton(_ sender: UIButton) {
        self.flag = 2
        print("flagamit :-",self.flag)
        let allId = self.list.compactMap { $0.id } ?? []
        print("Ayushi :-",allId)
        if list.count > 0 {
                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                vc.strImage = "notification_alert"
                vc.strTitle = "Clear Notifications"
                vc.strButton = "Yes"
                vc.strCancelButton = "No"
                vc.strMessage = "Are you sure you want to clear all notifications?"
                vc.buttonClickHandler = { [weak self] in
                    print("flag :-",self?.flag)
                    let allIds = self?.list.compactMap { $0.id } ?? []
                    self?.clearNotification_APICall(ids: allIds)
                }
                vc.transitioningDelegate = customTransitioningDelegate
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true)
            } else {
                print("No Data!")
            }
    }
    
}
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: NotificationListTableViewCell.self,for: indexPath)
        cell.setupData(model: self.list[indexPath.row])
        let notification = list[indexPath.row]
        cell.deleteAction = {
            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
            vc.strImage = "notification_alert"
            vc.strTitle = "Clear Notification"
            vc.strButton = "Yes"
            vc.strCancelButton = "No"
            vc.strMessage = "Are you sure you want to clear this notification?"
            vc.buttonClickHandler = {[weak self] in
                guard let self = self else { return }
                flag = 1
                if let id = notification.id {
                    self.clearNotification_APICall(ids: [id])
                }
            }
            vc.transitioningDelegate = customTransitioningDelegate
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
            
          }
        return cell
    }
}

// MARK: API Call
extension NotificationViewController {
    
    private func getNotoficationList_APICall() {
        
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .getallnotifications(userId: UserDetails.shared.user_id), method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[NotificationModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        self?.list = data.data ?? []
                        self?.noDataView.isHidden = !(self?.list.isEmpty ?? false)
                        print("Count :- ",self?.list.count)
                        NotificationCenter.default.post(name: .customNotification,
                                                        object: nil,
                                                        userInfo: ["message": "Data from the sender!",
                                                                   "count": self?.list.count])
                        if self?.flag == 1 {
                            self?.appHeaderView.showBadge(count: self?.list.count ?? 0)
                    } else {
                        print("listcount :-",self?.list.count)
                        self?.appHeaderView.showBadge(count: 0)
                    }
                        self?.lbl_clearAll.isHidden = false
                        self?.tableView.reloadData()
                    }else{
                        self?.noDataView.isHidden = !(self?.list.isEmpty ?? false)
                        self?.lbl_clearAll.isHidden = true
                        
                  
                      //  self?.view.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {[weak self] in
                    self?.noDataView.isHidden = !self!.list.isEmpty
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
    /// Call API to clear notifications
    private func clearNotification_APICall(ids: [String]) {
        guard !ids.isEmpty else { return }
        
        CustomLoader.shared.showLoader(on: self.view)
        
        let body: [String: Any] = [
            "notificationStatus": ids.map { ["id": $0] }
        ]
        print("==> ",body)
        
        WebServiceManager.sharedInstance.callAPI(
            apiPath: .clearNotification(hash_token: ""),
            method: .put,
            params: body,
            isAuthenticate: true,
            model: CommonRespons<[NotificationModel]>.self
        ) { [weak self] response, _ in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.statusCode == 200 {
                        self?.getNotoficationList_APICall()
                        NotificationCenter.default.post(name: .customNotification,
                                                        object: nil,
                                                        userInfo: ["message": "Data from the sender!",
                                                                   "count": 0])
                        AppDelegate.shared.window?.makeToast(data.message ?? "")
                        // Remove cleared notifications from the list
                        self?.list.removeAll { ids.contains($0.id ?? "") }
                        self?.noDataView.isHidden = !(self?.list.isEmpty ?? false)
                        // For manual updates
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(self?.updateNotificationCount),
                            name: .updateCount,
                            object: nil
                        )
                        
                        // For foreground resume
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(self?.updateNotificationCount),
                            name: UIApplication.willEnterForegroundNotification,
                            object: nil
                        )
                        self?.tableView.reloadData()
                        
                    } else {
                        //self?.view.makeToast(data.message ?? "")
                        AppDelegate.shared.window?.makeToast(data.message ?? "")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
    }
}


