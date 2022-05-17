//
//  UserSettings.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 12/05/22.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    @Published var preferredCurrency: String {
        didSet {
            UserDefaults.standard.set(preferredCurrency, forKey: "preferredCurrency")
        }
    }
    
    init() {
        self.userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
        self.preferredCurrency = UserDefaults.standard.object(forKey: "preferredCurrency") as? String ?? ""
    }
}
