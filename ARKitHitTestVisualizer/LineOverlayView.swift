//
//  LineOverlayView.swift
//  ARKitHitTestVisualizer
//
//  Created by Andrey Volodin on 20.12.17.
//  Copyright © 2017 Andrey Volodin. All rights reserved.
//

import UIKit

class LineOverlayView: UIView {
    
    struct Line {
        var start: CGPoint
        var end: CGPoint
    }
    
    var lines = [Line]()
    
    func addLine(start: CGPoint, end: CGPoint) {
        lines.append(Line(start: start, end: end))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for line in lines {
            let path = UIBezierPath()
            path.move(to: line.start)
            path.addLine(to: line.end)
            path.close()
            UIColor.red.set()
            path.stroke()
            path.fill()
        }
        lines.removeAll()
    }
}
