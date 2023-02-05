//
//  StringExtension.swift
//  CryptofolioWatch WatchKit Extension
//
//  Created by Marshall Kurniawan on 18/05/22.
//

import Foundation
import SwiftUI

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            if(UserDefaults.standard.string(forKey: "preferredCurrency") == "usd" || UserDefaults.standard.string(forKey: "preferredCurrency") == nil){
                formatter.locale = Locale(identifier: "en_US")
            }else{
                formatter.locale = Locale(identifier: "id_ID")
            }
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
