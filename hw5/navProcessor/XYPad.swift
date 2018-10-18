//
//  XYPad.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit

class XYPad: UIView {
    
    var position = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawTouchCircle(CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)) // Draw circle at initial point
    }
    
    // Method to draw a circle and have it follow a CGPoint location passed into it
    func drawTouchCircle(_ locationOfTouch: CGPoint) {
        clipsToBounds = true
        position.removeFromSuperview()
        position = UIView(frame:CGRect(x: locationOfTouch.x - 25, y: locationOfTouch.y - 25, width: 50, height: 50))
        position.backgroundColor = UIColor.cyan
        position.alpha = 0.5
        position.layer.cornerRadius = 25
        position.clipsToBounds = true
        addSubview(position)
    }
}
