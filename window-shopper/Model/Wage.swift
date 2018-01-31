//
//  Wage.swift
//  window-shopper
//
//  Created by Mark Price on 6/19/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import Foundation




class Wage {
    class func getHours(forWage wage: Double, andPrice price: Double) -> Double {
       
        let answer = (price / wage)
        let y = Double(round(100000000*answer)/100000000)
        
        return y
    }
}




