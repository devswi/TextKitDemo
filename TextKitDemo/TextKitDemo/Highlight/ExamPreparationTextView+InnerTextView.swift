//
//  ExamPreparationTextView+InnerTextView.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

extension ExamPreparationTextView {
    
    class InnerTextView: UITextView {
        lazy var markItem = {
            UIMenuItem(title: "标记", action: #selector(handleMarkAction))
        }()
        
        lazy var unmarkItem = {
            UIMenuItem(title: "取消标记", action: #selector(handleUnmarkAction))
        }()
        
        var markClosure: ((ExamPreparationText) -> Void)?
        var unmarkClosure: ((ExamPreparationText) -> Void)?
        
        init(frame: CGRect, textContainer: NSTextContainer?, configuration: (InnerTextView) -> Void) {
            super.init(frame: frame, textContainer: textContainer)
            configuration(self)
            
            UIMenuController.shared.menuItems = [markItem]
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == #selector(handleMarkAction) {
                return true
            } else if action == #selector(handleUnmarkAction) {
                return true
            } else {
                return false
            }
        }
        
        func updateMenu(isSelected: Bool) {
            becomeFirstResponder()
            let menu = UIMenuController.shared
            menu.menuItems = [isSelected ? unmarkItem : markItem]
            menu.update()
        }
        
        func tapModel(at position: UITextPosition) -> ExamPreparationText? {
            guard
                let range = tokenizer.rangeEnclosingPosition(
                    position,
                    with: .word,
                    inDirection: UITextDirection(rawValue: 1)
                ),
                let layoutManager = layoutManager as? ExamPreparationLayoutManager
                else { return nil }
            
            let word = text(in: range)
            assert(word != nil)
            
            let wordRange = convert(range)
            let wordGlyphRange = layoutManager.glyphRange(forCharacterRange: wordRange, actualCharacterRange: nil)
            let wordRect = layoutManager.boundingRect(forGlyphRange: wordGlyphRange, in: textContainer)
            let convertedWordRect = convert(wordRect, from: self)
            
            let textModel = ExamPreparationTextModel(
                text: word!,
                textRange: wordRange,
                textRect: convertedWordRect
            )
            
            return .word(textModel)
        }
        
        func selectModel() -> ExamPreparationText? {
            guard
                let layoutManager = layoutManager as? ExamPreparationLayoutManager,
                let textStorage = textStorage as? ExamPreparationTextStorage
                else
            {
                assertionFailure()
                return nil
            }
            
            guard
                let selectedTextRange = selectedTextRange,
                let selectedText = text(in: selectedTextRange)
                else { return nil }
            
            let selectedTextGlyphRange = layoutManager.glyphRange(forCharacterRange: selectedRange, actualCharacterRange: nil)
            let selectedTextRect = layoutManager.boundingRect(forGlyphRange: selectedTextGlyphRange, in: textContainer)
            let convertedWordRect = convert(selectedTextRect, from: self)
            
            let textRange = textStorage.string.completeBoundary(given: selectedRange)
            let textModel = ExamPreparationTextModel(
                text: selectedText,
                textRange: textRange,
                textRect: convertedWordRect
            )
            
            return .mark(textModel)
        }
        
        @objc
        private func handleMarkAction() {
            dismissMenuController()
            if let selectModel = selectModel() {
                markClosure?(selectModel)
            }
        }
        
        @objc
        private func handleUnmarkAction() {
            dismissMenuController()
            if let selectModel = selectModel() {
                unmarkClosure?(selectModel)
            }
        }
        
        private func dismissMenuController() {
            if #available(iOS 13, *) {
                UIMenuController.shared.hideMenu()
            } else {
                UIMenuController.shared.isMenuVisible = false
            }
            resignFirstResponder()
        }
        
    }
    
}
