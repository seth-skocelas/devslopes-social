//
//  CircleView.swift
//  devslopes-social
//
//  Created by Seth Skocelas on 10/21/17.
//  Copyright © 2017 Seth Skocelas. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    

    override func layoutSubviews() {
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
    }

}
