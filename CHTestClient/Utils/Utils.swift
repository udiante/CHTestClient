//
//  Utils.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func formatAmountString(_ amount:String, decimalPlaces:Int, currencySymbol:String?)->String{
        guard let value = Double(amount) else {
            return amount
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        formatter.currencySymbol = currencySymbol
        return formatter.string(from: NSNumber(value: value)) ?? amount
    }
    
    static func formattPercent(_ rawValue:String, decimalPlaces:Int)->String{
        guard let value = Double(rawValue) else {
            return rawValue
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        formatter.multiplier = 1
//        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: value)) ?? rawValue
    }
    
    
    static func colorForValue(_ rawValue:String?)->UIColor{
        guard let value = Double(rawValue ?? "") else {
            return Constants.colors.defaultColor
        }
        if value > 0 {
            return Constants.colors.positiveColor
        }
        else if value < 0 {
            return Constants.colors.negativeColor
        }
        return Constants.colors.defaultColor
    }
}
