//
//  WebViewController.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 23/07/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var url: String = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.alwaysBounceHorizontal = false
        setupFloatingCloseButton()
    }
    
    func setupFloatingCloseButton() {
        let button = UIButton(type: .custom)
        
        // Set image
        if let image = UIImage(named: "close") {
            button.setImage(image, for: .normal)
        }
        
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        // Shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        
        // Action
        button.addTarget(self, action: #selector(tapCrossButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        // AutoLayout constraints for top-right, 100pt from top
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 65),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        // Bounce animation
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
            button.transform = .identity
        }, completion: nil)
    }

    
    @objc func tapCrossButton(_ sender: Any) {
            // Agar push hua tha navigation stack me
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                // Agar modal se present hua tha
                self.dismiss(animated: true, completion: nil)
            }
        }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CustomLoader.shared.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        CustomLoader.shared.showLoader(on: self.view)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CustomLoader.shared.hideLoader()
    }
    @IBAction func tapCroosButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}

