//
//  ExamPreparationTextView.swift
//  TextKitDemo
//
//  Created by shiwei on 2020/4/26.
//  Copyright © 2020 shiwei. All rights reserved.
//

import UIKit

class ExamPreparationTextView: UIView {
    
    weak var delegate: ExamPreparationTextViewDelegate?
    
    var attributedString: NSAttributedString? {
        didSet {
            configAttributedString()
        }
    }
    
    var styleSheet: [ExamPreparationTextStyleSheet.Key: Any] = [:] {
        didSet {
            configAttributedString()
        }
    }
    
    private var textStorage: ExamPreparationTextStorage?
    private var layoutManager: ExamPreparationLayoutManager?
    private var textView: InnerTextView?
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
        tap.delegate = self
        tap.numberOfTouchesRequired = 1
        return tap
    }()
    
    init(styleSheet: [ExamPreparationTextStyleSheet.Key: Any]) {
        super.init(frame: .zero)
        self.styleSheet = styleSheet
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: public method
    
    func addHighlight(range: NSRange) {
        textStorage?.addHighlight(range: range)
    }
    
    func removeHighlight() {
        textStorage?.removeHighlight()
    }
    
    func markHightlight(at range: NSRange) {
        textStorage?.markHightlight(at: range)
    }
    
    func unmarkHighlight(at range: NSRange) {
        textStorage?.unmarkHighlight(at: range)
    }
    
}

private extension ExamPreparationTextView {
    func addGesture() {
        textView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapAction(_ gesture: UITapGestureRecognizer) {
        guard
            let tappedView = gesture.view as? InnerTextView else {
            assertionFailure()
            return
        }
        
        //
        let menuController = UIMenuController.shared
        if menuController.isMenuVisible {
            tappedView.resignFirstResponder()
        }
        
        let point = gesture.location(in: tappedView)
        guard let textPosition = tappedView.closestPosition(to: point) else {
            delegate?.didTapBlankSpaceInTextView(self)
            return
        }
        
        if let tapModel = textView?.tapModel(at: textPosition) { // 单击事件
            delegate?.textView(self, didTapWordWithTapModel: tapModel)
        } else {
            delegate?.didTapBlankSpaceInTextView(self)
        }
    }
    
    func configAttributedString() {
        guard let attributedString = attributedString else { return }
        let textStorage = ExamPreparationTextStorage(attributedString: attributedString)
        textStorage.styleSheet = styleSheet
        textStorage.delegate = self
        self.textStorage = textStorage
        makeSubviews(with: textStorage)
    }
    
    func makeSubviews(with textStorage: ExamPreparationTextStorage) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let layoutManager = ExamPreparationLayoutManager()
        layoutManager.delegate = self
        self.layoutManager = layoutManager
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: .zero)
        layoutManager.addTextContainer(textContainer)
        
        let textView = InnerTextView(frame: .zero, textContainer: textContainer) { [weak self] textView in
            guard let self = self else { return }
            textView.isEditable = false
            textView.backgroundColor = .clear
            textView.textAlignment = .natural
            textView.isOpaque = false
            textView.delegate = self
            let textContainerInset: UIEdgeInsets = (self.styleSheet[.textContainerInset] as? UIEdgeInsets) ?? .zero
            textView.textContainerInset = textContainerInset
            if #available(iOS 11.0, *) {
                textView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
            textView.markClosure = { model in
                self.delegate?.textView(self, didMarkWithSelectModel: model)
            }
            textView.unmarkClosure = { model in
                self.delegate?.textView(self, didUnmarkWithSelectModel: model)
            }
            textView.tintColor = self.styleSheet[.selectionIndicatorColor] as? UIColor
        }
        self.textView = textView
        addGesture()
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

extension ExamPreparationTextView: UIGestureRecognizerDelegate {
    
}

extension ExamPreparationTextView: NSTextStorageDelegate {
    func textStorage(
        _ textStorage: NSTextStorage,
        didProcessEditing editedMask: NSTextStorage.EditActions,
        range editedRange: NSRange,
        changeInLength delta: Int
    ) {
        
    }
}

extension ExamPreparationTextView: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let textStorage = textStorage else { return }
        let isSelected = textStorage.currentRangeHasBeenSelected(textView.selectedRange) != nil
        self.textView?.updateMenu(isSelected: isSelected)
    }
}

extension ExamPreparationTextView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(floorf(Float(glyphIndex) / 100.0))
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 10
    }
}
