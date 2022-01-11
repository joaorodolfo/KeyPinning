//
//  ServiceManager.swift
//  CertPinning
//
//  Created by Chia Wei Zheng Terry on 6/1/22.
//

import Foundation

class ServiceManager : NSObject {
    
    override init() {
        super.init()
    }
    
    
    
    private var isCertificatePinning: Bool = false
    func callAPI(withURL url: URL, isCertificatePinning: Bool, completion: @escaping (String) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        self.isCertificatePinning = isCertificatePinning
        var responseMessage = ""
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!)")
                responseMessage = "Pinning failed"
            } else if data != nil {
                let str = String(decoding: data!, as: UTF8.self)
                print("Received data:\n\(str)")
                if isCertificatePinning {
                    responseMessage = "Certificate pinning is successfully completed"
                }else {
                    responseMessage = "Public key pinning is successfully completed"
                }
            }
            DispatchQueue.main.async {
                completion(responseMessage)
            }
        }
        task.resume()
    }
    
    
    func callAPI(withURL url: URL, completion: @escaping (String) -> Void) {
                
        // URL session that doesn't cache.
        let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        print(url.description)
        let task = urlSession.dataTask(with: url) { imageData, response, error in
            DispatchQueue.main.async {
                // Handle client errors
                if let error = error {
                    completion(error.localizedDescription)
                   return
                }
                        
                // Handle server errors
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                          completion(response.debugDescription)
                return
                }
                        
                completion(httpResponse.statusCode.description)
            }
        }
                
        task.resume()
    }
}


extension ServiceManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return
        }
        if self.isCertificatePinning {
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            // SSL Policies for domain name check
            let policy = NSMutableArray()
            policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
            //evaluate server certifiacte
            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
            //Local and Remote certificate Data
            let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
            //let LocalCertificate = Bundle.main.path(forResource: "github.com", ofType: "cer")
            let pathToCertificate = Bundle.main.path(forResource: "google", ofType: "cer")
            let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
            //Compare certificates
            if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
                let credential:URLCredential =  URLCredential(trust:serverTrust)
                print("Certificate pinning is successfully completed")
                completionHandler(.useCredential,credential)
            }
            else {
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
