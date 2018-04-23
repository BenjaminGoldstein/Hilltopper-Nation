//
//  StyledButton.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/11/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit

class StyledButton: UIButton {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [CGFloat(99.0/255.0), CGFloat(18.0/255.0), CGFloat(51.0/255.0), 0.9])
    }

}
