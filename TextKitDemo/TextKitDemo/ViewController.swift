//
//  ViewController.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/23.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ExamPreparationTextViewDelegate {
    
    @IBOutlet weak var textView: ExamPreparationTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        let string = """
        Almost every developer once in a while suffers from quite long Xcode build time. It results in lower productivity and slows down the development process of the whole team. As you can see, enhancing build time is crucial because it has direct impact on time to market for shipping new features faster.
        In this post, we’ll learn how to profile the Xcode build and get its metrics. In the next article, I’ll go through techniques to resolve bottlenecks and speed up the build. It should be mentioned as well, that we’ll be using Kickstarter iOS project, that can be found on Github. So let’s get started!
        The most efficient way of improving the build time should be a data-driven approach when you introduce and verify changes based on the build metrics. Let’s dive into it and have a look at the tools we can use to get insights about the project’s build time.
        It should be a nice starting point to find out the most time-consuming tasks within your build process. As you can see from the screenshot above, CompileStoryboard, CompileXIB, CompileSwiftSources and PhaseScriptExecution phases took most of the build time. Xcode managed to run some of the tasks in parallel that’s why the build is finished much faster than the time it took to run each of the commands.
        Now let’s get similar metrics for the incremental build. It should be mentioned that incremental build time fully depends on the files being changed in your project. To get consistent results you can change a single file and rebuilt the project. Unlike Buck or Bazel, Xcode uses timestamps to detect what has changed and what needs to be rebuilt. We can update a timestamp using touch then.
        """
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.minimumLineHeight = 15
        paragraph.paragraphSpacing = 10
        
        let attributedString = NSAttributedString(
            string: string,
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.black,
            ]
        )
        textView.styleSheet = [
            .foregroundColor: UIColor.black,
            .highlightForegroundColor: UIColor.white,
            .highlightBackgroundColor: UIColor(red: 32 / 255.0, green: 158 / 255.0, blue: 133 / 255.0, alpha: 1.0),
            .markForegroundColor: UIColor.white,
            .markBackgroundColor: UIColor(red: 51 / 255.0, green: 154 / 255.0, blue: 1.0, alpha: 1.0),
            .textContainerInset: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            .selectionIndicatorColor: UIColor.red
        ]
        textView.attributedString = attributedString
    }
    
    func didTapBlankSpaceInTextView(_ textView: ExamPreparationTextView) {
        textView.removeHighlight()
    }
    
    func textView(_ textView: ExamPreparationTextView, didTapWordWithTapModel tapModel: ExamPreparationText) {
        if case .word(let model) = tapModel {
            textView.removeHighlight()
            textView.addHighlight(range: model.textRange)
        }
    }
    
    func textView(_ textView: ExamPreparationTextView, didMarkWithSelectModel selectModel: ExamPreparationText) {
        if case .mark(let model) = selectModel {
            textView.markHightlight(at: model.textRange)
        }
    }
    
    func textView(_ textView: ExamPreparationTextView, didUnmarkWithSelectModel selectModel: ExamPreparationText) {
        if case .mark(let model) = selectModel {
            textView.unmarkHighlight(at: model.textRange)
        }
    }
    
}

