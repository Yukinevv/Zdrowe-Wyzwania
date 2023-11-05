//
//  Double+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 05/11/2023.
//

import Foundation

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0

        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
