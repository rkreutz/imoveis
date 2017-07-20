//
//  GradientView.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/3/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    // Color at the top of the view
    @IBInspectable var startColor: UIColor = UIColor.whiteColor()
    // Color at the middle point of the view
    @IBInspectable var midColor: UIColor = UIColor.blueColor()
    // Color at the bottom of the view
    @IBInspectable var endColor: UIColor = UIColor.blackColor()
    // Middle point
    @IBInspectable var midPoint: CGFloat = 0.0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.backgroundColor = UIColor.clearColor()
        
        let gradient = CAGradientLayer()
        gradient.colors = [self.startColor.CGColor, self.midColor.CGColor, self.endColor.CGColor]
        gradient.locations = [0.0, self.midPoint, 1.0]
        gradient.frame = rect
        
        if let layers = self.layer.sublayers {
            if !layers[0].isKindOfClass(CAGradientLayer) {
                self.layer.insertSublayer(gradient, atIndex: 0)
            }
        }
    }

}
