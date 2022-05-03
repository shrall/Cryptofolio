//
//  StringExtension.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import Foundation

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
