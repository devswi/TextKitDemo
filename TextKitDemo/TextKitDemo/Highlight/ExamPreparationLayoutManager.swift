//
//  ExamPreparationLayoutManager.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

class ExamPreparationLayoutManager: NSLayoutManager {
    
    override func drawUnderline(forGlyphRange glyphRange: NSRange,
        underlineType underlineVal: NSUnderlineStyle,
        baselineOffset: CGFloat,
        lineFragmentRect lineRect: CGRect,
        lineFragmentGlyphRange lineGlyphRange: NSRange,
        containerOrigin: CGPoint
    ) {
        let firstPosition  = location(forGlyphAt: glyphRange.location).x
        
        let lastPosition: CGFloat
        
        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
            lastPosition = location(forGlyphAt: NSMaxRange(glyphRange)).x
        } else {
            lastPosition = lineFragmentUsedRect(
                forGlyphAt: NSMaxRange(glyphRange) - 1,
                effectiveRange: nil).size.width
        }
        
        var lineRect = lineRect
        let height = lineRect.size.height * 3.5 / 4.0
        lineRect.origin.x += firstPosition
        lineRect.size.width = lastPosition - firstPosition
        lineRect.size.height = height
        
        lineRect.origin.x += containerOrigin.x
        lineRect.origin.y += containerOrigin.y
        
        lineRect = lineRect.integral.insetBy(dx: 0.5, dy: 0.5)
        
        let path = UIBezierPath(rect: lineRect)
        path.fill()
    }
    
}
