//
//  RichTextEditor.swift
//  Pods
//
//  Created by iOS Dev on 02/04/17.
//
//

import UIKit
import Foundation

open class RichTextEditor: UITextView, UITextViewDelegate {

    var placeHolderText: String = "Type text here..."
    
    open var isBoldEnabled:Bool = false
    open var isItalicEnabled:Bool = false
    open var isUnderlineEnabled:Bool = false
    open var isBackSpaceEnabled : Bool = false
    
    open var isBoldButtonPressed = false
    open var isItalicButtonPressed = false
    open var isUnderlinedButtonPressed = false
    
    open var textChanged: Bool = false
    
    open var imageScalingFactor: CGFloat = 1.0
    
    open var updatingTextRange: NSRange = NSMakeRange(0, 0)
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.text = placeHolderText
        self.textColor = UIColor.lightGray
        self.delegate = self
    }
    
    
    open func formatBoldSeletedText() {
        self.isBoldButtonPressed = true
        if !isBoldEnabled {
            isBoldEnabled = true
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.addBoldFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                self.selectedRange = rangeToModify
            }
        } else {
            isBoldEnabled = false
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.removeBoldFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                self.selectedRange = rangeToModify
            }
        }
    }
    
    open func formatItalicSeletedText() {
        self.isItalicButtonPressed = true
        if !isItalicEnabled {
            isItalicEnabled = true
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.addItalicFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                // Set cursor position after modifying attribute
                self.selectedRange = rangeToModify
            }
        } else {
            isItalicEnabled = false
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.removeUnderlineFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                // Set cursor position after modifying attribute
                self.selectedRange = rangeToModify
            }
        }
    }
    
    open func formatUnderlinedSeletedText() {
        self.isUnderlinedButtonPressed = true
        if !isUnderlineEnabled {
            isUnderlineEnabled = true
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.addUnderlineFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                // Set cursor position after modifying attribute
                self.selectedRange = rangeToModify
            }
        } else {
            isUnderlineEnabled = false
            if updatingTextRange.length > 0 && self.text != placeHolderText {
                let rangeToModify = updatingTextRange
                guard rangeToModify.location < self.attributedText.length else {
                    return
                }
                
                let attributedString = NSMutableAttributedString(string: "")
                attributedString.append(self.attributedText)
                
                if  (updatingTextRange.location + updatingTextRange.length) != self.attributedText.string.characters.count {
                    self.checkForAttributes(rangeToModify)
                }
                
                self.removeUnderlineFormat(attributedString, rangeToModify: rangeToModify)
                self.attributedText = attributedString
                // Set cursor position after modifying attribute
                self.selectedRange = rangeToModify
            }
        }
    }
    
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.attributedText.length == 0 || textView.text == placeHolderText {
            DispatchQueue.main.async(execute: {
                textView.selectedRange = NSMakeRange(0, 0)
            })
        }
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        updatingTextRange = range
        if text.characters.count == 0 {
            isBackSpaceEnabled = true
        } else {
            isBackSpaceEnabled = false
        }
        
        if textView.attributedText.length == 0 && text.characters.count == 0 {
            textChanged = true
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
            self.disableAllFormattingButton()
        } else {
            if text.characters.count == 0 {
                textChanged = false
                if range.location == 0 && (textView.attributedText.length == 0 || textView.attributedText.length == range.length) {
                    textView.text = placeHolderText
                    textView.textColor = UIColor.lightGray
                    textView.selectedRange = NSMakeRange(0, 0)
                    self.disableAllFormattingButton()
                }
            } else {
                textChanged = true
                textView.textColor = UIColor.black
                if textView.text == placeHolderText {
                    textView.text = ""
                }
            }
        }
        
        return true
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.attributedText.length == 0 || textView.text == placeHolderText {
            DispatchQueue.main.async(execute: {
                textView.selectedRange = NSMakeRange(0, 0)
                return
            })
        }
        if !textChanged {
            updatingTextRange = textView.selectedRange
            
            self.isBoldButtonPressed = false
            self.isItalicButtonPressed = false
            self.isUnderlinedButtonPressed = false
            
            self.isBoldEnabled = false
            self.isItalicEnabled = false
            self.isUnderlineEnabled = false
            self.checkForAttributes(textView.selectedRange)
        }
    }
    
    
    open func textViewDidChange(_ textView: UITextView) {
//        let selectedRange = self.textViewRichTextEditor.selectedRange
        
        if isBackSpaceEnabled {
            isBackSpaceEnabled = false
            return
        }
        
        if textView.text.characters.count > 0 {
            let rangeToModify = NSMakeRange((selectedRange.location - 1) > 0 ? selectedRange.location - 1 : 0, 1)
            
            let attributedString = NSMutableAttributedString(string: "")
            attributedString.append(textView.attributedText)
            
            let customFont = UIFont.systemFont(ofSize: 14.0)
            let normalAttributes = [NSFontAttributeName: customFont]
            attributedString.addAttributes(normalAttributes, range: rangeToModify)
            
            if  (selectedRange.location + selectedRange.length) < self.attributedText.length {
                self.checkForAttributes(rangeToModify)
            }
            
            
            self.removeBoldFormat(attributedString, rangeToModify: rangeToModify)
            self.removeItalicFormat(attributedString, rangeToModify: rangeToModify)
            self.removeUnderlineFormat(attributedString, rangeToModify: rangeToModify)
            
            if isBoldEnabled {
                self.addBoldFormat(attributedString, rangeToModify: rangeToModify)
            }
            
            if isItalicEnabled {
                self.addItalicFormat(attributedString, rangeToModify: rangeToModify)
            }
            
            if isUnderlineEnabled {
                self.addUnderlineFormat(attributedString, rangeToModify: rangeToModify)
            }
            
            textView.attributedText = attributedString
        }
        textChanged = false
    }
    
    func checkForAttributes(_ range: NSRange) {
        if self.attributedText.string == placeHolderText || (self.isBoldButtonPressed || self.isItalicButtonPressed || self.isUnderlinedButtonPressed) {
            return
        }
        
        var isBold = false
        var isItalic = false
        var isUnderlined = false
        
        var rangeToCheck = range
        if rangeToCheck.length == 0 {
            if rangeToCheck.location > 0 && rangeToCheck.location <= self.attributedText.length {
                rangeToCheck = NSMakeRange(rangeToCheck.location-1, rangeToCheck.length+1)
            }
        }
        
        self.attributedText.enumerateAttributes(in: rangeToCheck, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
            if object.keys.contains(NSFontAttributeName) {
                if let font = object[NSFontAttributeName] as? UIFont {
                    if font.isBold {
                        isBold = true
                        print("Bold attribute")
                    }
                    if font.isItalic {
                        isItalic = true
                        print("Italic attribute")
                    }
                    if object.keys.contains(NSUnderlineStyleAttributeName) {
                        isUnderlined = true
                        print("Underline attribute")
                    }
                }
            } else if object.keys.contains(NSUnderlineStyleAttributeName) {
                isUnderlined = true
                print("Underline attribute")
            } else {
                print("no attribute")
            }
        }
        
        if isBold && isItalic && isUnderlined {
            self.isBoldEnabled = true
            self.isItalicEnabled = true
            self.isUnderlineEnabled = true
        } else if !isBold && isItalic && isUnderlined {
            self.isBoldEnabled = false
            self.isItalicEnabled = true
            self.isUnderlineEnabled = true
        } else if isBold && !isItalic && isUnderlined {
            self.isBoldEnabled = true
            self.isItalicEnabled = false
            self.isUnderlineEnabled = true
        } else if isBold && isItalic && !isUnderlined {
            self.isBoldEnabled = true
            self.isItalicEnabled = true
            self.isUnderlineEnabled = false
        } else if !isBold && !isItalic && isUnderlined {
            self.isBoldEnabled = false
            self.isItalicEnabled = false
            self.isUnderlineEnabled = true
        } else if !isBold && isItalic && !isUnderlined {
            self.isBoldEnabled = false
            self.isItalicEnabled = true
            self.isUnderlineEnabled = false
        } else if isBold && !isItalic && !isUnderlined {
            self.isBoldEnabled = true
            self.isItalicEnabled = false
            self.isUnderlineEnabled = false
        }
        
        //        self.richFormatterView.boldButton.selected = self.isBoldEnabled
        if self.isBoldEnabled {
//            self.richFormatterView.boldButton.selected = true
//            self.richFormatterView.boldButton.backgroundColor = UIColor.whiteColor()
        } else {
//            self.richFormatterView.boldButton.selected = false
//            self.richFormatterView.boldButton.backgroundColor = UIColor.blueColor()
        }
        
        //        self.richFormatterView.italicsButton.selected = self.isItalicEnabled
        if self.isItalicEnabled {
//            self.richFormatterView.italicsButton.selected = true
//            self.richFormatterView.italicsButton.backgroundColor = UIColor.whiteColor()
        } else {
//            self.richFormatterView.italicsButton.selected = false
//            self.richFormatterView.italicsButton.backgroundColor = UIColor.blueColor()
        }
        
        
        //        self.richFormatterView.underlinedButton.selected = self.isUnderlineEnabled
        if self.isUnderlineEnabled {
//            self.richFormatterView.underlinedButton.selected = true
//            self.richFormatterView.underlinedButton.backgroundColor = UIColor.whiteColor()
        } else {
//            self.richFormatterView.underlinedButton.selected = false
//            self.richFormatterView.underlinedButton.backgroundColor = UIColor.blueColor()
        }
        
        //        if let sender = self.richFormatterView.viewWithTag(1) as! UIButton? {
        //            sender.selected = self.isBoldEnabled
        //        }
        //
        //        if let sender = self.richFormatterView.viewWithTag(2) as! UIButton? {
        //            sender.selected = self.isItalicEnabled
        //        }
        //
        //        if let sender = self.richFormatterView.viewWithTag(3) as! UIButton? {
        //            sender.selected = self.isUnderlineEnabled
        //        }
        
    }
    
    func disableAllFormattingButton() {
//        self.richFormatterView.boldButton.selected = false
//        self.richFormatterView.boldButton.backgroundColor = UIColor.blueColor()
//        
//        self.richFormatterView.italicsButton.selected = false
//        self.richFormatterView.italicsButton.backgroundColor = UIColor.blueColor()
//        
//        self.richFormatterView.underlinedButton.selected = false
//        self.richFormatterView.underlinedButton.backgroundColor = UIColor.blueColor()
    }
    
    func addBoldFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        let customFont = UIFont.systemFont(ofSize: 14.0)
        let boldAttributes = [NSFontAttributeName: customFont.withTraits(.traitBold)]
        attributedString.addAttributes(boldAttributes, range: rangeToModify)
        return attributedString
    }
    
    func removeBoldFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributes(in: rangeToModify, options: []) { (attributes, range, _) -> Void in
            for (attribute, object) in attributes {
                if let font = object as? UIFont {
                    if attribute == NSFontAttributeName && font.isBold {
                        attributedString.removeAttribute(attribute, range: range)
                        let customFont = UIFont.systemFont(ofSize: 14.0)
                        let normalAttributes = [NSFontAttributeName: customFont]
                        attributedString.addAttributes(normalAttributes, range: range)
                        break
                    }
                }
            }
        }
        return attributedString
    }
    
    
    func addItalicFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        let customFont = UIFont.italicSystemFont(ofSize: 14.0)
        let italicAttributes = isBoldEnabled ? [NSFontAttributeName: customFont.withTraits(.traitBold, .traitItalic)] : [NSFontAttributeName: customFont.withTraits(.traitItalic)]
        attributedString.addAttributes(italicAttributes, range: rangeToModify)
        return attributedString
    }
    
    func removeItalicFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributes(in: rangeToModify, options: []) { (attributes, range, _) -> Void in
            for (attribute, object) in attributes {
                if let font = object as? UIFont {
                    if attribute == NSFontAttributeName && font.isItalic {
                        attributedString.removeAttribute(attribute, range: range)
                        let customFont = UIFont.systemFont(ofSize: 14.0)
                        let normalAttributes = [NSFontAttributeName: customFont]
                        attributedString.addAttributes(normalAttributes, range: range)
                        break
                    }
                }
            }
        }
        return attributedString
    }
    
    func addUnderlineFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: rangeToModify)
        return attributedString
    }
    
    func removeUnderlineFormat(_ attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributes(in: rangeToModify, options: []) { (attributes, range, _) -> Void in
            var mutableAttributes = attributes
            mutableAttributes.removeValue(forKey: NSUnderlineStyleAttributeName)
            attributedString.setAttributes(mutableAttributes, range: rangeToModify)
        }
        return attributedString
    }
    
}


public extension UIFont {
    func withTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(.traitBold, .traitItalic)
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}




