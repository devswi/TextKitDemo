//
//  ExamPreparationTextViewDelegate.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import Foundation

protocol ExamPreparationTextViewDelegate: class {
    func didTapBlankSpaceInTextView(_ textView: ExamPreparationTextView)
    func textView(_ textView: ExamPreparationTextView, didTapWordWithTapModel tapModel: ExamPreparationText)
    
    func textView(_ textView: ExamPreparationTextView, didMarkWithSelectModel selectModel: ExamPreparationText)
    func textView(_ textView: ExamPreparationTextView, didUnmarkWithSelectModel selectModel: ExamPreparationText)
}
