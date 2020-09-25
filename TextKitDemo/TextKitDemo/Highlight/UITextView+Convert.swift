//
//  UITextView+Convert.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

extension UITextView {
    func convert(_ textRange: UITextRange) -> NSRange {
        let begining = beginningOfDocument
        let start = textRange.start
        let end = textRange.end
        
        let location = offset(from: begining, to: start)
        let length = offset(from: start, to: end)
        return NSRange(location: location, length: length)
    }
}
