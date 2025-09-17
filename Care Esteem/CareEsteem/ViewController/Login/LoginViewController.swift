//
//  LoginViewController.swift
//  careesteem
//
//  Created by Gaurav Gudaliya on 07/03/25.
//

import UIKit
import SKCountryPicker
import DropDown

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dropIV: UIImageView!
    @IBOutlet weak var txtMobile:UITextField!
    @IBOutlet weak var lblCountry:UILabel!
    @IBOutlet weak var btnRequestOTP:AGButton!
    @IBOutlet weak var btnCountry:AGButton!
    @IBOutlet weak var viewCountry:AGView!
    var selectedCounty:Country?
    var listCountry:[Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "sep")
        UserDefaults.standard.synchronize()
        self.listCountry = self.loadJSONFromFile() ?? []
        self.selectedCounty = self.listCountry.first(where: { c in
            c.countryCode == "44"
        }) ?? self.listCountry.first(where: { c in
            c.countryCode == "91"
        })
       
        self.setSelectedCountry()
        self.btnRequestOTP.disbledButton()
        #if DEBUG
        self.txtMobile.text = ""
        self.btnRequestOTP.enableButton()
        #endif
     
        self.txtMobile.delegate = self
        self.btnRequestOTP.action = {
            self.sendOTP_APICall()
        }
        self.btnCountry.action = {
            let dropDown = DropDown()
            dropDown.anchorView = self.viewCountry // Attach dropdown to button
            dropDown.dataSource = self.listCountry.map{"\($0.emoji) \($0.country) (+\($0.countryCode))"} // Set dropdown items
            dropDown.direction = .any // Show dropdown below the button
            dropDown.selectionAction = { (index: Int, item: String) in
                self.selectedCounty = self.listCountry[index]
                self.setSelectedCountry()
                self.dropIV.image = UIImage(systemName: "chevron.down")
            }
            dropDown.cancelAction = { [weak self] in
                self?.dropIV.image = UIImage(systemName: "chevron.down")
            }
            dropDown.show()
                self.dropIV.image = UIImage(systemName: "chevron.up")
            //            // Present country picker without `Section Control` enabled
//            CountryPickerWithSectionViewController.presentController(on: self, configuration: { countryController in
//                countryController.configuration.flagStyle = .corner
//                countryController.configuration.isCountryFlagHidden = false
//                countryController.configuration.isCountryDialHidden = false
//                countryController.favoriteCountriesLocaleIdentifiers = ["IN","US","MV"]
//            }) { [weak self] country in
//                guard let self = self else { return }
//                self.lblCountry.text = country.dialingCode
//            }
        }
    }
    
    func setSelectedCountry(){
        if (selectedCounty?.countryCode.count ?? 0) > 0{
            self.lblCountry.text = " " + (selectedCounty?.emoji ?? "") + " +"  + (selectedCounty?.countryCode.description ?? "")
        }else{
            self.lblCountry.text = selectedCounty?.countryCode.description
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if str.count > 0{
            self.btnRequestOTP.enableButton()
        }else{
            self.btnRequestOTP.disbledButton()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func loadJSONFromFile() -> [Country]? {
        guard let url = Bundle.main.url(forResource: "country", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let countries = try decoder.decode([Country].self, from: data)
            return countries
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
}

// MARK: API Call
extension LoginViewController {
    
    private func sendOTP_APICall() {
        
        let params = [APIParameters.Login.contactNumber: self.txtMobile.text ?? "",
                      APIParameters.Login.telephoneCodes: self.selectedCounty?.id ?? 0,
        ] as [String : Any]
        CustomLoader.shared.showLoader(on: self.view)
        WebServiceManager.sharedInstance.callAPI(apiPath: .sendOtpUserLogin,
                                                 method: .post,
                                                 params: params,
                                                 isAuthenticate: false,
                                                 model: CommonRespons<LoginUserModel>.self) { response, successMsg in
            CustomLoader.shared.hideLoader()
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200{
//                        var style = ToastStyle()
//                        style.backgroundColor = UIColor(named: "appGreen") ?? .green
//                        AppDelegate.shared.window?.makeToast(data.message ?? "",style: style)
                        AppDelegate.shared.window?.showToastwithImage(message: data.message ?? "", image: UIImage(named: "tick_toast"), textColor: .white, backgroundColor: .systemGreen)
                        let vc = Storyboard.Login.instantiateViewController(withViewClass: SecurityCodeViewController.self)
                        vc.tagg = "first"
                        vc.userModel = data.data
                        vc.mobile = self?.txtMobile.text ?? ""
                        vc.countryID = self?.selectedCounty?.id ?? ""
                        vc.countyCode = self?.selectedCounty?.countryCode ?? ""
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else if  data.statusCode == 409{
                      //  var style = ToastStyle()
                      //  style.backgroundColor = UIColor(named: "appRed") ?? .red
                      //  AppDelegate.shared.window?.makeToast(data.message ?? "", style: style)
                        AppDelegate.shared.window?.showToastwithImage(message: data.message ?? "", image: UIImage(named: "cross_toast"), textColor: .white, backgroundColor: UIColor(named: "appRed"))

                    }
                    else{
                        self?.view.makeToast(data.message ?? "")
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
