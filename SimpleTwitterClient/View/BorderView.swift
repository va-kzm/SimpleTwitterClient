//
//  BorderView.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 18.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit

class BorderView: UIView {

    override func awakeFromNib() {
        layer.borderWidth = 0.13
        layer.borderColor = UIColor.black.cgColor
        
        super.awakeFromNib()
    }
}
