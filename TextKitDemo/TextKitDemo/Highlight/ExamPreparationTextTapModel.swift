//
//  ExamPreparationTextTapModel.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

enum ExamPreparationText {
    case word(ExamPreparationTextModel)
    case mark(ExamPreparationTextModel)
}

struct ExamPreparationTextModel {
    let text: String
    let textRange: NSRange
    let textRect: CGRect
}
