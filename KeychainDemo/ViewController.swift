//
//  ViewController.swift
//  Try
//
//  Created by Bing Guo on 2020/5/29.
//  Copyright © 2020 Bing Guo. All rights reserved.
//

import UIKit
import KeychainAccess

class CreditCard: Codable {
    let name: String
    let number: String
    let month: Int
    let year: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case month
        case year
    }
    
    init(name: String, number: String, month: Int, year: Int) {
        self.name = name
        self.number = number
        self.month = month
        self.year = year
    }
}

extension CreditCard: CustomStringConvertible {
    var description: String {
        return "name: \(name), number: \(number)"
    }
}

class ViewController: UIViewController {
    
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    @IBOutlet weak var btn: UIButton!
    @IBAction func tapped(_ sender: Any) {
        let data = keychain[data: "creditCard"]
        
        let decoder = JSONDecoder()
        if let data = data {
            let json = try! decoder.decode(CreditCard.self, from: data)
            print(json)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card = CreditCard(name: "bing", number: "1234567890123456", month: 1, year: 24)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(card)
        keychain[data: "creditCard"] = data
    }
    
    func remove() {
        do {
            try keychain.remove("creditCard")
            print("remove success")
        } catch {
            print("error")
        }
    }
}

