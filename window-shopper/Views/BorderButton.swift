//
//  BorderButton.swift
//  window-shopper
//
//  Created by Tan Ming Hoe on 30/12/2017.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class BorderButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
}

