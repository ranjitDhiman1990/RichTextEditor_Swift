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
    
    override func viewDidAppear(animated: Bool) {
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
    
    
    @IBAction func txtFormatterButtonTapped(sender: UIButton) {
        if sender.tag == boldTag {
            if !sender.selected {
                self.richTextEditor.isBoldEnabled = true
            } else {
                self.richTextEditor.isBoldEnabled = false
            }
            
            sender.selected = !sender.selected
        } else if sender.tag == italicTag {
            if !sender.selected {
                self.richTextEditor.isItalicEnabled = true
            } else {
                self.richTextEditor.isItalicEnabled = false
            }
            
            sender.selected = !sender.selected
        } else if sender.tag == underlinedTag {
            if !sender.selected {
                self.richTextEditor.isUnderlineEnabled = true
            } else {
                self.richTextEditor.isUnderlineEnabled = false
            }
            
            sender.selected = !sender.selected
        } else if sender.tag == imageAttachmentTag {
//            if !sender.selected {
//                self.richTextEditor.isBoldEnabled = true
//            } else {
//                self.richTextEditor.isBoldEnabled = false
//            }
        }
        
        
    }

}
