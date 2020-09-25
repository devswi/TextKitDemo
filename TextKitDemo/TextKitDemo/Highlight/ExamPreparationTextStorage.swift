//
//  ExamPreparationTextStorage.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

class ExamPreparationTextStorage: NSTextStorage {
    
    // AttributedString 样式
    var styleSheet: [ExamPreparationTextStyleSheet.Key: Any] = [:]
    
    private var attributedString: NSMutableAttributedString
    
    private var dialogHighlightRange: NSRange?
    private var markHighlightRanges: [NSRange] = []
    
    override init(attributedString attrStr: NSAttributedString) {
        self.attributedString = NSMutableAttributedString(attributedString: attrStr)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var string: String {
        attributedString.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return attributedString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        attributedString.replaceCharacters(in: range, with: str)
        edited(
            [.editedCharacters, .editedAttributes],
            range: range,
            changeInLength: str.count - range.length
        )
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        attributedString.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        applyAttributes()
        super.processEditing()
    }
    
    func applyAttributes() {
        
    }
    
    func currentRangeHasBeenSelected(_ range: NSRange) -> NSRange? {
        if let selected = markHighlightRanges.first(where: { _range -> Bool in
            let end = range.location + range.length
            let _end = _range.location + _range.length
            return _range.location <= range.location && _end >= end
        }) {
            return selected
        } else {
            return nil
        }
    }
    
    // 查词
    func addHighlight(range: NSRange) {
        assert(!styleSheet.isEmpty)
        removeHighlight()
        dialogHighlightRange = range
        let backgroundColor = (styleSheet[.highlightBackgroundColor] as? UIColor) ?? .clear
        let foregroundColor = (styleSheet[.highlightForegroundColor] as? UIColor) ?? .white
        modifyColor(foregroundColor: foregroundColor, backgroundColor: backgroundColor, at: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    func removeHighlight() {
        assert(!styleSheet.isEmpty)
        guard let range = dialogHighlightRange else { return }
        let foregroundColor = (styleSheet[.foregroundColor] as? UIColor) ?? .black
        addAttribute(.foregroundColor, value: foregroundColor, range: range)

        // 判断 mark 的 ranges 中是否包含当前的高亮文本
        if let markRange = markHighlightRanges.first(where: { (_range) -> Bool in
            if let intersection = _range.intersection(range) {
                return intersection.length > 0
            } else {
                return false
            }
        }) {
            mark(at: markRange)
        } else {
            removeAttribute(.underlineStyle, range: range)
        }
        edited(.editedAttributes, range: range, changeInLength: 0)
        dialogHighlightRange = nil
    }
    
    //
    func addMarkHighlight(ranges: [NSRange]) {
        assert(!styleSheet.isEmpty)
        markHighlightRanges = ranges
        for range in ranges {
            mark(at: range)
        }
        edited(.editedAttributes, range: NSRange(location: 0, length: length), changeInLength: 0)
    }
    
    func markHightlight(at range: NSRange) {
        assert(!styleSheet.isEmpty)
        var range = range
        // 移除所有有交集的 range
        markHighlightRanges.removeAll(where: { _range -> Bool in
            if let overlap = _range.intersection(range) {
                if overlap.length > 0 {
                    let minLocation = min(_range.location, range.location)
                    let end = max(_range.location + _range.length, range.location + range.length)
                    range.location = minLocation
                    range.length = end - range.location
                    return true
                }
            }
            return false
        })
        markHighlightRanges.append(range)
        mark(at: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    func unmarkHighlight(at range: NSRange) {
        assert(!styleSheet.isEmpty)
        // 移除所有有交集的 range
        markHighlightRanges.removeAll(where: { _range -> Bool in
            if let overlap = _range.intersection(range) {
                if overlap.length > 0 {
                    let foregroundColor = (styleSheet[.foregroundColor] as? UIColor) ?? .black
                    addAttribute(.foregroundColor, value: foregroundColor, range: _range)
                    removeAttribute(.underlineStyle, range: _range)
                    return true
                }
            }
            return false
        })
    }
    
    private func mark(at range: NSRange) {
        let underlineColor = (styleSheet[.markBackgroundColor] as? UIColor) ?? .red
        let foregroundColor = (styleSheet[.markForegroundColor] as? UIColor) ?? .white
        addAttributes(
            [
                .foregroundColor: foregroundColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: underlineColor
            ],
            range: range
        )
    }
    
    private func modifyColor(foregroundColor: UIColor, backgroundColor: UIColor, at range: NSRange) {
        addAttributes(
            [
                .foregroundColor: foregroundColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: backgroundColor
            ],
            range: range
        )
    }
    
}
