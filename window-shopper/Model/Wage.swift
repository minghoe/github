//
//  Wage.swift
//  window-shopper
//
//  Created by Mark Price on 6/19/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import Foundation
class Wage {
    class func getHours(forWage wage: Double, andPrice price: Double) -> Int {
        return Int(ceil(price / wage))
    }
}
