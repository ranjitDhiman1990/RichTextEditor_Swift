//
//  RichTextViewController.swift
//  RichTextEditor_Swift
//
//  Created by iOS Dev on 03/04/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import RichTextEditor_Swift

class RichTextViewController: UIViewController {

    @IBOutlet weak var richTextEditor: RichTextEditor!
    
    @IBOutlet weak var buttonBold: UIButton!
    @IBOutlet weak var buttonItalic: UIButton!
    @IBOutlet weak var buttonUnderlined: UIButton!
    @IBOutlet weak var buttonImageAttachment: UIButton!
    
    let boldTag = 101
    let italicTag = 102
    let underlinedTag = 103
    let imageAttachmentTag = 104
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonBold.tag = boldTag
        self.buttonItalic.tag = italicTag
        self.buttonUnderlined.tag = underlinedTag
        self.buttonImageAttachment.tag = imageAttachmentTag
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.richTextEditor.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func generateHTMLString(sender: UIBarButtonItem) {
        print("The html string = \(self.richTextEditor.attributedText.generateHtmlString())")
    }
    
    
    @IBAction func txtFormatterButtonTapped(sender: UIButton) {
        if sender.tag == boldTag {
            self.richTextEditor.formatBoldSeletedText()
            sender.isSelected = !sender.isSelected
        } else if sender.tag == italicTag {
            self.richTextEditor.formatItalicSeletedText()
            sender.isSelected = !sender.isSelected
        } else if sender.tag == underlinedTag {
            self.richTextEditor.formatUnderlinedSeletedText()
            sender.isSelected = !sender.isSelected
        } else if sender.tag == imageAttachmentTag {

        }
    }
}



public extension NSAttributedString {
    func generateHtmlString(isRemoveFontStyle: Bool = false) -> String {
        let range = NSMakeRange(0, self.length)
        var htmlString = ""
        self.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
            
            if object.keys.contains(NSAttachmentAttributeName) {
                if let attachment = object[NSAttachmentAttributeName] as? NSTextAttachment {
                    print(attachment)
                }
            } else if object.keys.contains(NSFontAttributeName) {
                if let font = object[NSFontAttributeName] as? UIFont {
                    var currentString = self.attributedSubstring(from: range).string
                    currentString = currentString.replacingOccurrences(of: "\n", with: "<br>")
                    var stringToAppend = ""
                    var isBold = false
                    var isItalic = false
                    var isUnderlined = false
                    
                    if font.isBold {
                        isBold = true
                        if !currentString.isEmpty {
                            stringToAppend = stringToAppend + "<b>"
                        }
                    }
                    if font.isItalic {
                        isItalic = true
                        if !currentString.isEmpty {
                            stringToAppend = stringToAppend + "<i>"
                        }
                    }
                    if object.keys.contains(NSUnderlineStyleAttributeName) {
                        isUnderlined = true
                        stringToAppend = stringToAppend + "<u>"
                    }
                    
                    if !currentString.isEmpty {
                        htmlString = htmlString + stringToAppend + currentString
                        if isBold {
                            htmlString = htmlString + "</b>"
                        }
                        if isItalic {
                            htmlString = htmlString + "</i>"
                        }
                        if isUnderlined {
                            htmlString = htmlString + "</u>"
                        }
                    }
                    
                }
            } else if object.keys.contains(NSUnderlineStyleAttributeName) {
                if let _ = object[NSUnderlineStyleAttributeName] as? NSUnderlineStyle {
                    var currentString = self.attributedSubstring(from: range).string
                    currentString = currentString.replacingOccurrences(of: "\n", with: "<br>")
                    if !currentString.isEmpty {
                        htmlString = htmlString + "<u>" + currentString + "</u>"
                    } else {
                        htmlString = htmlString + "<u>" + "</u>"
                    }
                }
            } else {
                var currentString : String = self.attributedSubstring(from: range).string
                currentString = currentString.replacingOccurrences(of: "\n", with: "<br>")
                if !currentString.isEmpty {
                    htmlString = htmlString + currentString
                }
            }
        }
        
        return htmlString
    }
}
