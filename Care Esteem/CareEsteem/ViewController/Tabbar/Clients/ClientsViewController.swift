//
//  ClientsViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit

class ClientsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_cancel: UIButton!
    
    var list:[ClientModel] = []
       var filterList:[ClientModel] = []
       var searchActive = false

       override func viewDidLoad() {
           super.viewDidLoad()
           navigationController?.interactivePopGestureRecognizer?.isEnabled = false
           btn_cancel.isHidden = true
           tf.font = UIFont.robotoSlab(.regular, size: 14)
           
           setupSearchTextField()
           setupTableView()
           
           getClientList_APICall()
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
       
       // MARK: - Setup
       private func setupSearchTextField() {
           tf.delegate = self
//
           tf.clipsToBounds = true
           tf.leftViewMode = .always
           
           let imagView = UIImageView(frame: CGRect(x: 11, y: 7, width: 14, height: 14))
           imagView.image = UIImage(named: "searchIcon")
           let bg = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
           bg.addSubview(imagView)
           tf.leftView = bg
       }
       
       private func setupTableView() {
           tableView.pullToRefreshScroll = { pull in
               pull.endRefreshing()
               self.getClientList_APICall()
           }
       }
       
       // MARK: - Cancel Search
       @IBAction func tapOnSearchCancelButton(_ sender: UIButton) {
           tf.text = ""
           btn_cancel.isHidden = true
           searchActive = false
           filterList.removeAll()
           tableView.reloadData()
           updateNoDataView()
       }
       
       private func updateNoDataView() {
           let dataCount = searchActive ? filterList.count : list.count
           noDataView.isHidden = dataCount > 0
           tableView.isHidden = dataCount == 0
       }
   }

   // MARK: - TableView
   extension ClientsViewController:UITableViewDelegate,UITableViewDataSource{
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return searchActive ? filterList.count : list.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withClassIdentifier: ClientListTableViewCell.self,for: indexPath)
           let model = searchActive ? filterList[indexPath.row] : list[indexPath.row]
           cell.setupData(model: model)
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let vc = Storyboard.Clients.instantiateViewController(withViewClass: ClientDetail2VC.self)
           vc.client =  searchActive ? filterList[indexPath.row] : list[indexPath.row]
           self.navigationController?.pushViewController(vc, animated: true)
       }
   }

   // MARK: - API Call
   extension ClientsViewController {
       
       private func getClientList_APICall() {
           searchActive = false
           tf.text = ""
           btn_cancel.isHidden = true
           CustomLoader.shared.showLoader(on: self.view)
           
           WebServiceManager.sharedInstance.callAPI(
               apiPath: .getAllClients,
               method: .get,
               params: [:],
               isAuthenticate: true,
               model: CommonRespons<[ClientModel]>.self
           ) { response, successMsg in
               CustomLoader.shared.hideLoader()
               DispatchQueue.main.async { [weak self] in
                   guard let self = self else { return }
                   
                   switch response {
                   case .success(let data):
                       if data.statusCode == 200 {
                           self.list = data.data ?? []
                           self.getNotoficationList_APICall()
                           self.tableView.reloadData()
                       } else {
                           self.view.makeToast(data.message ?? "")
                       }
                   case .failure(let error):
                       self.view.makeToast(error.localizedDescription)
                   }
                   self.updateNoDataView()
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



   // MARK: - Search
   extension ClientsViewController {
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           var searchText = textField.text ?? ""
           if let r = Range(range, in: searchText) {
               searchText.removeSubrange(r)
           }
           searchText.insert(contentsOf: string, at: searchText.index(searchText.startIndex, offsetBy: range.location))
           
           btn_cancel.isHidden = searchText.isEmpty
           searchActive = !searchText.isEmpty
           
           if searchActive {
               filterList = list.filter { $0.fullName?.lowercased().contains(searchText.lowercased()) ?? false }
           } else {
               filterList.removeAll()
           }
           
           tableView.reloadData()
           updateNoDataView()
           return true
       }
   }
    
    
//    var list:[ClientModel] = []
//    var filterList:[ClientModel] = []
//    var searchActive = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        btn_cancel.isHidden = true
//        tf.font = UIFont.robotoSlab(.regular, size: 14)
//        //(name: "RobotoSlab-Regular", size: 14)
//        self.getClientList_APICall()
//        textFieldoutLines(txtFld: tf)
//        self.tableView.pullToRefreshScroll = { pull in
//            pull.endRefreshing()
//            self.getClientList_APICall()
//        }
//      //  navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        // Do any additional setup after loading the view.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//     //   self.getClientList_APICall()
//    }
//    
//    @IBAction func tapOnSearchCancelButton(_ sender: UIButton) {
//        
//    }
//    
//    
//    func textFieldoutLines(txtFld: UITextField) {
//        txtFld.delegate = self
//        txtFld.layer.borderWidth = 1
//        txtFld.layer.borderColor = UIColor(named: "appGreen")?.cgColor
//        txtFld.layer.cornerRadius = 5
//        txtFld.clipsToBounds = true
//        txtFld.leftViewMode = .always
//        let imagView = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
//        let image = UIImage(named: "searchIcon")
//        imagView.image = image
//        let bg = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 28))
//        bg.addSubview(imagView)
//        txtFld.leftView = bg
//    }
//}
//extension ClientsViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchActive ? self.filterList.count : self.list.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withClassIdentifier: ClientListTableViewCell.self,for: indexPath)
//        cell.setupData(model: searchActive ? self.filterList[indexPath.row] : self.list[indexPath.row])
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = Storyboard.Clients.instantiateViewController(withViewClass: ClientDetailViewController.self)
//        vc.client =  searchActive ? self.filterList[indexPath.row] : self.list[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//
//// MARK: API Call
//extension ClientsViewController {
//    
//    private func getClientList_APICall() {
//        searchActive = false
//        tf.text = ""
//        CustomLoader.shared.showLoader(on: self.view)
//        WebServiceManager.sharedInstance.callAPI(apiPath: .getAllClients, method: .get, params: [:],isAuthenticate: true, model: CommonRespons<[ClientModel]>.self) { response, successMsg in
//            CustomLoader.shared.hideLoader()
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async {[weak self] in
//                    if data.statusCode == 200{
//                        
//                        self?.list = data.data ?? []
////                        self.list = data.finalData?.filter({ c in
////                            c.id == 234
////                        }) ?? []
//                        self?.tableView.reloadData()
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
//}
//
//extension ClientsViewController {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var search = textField.text ?? ""
//        if let r = Range(range, in: search){
//            search.removeSubrange(r) // it will delete any deleted string.
//        }
//        search.insert(contentsOf: string, at: search.index(search.startIndex, offsetBy: range.location)) // it will insert any text.
//        print(search)
//      
//        searchActive = true
//        filterList = list.filter { $0.fullName?.lowercased().contains(search.lowercased()) ?? false
//        }
//        if search.count == 0 {
//            filterList = list
//        }
//        self.tableView.reloadData()
//        return true
//    }
//
//}
