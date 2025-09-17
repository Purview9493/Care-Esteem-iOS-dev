//
//  Document2VC.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 21/08/25.
//

import UIKit

class Document2VC: UIViewController {

    @IBOutlet weak var stackTopSpaceConstraints: NSLayoutConstraint!
    @IBOutlet weak var lbl_Header: UILabel!
    @IBOutlet weak var doctableview: UITableView!
    
    @IBOutlet weak var view_Header: AGView!
    @IBOutlet weak var stackView: UIStackView!
    var expandedIndex: IndexPath?
    var docArray: [Documents] = []
    var expendedArray: [Bool] = []
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_Header.layer.cornerRadius = 20 // jitna radius chahiye
        view_Header.layer.masksToBounds = true
        view_Header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        self.lbl_Header.font = UIFont(name: "RobotoSlab-Bold", size: 16)
        
        for _ in docArray {
            expendedArray.append(false)
        }
        if docArray.count == 1 {
                    stackTopSpaceConstraints.constant = 500
                } else if docArray.count == 2 {
                    stackTopSpaceConstraints.constant = 400
                } else if docArray.count == 3{
                    stackTopSpaceConstraints.constant = 300
                } else if docArray.count == 4{
                    stackTopSpaceConstraints.constant = 200
                } else if docArray.count == 5{
                    stackTopSpaceConstraints.constant = 200
                } else if docArray.count == 6{
                    stackTopSpaceConstraints.constant = 100
                }else{
                    stackTopSpaceConstraints.constant = 200
                }
    }
    
 
    @IBAction func tapOnCrossButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @objc func tapEyeButton(sender: UIButton) {
            let row = sender.tag  // button ke tag se row mil gaya
            guard row < docArray.count else { return }
            
            let doc = docArray[row]
            guard let firstDoc = doc.attachDocument.first else {
                print("No document available")
                return
            }
            
            self.dismiss(animated: true) {
                let vc = Storyboard.Clients.instantiateViewController(withViewClass: WebViewController.self)
                vc.url = firstDoc.url
                
                if let topVC = AppDelegate.shared.topViewController(),
                   let navController = topVC.navigationController {
                    navController.pushViewController(vc, animated: true)
                }
            }
        }
    }


extension Document2VC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as! DocumentTableViewCell
        let doc = docArray[indexPath.row]
        
        cell.lbl1.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        cell.lbl2.font = UIFont(name: "RobotoSlab-Regular", size: 11)
        cell.lbl3.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        cell.lbl_description.font = UIFont(name: "RobotoSlab-Regular", size: 14)
        cell.lbl_description.text = (doc.attachDocument.description.isEmpty == false
                                     ? doc.attachDocument.description
                                     : "No Name")

//        cell.lbl_name.text = (doc.documentName.isEmpty == false
//                              ? doc.additionalInfo
//                              : "No Name")
        cell.lbl_name.text = doc.documentName

        cell.lbl2.text = (doc.documentName.isEmpty == false
                          ? doc.documentName
                          : "No Name")

        cell.isExpanded = (expandedIndex == indexPath)
        cell.btn_eye.tag = indexPath.row
      
        cell.btn_eye.addTarget(self, action: #selector(tapEyeButton), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if expandedIndex == indexPath {
            expandedIndex = nil
        } else {
            expandedIndex = indexPath
        }
        
        tableView.reloadData()
    }
}

