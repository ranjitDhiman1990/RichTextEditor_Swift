//
//  RichTextFormatterView.swift
//  RichTextEditor_Swift
//
//  Created by iOS Dev on 03/04/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class RichTextFormatterView: UIView {

    @IBOutlet weak var boldButton: UIButton!
    @IBOutlet weak var italicsButton: UIButton!
    @IBOutlet weak var underlinedButton: UIButton!
    @IBOutlet weak var imageAtachmentButton: UIButton!
    
    
    var boldButtonTapAction: ((UIButton) -> Void)?
    var italicsButtonTapAction: ((UIButton) -> Void)?
    var underlinedButtonTapAction: ((UIButton) -> Void)?
    var imageAtachmentButtonTapAction: ((UIButton) -> Void)?
    
    var buttonBackgroungUnSelectedStateColor = UIColor.blueColor()
    var buttonBackgroundSelectedStateColor = UIColor.whiteColor()
    
    var buttonUnSelectedStateColor = UIColor.whiteColor()
    var buttonSelectedStateColor = UIColor.blueColor()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> RichTextFormatterView {
        return UINib(nibName: "RichTextFormatterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RichTextFormatterView
    }
    
    
    func roundedButton(sender: UIButton) -> UIButton {
        sender.layer.cornerRadius = 5
        sender.clipsToBounds = true
        return sender
    }
    
    func configureButtonsColor() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.boldButton.setTitle("Bold", forState: .Normal)
        self.boldButton.setTitle("Bold", forState: .Selected)
        self.boldButton.setTitleColor(buttonUnSelectedStateColor, forState: .Normal)
        self.boldButton.setTitleColor(buttonSelectedStateColor, forState: .Selected)
        self.boldButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.boldButton = self.roundedButton(self.boldButton)
        
        
        self.italicsButton.setTitle("Italics", forState: .Normal)
        self.italicsButton.setTitle("Italics", forState: .Selected)
        self.italicsButton.setTitleColor(buttonUnSelectedStateColor, forState: .Normal)
        self.italicsButton.setTitleColor(buttonSelectedStateColor, forState: .Selected)
        self.italicsButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.italicsButton = self.roundedButton(self.italicsButton)
        
        
        self.underlinedButton.setTitle("Underline", forState: .Normal)
        self.underlinedButton.setTitle("Underline", forState: .Selected)
        self.underlinedButton.setTitleColor(buttonUnSelectedStateColor, forState: .Normal)
        self.underlinedButton.setTitleColor(buttonSelectedStateColor, forState: .Selected)
        self.underlinedButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.underlinedButton = self.roundedButton(self.underlinedButton)
        
        
        self.boldButton.setTitle("Bold", forState: .Normal)
        self.boldButton.setTitleColor(buttonUnSelectedStateColor, forState: .Normal)
        self.boldButton.setTitleColor(buttonSelectedStateColor, forState: .Selected)
        self.boldButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.boldButton = self.roundedButton(self.boldButton)
    }
    
    @IBAction func boldButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender)
        boldButtonTapAction?(sender)
    }
    
    @IBAction func italicsButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender)
        italicsButtonTapAction?(sender)
    }
    
    @IBAction func underlinedButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender)
        underlinedButtonTapAction?(sender)
    }
    
    func setButtonBackgroundColor(sender: UIButton) {
        if !sender.selected {
            sender.backgroundColor = buttonBackgroundSelectedStateColor
        } else {
            sender.backgroundColor = buttonBackgroungUnSelectedStateColor
        }
    }
    
    @IBAction func imageAtachmentButtonTapped(sender: UIButton) {
        imageAtachmentButtonTapAction?(sender)
    }

}
