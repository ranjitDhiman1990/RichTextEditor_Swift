//
//  RichTextEditor.swift
//  Pods
//
//  Created by iOS Dev on 02/04/17.
//
//

import UIKit

class RichTextEditor: UITextView {

    var isBoldEnabled:Bool = false
    var isItalicEnabled:Bool = false
    var isUnderlineEnabled:Bool = false
    var isBackSpaceEnabled : Bool = false
    
    var isBoldButtonPressed = false
    var isItalicButtonPressed = false
    var isUnderlinedButtonPressed = false
    
    var textChanged: Bool = false
    
    var imageScalingFactor: CGFloat = 1.0
    
    var updatingTextRange: NSRange = NSMakeRange(0, 0)
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.attributedText.length == 0 || textView.text == placeHolderText {
            dispatch_async(dispatch_get_main_queue(), {
                textView.selectedRange = NSMakeRange(0, 0)
            })
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        updatingTextRange = range
        if text.characters.count == 0 {
            isBackSpaceEnabled = true
        } else {
            isBackSpaceEnabled = false
        }
        
        if textView.attributedText.length == 0 && text.characters.count == 0 {
            textChanged = true
            textView.text = placeHolderText
            textView.textColor = ColorUtils.greyColor()
            self.disableAllFormattingButton()
        } else {
            if text.characters.count == 0 {
                textChanged = false
                if range.location == 0 && (textView.attributedText.length == 0 || textView.attributedText.length == range.length) {
                    textView.text = placeHolderText
                    textView.textColor = ColorUtils.greyColor()
                    textView.selectedRange = NSMakeRange(0, 0)
                    self.disableAllFormattingButton()
                }
            } else {
                textChanged = true
                textView.textColor = ColorUtils.blackColor()
                if textView.text == placeHolderText {
                    textView.text = ""
                }
            }
        }
        
        //        textChanged = true
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
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
    
    
    func textViewDidChange(textView: UITextView) {
        let selectedRange = self.textViewRichTextEditor.selectedRange
        
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
            
            if  (selectedRange.location + selectedRange.length) < self.textViewRichTextEditor.attributedText.length {
                self.checkForAttributes(rangeToModify)
            }
            
            
            self.removeBoldFormat(attributedString, rangeToModify: rangeToModify)
            self.removeItalicFormat(attributedString, rangeToModify: rangeToModify)
            self.removeUnderlineFormat(attributedString, rangeToModify: rangeToModify)
            
            if isBoldEnabled {
                self.addBoldFormat(attributedString, rangeToModify: rangeToModify)
            }
            //            else {
            //                self.removeBoldFormat(attributedString, rangeToModify: rangeToModify)
            //            }
            
            if isItalicEnabled {
                self.addItalicFormat(attributedString, rangeToModify: rangeToModify)
            }
            //            else {
            //                self.removeItalicFormat(attributedString, rangeToModify: rangeToModify)
            //            }
            
            if isUnderlineEnabled {
                self.addUnderlineFormat(attributedString, rangeToModify: rangeToModify)
            }
            //            else {
            //                self.removeUnderlineFormat(attributedString, rangeToModify: rangeToModify)
            //            }
            
            textView.attributedText = attributedString
            self.textViewRichTextEditor.attributedText = textView.attributedText
            self.richText = self.textViewRichTextEditor.attributedText
            self.textViewRichTextEditor.selectedRange = selectedRange
            self.tableView.tableHeaderView?.sizeToFit()
            let currentOffset = self.tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            self.tableView.setContentOffset(currentOffset, animated: false)
            
        }
        textChanged = false
    }
    
    func checkForAttributes(range: NSRange) {
        if self.textViewRichTextEditor.attributedText.string == placeHolderText || (self.isBoldButtonPressed || self.isItalicButtonPressed || self.isUnderlinedButtonPressed) {
            return
        }
        
        var isBold = false
        var isItalic = false
        var isUnderlined = false
        
        var rangeToCheck = range
        if rangeToCheck.length == 0 {
            if rangeToCheck.location > 0 && rangeToCheck.location <= self.textViewRichTextEditor.attributedText.length {
                rangeToCheck = NSMakeRange(rangeToCheck.location-1, rangeToCheck.length+1)
            }
        }
        
        self.textViewRichTextEditor.attributedText.enumerateAttributesInRange(rangeToCheck, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (object, range, stop) in
            if object.keys.contains(NSFontAttributeName) {
                if let font = object[NSFontAttributeName] as? UIFont {
                    if font.isBold {
                        isBold = true
                        debug_print("Bold attribute")
                    }
                    if font.isItalic {
                        isItalic = true
                        debug_print("Italic attribute")
                    }
                    if object.keys.contains(NSUnderlineStyleAttributeName) {
                        isUnderlined = true
                        debug_print("Underline attribute")
                    }
                }
            } else if object.keys.contains(NSUnderlineStyleAttributeName) {
                isUnderlined = true
                debug_print("Underline attribute")
            } else {
                debug_print("no attribute")
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
            self.richFormatterView.boldButton.selected = true
            self.richFormatterView.boldButton.backgroundColor = ColorUtils.whiteColor()
        } else {
            self.richFormatterView.boldButton.selected = false
            self.richFormatterView.boldButton.backgroundColor = ColorUtils.blueColor()
        }
        
        //        self.richFormatterView.italicsButton.selected = self.isItalicEnabled
        if self.isItalicEnabled {
            self.richFormatterView.italicsButton.selected = true
            self.richFormatterView.italicsButton.backgroundColor = ColorUtils.whiteColor()
        } else {
            self.richFormatterView.italicsButton.selected = false
            self.richFormatterView.italicsButton.backgroundColor = ColorUtils.blueColor()
        }
        
        
        //        self.richFormatterView.underlinedButton.selected = self.isUnderlineEnabled
        if self.isUnderlineEnabled {
            self.richFormatterView.underlinedButton.selected = true
            self.richFormatterView.underlinedButton.backgroundColor = ColorUtils.whiteColor()
        } else {
            self.richFormatterView.underlinedButton.selected = false
            self.richFormatterView.underlinedButton.backgroundColor = ColorUtils.blueColor()
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
        self.richFormatterView.boldButton.selected = false
        self.richFormatterView.boldButton.backgroundColor = ColorUtils.blueColor()
        
        self.richFormatterView.italicsButton.selected = false
        self.richFormatterView.italicsButton.backgroundColor = ColorUtils.blueColor()
        
        self.richFormatterView.underlinedButton.selected = false
        self.richFormatterView.underlinedButton.backgroundColor = ColorUtils.blueColor()
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
