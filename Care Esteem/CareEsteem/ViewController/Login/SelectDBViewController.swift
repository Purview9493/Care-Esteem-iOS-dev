//
//  SelectDBViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 27/04/25.
//

import UIKit

class SelectDBViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hideView: AGView!
    
    var list:[AgencyModel] = []
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideView.isHidden = true
        self.tableView.reloadData()
    }
    @IBAction func backButton(_ sender: Any) {
      //  self.navigationController?.popViewController(animated: true)
        self.hideView.isHidden = false
    }
    
    @IBAction func TapOnExitButton(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func TapOnStayButton(_ sender: Any) {
        self.hideView.isHidden = true
    }
    
}

extension SelectDBViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: DBTableViewCell.self,for: indexPath)
        cell.lblName.text = self.list[indexPath.row].agency_name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.SelectDB_APICall(model: self.list[indexPath.row])
        
    }
    private func SelectDB_APICall(model:AgencyModel) {
        let params = ["contact_number":model.contact_number ?? "","user_id":model.id ?? 0,"agency_id":model.agency_id ?? ""] as [String : Any]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .selectdbname, method: .post, params: params,isAuthenticate: true, model: CommonRespons<[LoginUserModel]>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async {[weak self] in
                    if data.statusCode == 200{
                        UserDetails.shared.loginModel = data.data?.first
                        if (UserDetails.shared.loginModel?.passcode ?? "") == ""{
                            let vc = Storyboard.Login.instantiateViewController(withViewClass: SetYourPinVC.self)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let vc = Storyboard.Login.instantiateViewController(withViewClass: EnterYourPinVC.self)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                       // self?.view.makeToast(data.message ?? "")
                        AppDelegate.shared.window?.showToastwithImage(message: data.message ?? "", image: UIImage(named: "cross_toast"), textColor: .white, backgroundColor: UIColor(named: "appRed"))
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

class DBTableViewCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        
    }
}
