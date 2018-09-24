//
//  Constants.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

struct Constants {
    struct colors {
        static let defaultColor = UIColor.white
        static let positiveColor = UIColor.green
        static let negativeColor = UIColor.red
        static let disabledColor = UIColor.gray.withAlphaComponent(0.6)
        static let enabledWhiteStyleColor = UIColor.black
        static let highlightColor = UIColor.yellow
    }
    
    struct symbols {
        static let USD_DOLLAR = "$"
        static let NO_DATA_VALUE = "-"
    }
    
    struct decimalPlaces {
        static let CPYPTOCURRENCY = 5
        static let USD_DOLLAR = 2
        static let PERCENT = 2
    }
}
