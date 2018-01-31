//
//  ViewController.swift
//  window-shopper
//
//  Created by Mark Price on 6/19/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit
import GoogleMobileAds


class MainVC: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var wageTxt: CurrencyTxtField!
    @IBOutlet weak var priceTxt: CurrencyTxtField!
    
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var myBanner: GADBannerView!
    
    /// The CryptoCompare API URL here returns the value of 1 ETH in USD
    let apiURL = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calcBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        calcBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5917804241, blue: 0.0205632858, alpha: 1)
        calcBtn.setTitle("Calculate", for: .normal)
        calcBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        calcBtn.addTarget(self, action: #selector(MainVC.calculate), for: .touchUpInside)
        
        wageTxt.inputAccessoryView = calcBtn
        priceTxt.inputAccessoryView = calcBtn
        
        resultLbl.isHidden = true
        hoursLbl.isHidden = true
        
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        myBanner.adUnitID = "ca-app-pub-8537648223871749/4342729065"
        
        myBanner.rootViewController = self
        myBanner.delegate = self
        
        myBanner.load(request)
        
        // Safely unwrap the API URL since it could be nil
        guard let apiURL = apiURL else {
            return
        }
        
        // Make the GET request for our API URL to get the value NSNumber
        makeValueGETRequest(url: apiURL) { (value) in
            
            // Must update the UI on the main thread since makeValueGetRequest is a background operation
            DispatchQueue.main.async {
                // Set the etherValueLabel with the formatted USD value or "Failed" in the case of failure

                var nonempty = self.formatAsCurrencyString(value: value) ?? "Loading Bitcoin price..."
                if let i  = nonempty.characters.index(of: "$")  {
                    nonempty.remove(at: i)
                }
                
                self.wageTxt.text = nonempty
                
                var nonempty2 = self.wageTxt.text
                if let i  = nonempty2?.characters.index(of: ",")  {
                    nonempty2?.remove(at: i)
                }
                
                self.wageTxt.text = nonempty2
                
                
                //    var nonempty = str
                //    if let i = nonempty.characters.index(of: "$") {
                //    nonempty.remove(at: i)
                //    }
                
                //    nonempty
            }
        }
    }

   
    @objc func calculate() {
        if let wageTxt = wageTxt.text, let priceTxt = priceTxt.text {
            if let wage = Double(wageTxt), let price = Double(priceTxt) {
                view.endEditing(true)
                resultLbl.isHidden = false
                hoursLbl.isHidden = false
                resultLbl.text = "You can have \(Wage.getHours(forWage: wage, andPrice: price)) BTC"
            }
        }
    }

    @IBAction func clearCalculatorPressed(_ sender: Any) {
        resultLbl.isHidden = true
        hoursLbl.isHidden = true
        wageTxt.text = ""
        priceTxt.text = ""
       


    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let share = UIActivityViewController(activityItems: ["You can have \(resultLbl!) BTC. PLEASE SUPPORT THIS APP!!!" ], applicationActivities: nil)
        present(share, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindFromSkillVC(unwindSegue: UIStoryboardSegue) {
    }
    
    /// Takes an API URL and performs a GET request on it to try to get back an NSNumber
    ///
    /// - Parameters:
    ///   - url: The API URL to perform the GET request with
    ///   - completion: Returns the value as an NSNumber, or nil in the case of failure
    private func makeValueGETRequest(url: URL, completion: @escaping (_ value: NSNumber?) -> Void) {
        let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Unwrap the data and make sure that an error wasn't returned
            guard let data = data, error == nil else {
                // If an error was returned set the value in the completion as nil and print the error
                completion(nil)
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                // Unwrap the JSON dictionary and read the USD key which has the value of Ethereum
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                    let value = json["USD"] as? NSNumber else {
                        completion(nil)
                        return
                }
                completion(value)
            } catch  {
                // If we couldn't serialize the JSON set the value in the completion as nil and print the error
                completion(nil)
                print(error.localizedDescription)
            }
        }
        
        request.resume()
    }
    
    /// Takes an optional NSNumber and converts it to USD String
    ///
    /// - Parameter value: The NSNumber to convert to a USD String
    /// - Returns: The USD String or nil in the case of failure
    private func formatAsCurrencyString(value: NSNumber?) -> String? {
        /// Construct a NumberFormatter that uses the US Locale and the currency style
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        
        // Ensure the value is non-nil and we can format it using the numberFormatter, if not return nil
        guard let value = value,
            let formattedCurrencyAmount = formatter.string(from: value) else {
                return nil
        }
        return formattedCurrencyAmount
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        // Safely unwrap the API URL since it could be nil
        guard let apiURL = apiURL else {
            return
        }
        
        // Make the GET request for our API URL to get the value NSNumber
        makeValueGETRequest(url: apiURL) { (value) in
            
            // Must update the UI on the main thread since makeValueGetRequest is a background operation
            DispatchQueue.main.async {
                // Set the etherValueLabel with the formatted USD value or "Failed" in the case of failure
                
                var nonempty = self.formatAsCurrencyString(value: value) ?? "Internet connection error!!!"
                if let i  = nonempty.characters.index(of: "$")  {
                    nonempty.remove(at: i)
                }
                
                self.wageTxt.text = nonempty
                
                var nonempty2 = self.wageTxt.text
                if let i  = nonempty2?.characters.index(of: ",")  {
                    nonempty2?.remove(at: i)
                }
                
                self.wageTxt.text = nonempty2
                
                
                //    var nonempty = str
                //    if let i = nonempty.characters.index(of: "$") {
                //    nonempty.remove(at: i)
                //    }
                
                //    nonempty
            }
        }
    }
    
}

