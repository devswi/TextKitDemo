//
//  ExamPreparationTextStyleSheet.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/27.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

struct ExamPreparationTextStyleSheet {
    
    struct Key: Hashable, Equatable, RawRepresentable {
        let rawValue: String
        
        init(_ rawValue: String) { self.rawValue = rawValue }
        
        init(rawValue: String) { self.rawValue = rawValue }
        
        static let backgroundColor = Key(rawValue: "backgroundColor")
        static let foregroundColor = Key(rawValue: "foregroundColor")
        
        static let highlightBackgroundColor = Key(rawValue: "highlightBackgroundColor")
        static let highlightForegroundColor = Key(rawValue: "highlightForegroundColor")
        
        static let markBackgroundColor = Key(rawValue: "markBackgroundColor")
        static let markForegroundColor = Key(rawValue: "markForegroundColor")
        
        static let textContainerInset = Key(rawValue: "textContainerInset")
        
        static let selectionIndicatorColor = Key(rawValue: "selectionIndicatorColor")
    }
    
}
