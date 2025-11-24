//
//  CustomTextView.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 05.11.2025.
//

import UIKit

class CustomTextView: UIView {
    
    private var test = "test"
    
    weak var delegate: CustomTextViewDelegate?
    
    private var isEditing = false
    
    private let titleTextView = UITextView()
    private var titlePlaceholder = (text: "Title", isOn: false)
    
    private let bodyTextView = UITextView()
    private var bodyPlaceholder = (text: "Body", isOn: false)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        subscribeNotification()
        setupScrollView()
        addTapGesture()
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isEditing(_ editing: Bool) {
        isEditing = editing
        titleTextView.isEditable = editing
        titleTextView.isSelectable = editing
        bodyTextView.isEditable = editing
        bodyTextView.isSelectable = editing
    }
    
    func setTitlePlaceholder(to text: String) {
        
        titlePlaceholder.text = text
        titleTextView.text = titlePlaceholder.text
    }
    
    func setTitle(to text: String) {
        
        titleTextView.text = text
        titleTextView.textColor = .label
        titlePlaceholder.isOn = false
    }
    
    func setBodyPlaceholder(to text: String) {
        
        bodyPlaceholder.text = text
        bodyTextView.text = bodyPlaceholder.text
    }
    
    func setBody(to text: String) {
        
        bodyTextView.text = text
        bodyTextView.textColor = .label
        bodyPlaceholder.isOn = false
    }
    
    private func setupScrollView() {
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTextView() {
        
        titleTextView.isEditable = isEditing
        titleTextView.isSelectable = isEditing
        
        if titleTextView.hasText {
            titleTextView.textColor = .label
        }
        else {
            
            titlePlaceholder.isOn = true
            titleTextView.text = titlePlaceholder.text
            titleTextView.textColor = .secondaryLabel
        }
        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        
        titleTextView.delegate = self
        
        bodyTextView.isEditable = isEditing
        bodyTextView.isSelectable = isEditing
        
        if bodyTextView.hasText {
            
            bodyTextView.textColor = .label
        }
        else {
            
            bodyPlaceholder.isOn = true
            bodyTextView.text = bodyPlaceholder.text
            bodyTextView.textColor = .secondaryLabel
        }
        bodyTextView.font = .preferredFont(forTextStyle: .title3)
        bodyTextView.isScrollEnabled = false
        
        bodyTextView.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stack.axis = .vertical
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        
        guard !titleTextView.isFirstResponder && !bodyTextView.isFirstResponder else { return }
            
        if bodyTextView.text.isEmpty {
            
            titleTextView.becomeFirstResponder()
        } else {
            
            bodyTextView.becomeFirstResponder()
        }
    }
    
    private func subscribeNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        UIView.animate(withDuration: duration, delay: 0) {
            
            self.scrollView.contentInset.bottom = keyboardFrame.height - self.safeAreaInsets.bottom
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        UIView.animate(withDuration: duration, delay: 0) {
            
            self.scrollView.contentInset.bottom = 0
        }
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension CustomTextView: UITextViewDelegate  {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == titleTextView {
            
            if titlePlaceholder.isOn {
                
                textView.text = ""
                textView.textColor = .label
                titlePlaceholder.isOn = false
            }
        }
        
        if textView == bodyTextView {
            
            if bodyPlaceholder.isOn {
                
                textView.text = ""
                textView.textColor = .label
                bodyPlaceholder.isOn = false
            }
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if textView == titleTextView {
            
            if textView.text.isEmpty {
                
                textView.text = titlePlaceholder.text
                textView.textColor = .secondaryLabel
                titlePlaceholder.isOn = true
            }
        }
        
        if textView == bodyTextView {
            
            if textView.text.isEmpty {
                
                textView.text = bodyPlaceholder.text
                textView.textColor = .secondaryLabel
                bodyPlaceholder.isOn = true
            }
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {

        if textView == titleTextView {
            
            delegate?.titleDidChange(text: textView.text)
        }
        
        if textView == bodyTextView {
            
            delegate?.bodyDidChange(text: textView.text)
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if textView == titleTextView {
            
            if text == "\n" && bodyTextView.text.isEmpty {
                
                bodyTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                
                return false
            }
            else if text == "\n" && bodyTextView.hasText {
                
                bodyTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                bodyTextView.text.insert("\n", at: bodyTextView.text.startIndex)
                bodyTextView.selectedRange = NSRange(location: 0, length: 0)
                
                return false
            }
        }
        
        if textView == bodyTextView {
            
            if text == "" && bodyTextView.selectedRange == NSRange(location: 0, length: 0) {
                
                titleTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                
                return false
            }
        }
        
        return true
    }
}
