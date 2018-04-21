//
//  RoundImageView.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 19.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    override func awakeFromNib() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
        super.awakeFromNib()
    }
}
