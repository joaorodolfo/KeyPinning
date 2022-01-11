//
//  ViewController.swift
//  CertPinning
//
//  Created by Chia Wei Zheng Terry on 6/1/22.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        callTestPlistPinning()
    }
    
    func callTestManualPinning() {
        guard let url = URL(string: "https://www.google.co.uk") else { return }
        ServiceManager().callAPI(withURL: url, isCertificatePinning: false) { (message) in
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func callTestPlistPinning() {
        guard let url = URL(string: "https://example.org") else { return }
        ServiceManager().callAPI(withURL: url) { message in
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

