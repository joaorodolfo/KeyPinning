//
//  ViewController.swift
//  CertPinning
//
//  Created by Chia Wei Zheng Terry on 6/1/22.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet var bankbutton: UIButton!
    @IBOutlet var appleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bankAction(_ sender: Any) {
        guard let url = URL(string: "https://www.dbs.com.sg") else { return }
        ServiceManager().callAPI(withURL: url) { message in
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func appleAction(_ sender: Any) {
        guard let url = URL(string: "https://apple.com") else { return }
        ServiceManager().callAPI(withURL: url) { message in
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func callTestManualPinning() {
        guard let url = URL(string: "https://www.google.co.uk") else { return }
        ServiceManager().callAPI(withURL: url, isCertificatePinning: false) { (message) in
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

