//
//  RichTextEditor.swift
//  Pods
//
//  Created by iOS Dev on 02/04/17.
//
//

import UIKit
import Foundation

public class RichTextEditor: UITextView, UITextViewDelegate {

    var placeHolderText: String = "Type text here..."
    
    public var isBoldEnabled:Bool = false
    public var isItalicEnabled:Bool = false
    public var isUnderlineEnabled:Bool = false
    public var isBackSpaceEnabled : Bool = false
    
    public var isBoldButtonPressed = false
    public var isItalicButtonPressed = false
    public var isUnderlinedButtonPressed = false
    
    public var textChanged: Bool = false
    
    public var imageScalingFactor: CGFloat = 1.0
    
    public var updatingTextRange: NSRange = NSMakeRange(0, 0)
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.text = placeHolderText
        self.textColor = UIColor.lightGrayColor()
        self.delegate = self
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if textView.attributedText.length == 0 || textView.text == placeHolderText {
            dispatch_async(dispatch_get_main_queue(), {
                textView.selectedRange = NSMakeRange(0, 0)
            })
        }
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        updatingTextRange = range
        if text.characters.count == 0 {
            isBackSpaceEnabled = true
        } else {
            isBackSpaceEnabled = false
        }
        
        if textView.attributedText.length == 0 && text.characters.count == 0 {
            textChanged = true
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGrayColor()
            self.disableAllFormattingButton()
        } else {
            if text.characters.count == 0 {
                textChanged = false
                if range.location == 0 && (textView.attributedText.length == 0 || textView.attributedText.length == range.length) {
                    textView.text = placeHolderText
                    textView.textColor = UIColor.lightGrayColor()
                    textView.selectedRange = NSMakeRange(0, 0)
                    self.disableAllFormattingButton()
                }
            } else {
                textChanged = true
                textView.textColor = UIColor.blackColor()
                if textView.text == placeHolderText {
                    textView.text = ""
                }
            }
        }
        
        return true
    }
    
    public func textViewDidChangeSelection(textView: UITextView) {
        if textView.attributedText.length == 0 || textView.text == placeHolderText {
            dispatch_async(dispatch_get_main_queue(), {
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
    
    
    public func textViewDidChange(textView: UITextView) {
//        let selectedRange = self.textViewRichTextEditor.selectedRange
        
        if isBackSpaceEnabled {
            isBackSpaceEnabled = false
            return
        }
        
        if textView.text.characters.count > 0 {
            let rangeToModify = NSMakeRange((selectedRange.location - 1) > 0 ? selectedRange.location - 1 : 0, 1)
            
            let attributedString = NSMutableAttributedString(string: "")
            attributedString.appendAttributedString(textView.attributedText)
            
            let customFont = UIFont.systemFontOfSize(14.0)
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
    
    func checkForAttributes(range: NSRange) {
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
        
        self.attributedText.enumerateAttributesInRange(rangeToCheck, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (object, range, stop) in
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
    
    func addBoldFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        let customFont = UIFont.systemFontOfSize(14.0)
        let boldAttributes = [NSFontAttributeName: customFont.withTraits(.TraitBold)]
        attributedString.addAttributes(boldAttributes, range: rangeToModify)
        return attributedString
    }
    
    func removeBoldFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributesInRange(rangeToModify, options: []) { (attributes, range, _) -> Void in
            for (attribute, object) in attributes {
                if let font = object as? UIFont {
                    if attribute == NSFontAttributeName && font.isBold {
                        attributedString.removeAttribute(attribute, range: range)
                        let customFont = UIFont.systemFontOfSize(14.0)
                        let normalAttributes = [NSFontAttributeName: customFont]
                        attributedString.addAttributes(normalAttributes, range: range)
                        break
                    }
                }
            }
        }
        return attributedString
    }
    
    
    func addItalicFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        let customFont = UIFont.italicSystemFontOfSize(14.0)
        let italicAttributes = isBoldEnabled ? [NSFontAttributeName: customFont.withTraits(.TraitBold, .TraitItalic)] : [NSFontAttributeName: customFont.withTraits(.TraitItalic)]
        attributedString.addAttributes(italicAttributes, range: rangeToModify)
        return attributedString
    }
    
    func removeItalicFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributesInRange(rangeToModify, options: []) { (attributes, range, _) -> Void in
            for (attribute, object) in attributes {
                if let font = object as? UIFont {
                    if attribute == NSFontAttributeName && font.isItalic {
                        attributedString.removeAttribute(attribute, range: range)
                        let customFont = UIFont.systemFontOfSize(14.0)
                        let normalAttributes = [NSFontAttributeName: customFont]
                        attributedString.addAttributes(normalAttributes, range: range)
                        break
                    }
                }
            }
        }
        return attributedString
    }
    
    func addUnderlineFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: rangeToModify)
        return attributedString
    }
    
    func removeUnderlineFormat(attributedString: NSMutableAttributedString, rangeToModify: NSRange) -> NSAttributedString {
        attributedString.enumerateAttributesInRange(rangeToModify, options: []) { (attributes, range, _) -> Void in
            var mutableAttributes = attributes
            mutableAttributes.removeValueForKey(NSUnderlineStyleAttributeName)
            attributedString.setAttributes(mutableAttributes, range: rangeToModify)
        }
        return attributedString
    }
    
}


public extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(.TraitBold, .TraitItalic)
    }
    
    var isBold: Bool {
        return fontDescriptor().symbolicTraits.contains(.TraitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor().symbolicTraits.contains(.TraitItalic)
    }
}


//public extension UITextView {
//    private struct AssociatedKey {
//        static var isBoldEnabled: Bool = false
//        static var isItalicEnabled: Bool = false
//        static var isUnderlineEnabled: Bool = false
//        static var isBackSpaceEnabled: Bool = false
//    }
//    
//    var isBoldEnabled:Bool {
//        get {
//            return objc_getAssociatedObject(self, &isBoldEnabled) as? Bool ?? false
//        }
//        set {
//            objc_setAssociatedObject(self, &isBoldEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    var isItalicEnabled:Bool {
//        get {
//            return objc_getAssociatedObject(self, &isItalicEnabled) as? Bool ?? false
//        }
//        set {
//            objc_setAssociatedObject(self, &isItalicEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    var isUnderlineEnabled:Bool {
//        get {
//            return objc_getAssociatedObject(self, &isUnderlineEnabled) as? Bool ?? false
//        }
//        set {
//            objc_setAssociatedObject(self, &isUnderlineEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    var isBackSpaceEnabled:Bool {
//        get {
//            return objc_getAssociatedObject(self, &isBackSpaceEnabled) as? Bool ?? false
//        }
//        set {
//            objc_setAssociatedObject(self, &isBackSpaceEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}



