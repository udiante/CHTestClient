//
//  Extensions.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import Foundation

extension String {
    func localized()->String{
        return NSLocalizedString(self, comment: self)
    }
}

extension Date {
    func adding(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }
}
