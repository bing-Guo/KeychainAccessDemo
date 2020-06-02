//
//  ViewController.swift
//  Try
//
//  Created by Bing Guo on 2020/5/29.
//  Copyright © 2020 Bing Guo. All rights reserved.
//

import UIKit
import KeychainAccess

class CreditCard {
    let name: String
    let number: String
    let month: Int
    let year: Int
    
    init(name: String, number: String, month: Int, year: Int) {
        self.name = name
        self.number = number
        self.month = month
        self.year = year
    }
}

extension CreditCard {
    func toJson() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        dict["name"] = self.name
        dict["number"] = self.number
        dict["month"] = self.month
        dict["year"] = self.year
        
        return dict
    }
}

class ViewController: UIViewController {
    
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    @IBOutlet weak var btn: UIButton!
    @IBAction func tapped(_ sender: Any) {
        let card = keychain[data: "creditCard"]
        let data = dataToDictionary(with: card!)!
        print(data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card = CreditCard(name: "bing", number: "1234567890123456", month: 1, year: 24)
        
        if let data = jsonToData(with: card.toJson()) {
            keychain[data: "creditCard"] = data
        }
    }
    
    func remove() {
        do {
            try keychain.remove("creditCard")
            print("remove success")
        } catch {
            print("error")
        }
    }
    
    func jsonToData(with jsonDict: Dictionary<String, Any>) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDict)) {
            fatalError("It's not a valid json object.")
        }
        return try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
    }
    
    func dataToDictionary(with data: Data) ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch {
            fatalError("Failed to convert Data to Dictionary.")
        }
    }
}

