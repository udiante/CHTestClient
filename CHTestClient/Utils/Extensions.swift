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
