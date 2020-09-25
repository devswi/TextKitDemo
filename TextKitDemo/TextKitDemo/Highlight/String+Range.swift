//
//  String+.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import Foundation

extension String {
    func wordContainsCharacter(at index: Int) -> NSRange? {
        guard index > 0 && index < count
            else { return nil }
        
        var characterSet = CharacterSet()
        characterSet.formUnion(.whitespacesAndNewlines)
        characterSet.formUnion(CharacterSet(charactersIn: #"?!,.:;"()“”"#))
        
        var afterCurrentIndex = self.index(startIndex, offsetBy: index)
        while !self[afterCurrentIndex].unicodeScalars.allSatisfy({ characterSet.contains($0) }) {
            formIndex(after: &afterCurrentIndex)
        }
        
        var beforeCurrentIndex = self.index(startIndex, offsetBy: index)
        while !self[beforeCurrentIndex].unicodeScalars.allSatisfy({ characterSet.contains($0) }) {
            formIndex(before: &beforeCurrentIndex)
        }
        // beforeCurrentIndex 移动到后一位
        self.formIndex(after: &beforeCurrentIndex)
        if beforeCurrentIndex >= afterCurrentIndex {
            return nil
        }
        let range = beforeCurrentIndex..<afterCurrentIndex
        return NSRange(range, in: self)
    }
    
    func completeBoundary(given range: NSRange) -> NSRange {
        let begining = range.location
        let end = range.location + range.length
        
        let beginingRange = wordContainsCharacter(at: begining) ?? NSRange(location: begining, length: 0)
        let endRange = wordContainsCharacter(at: end) ?? NSRange(location: end, length: 0)
        
        let length = endRange.location + endRange.length - beginingRange.location
        return NSRange(location: beginingRange.location, length: length)
    }
}
