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
    
    var buttonBackgroungUnSelectedStateColor = UIColor.blue
    var buttonBackgroundSelectedStateColor = UIColor.white
    
    var buttonUnSelectedStateColor = UIColor.white
    var buttonSelectedStateColor = UIColor.blue
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> RichTextFormatterView {
        return UINib(nibName: "RichTextFormatterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RichTextFormatterView
    }
    
    
    func roundedButton(sender: UIButton) -> UIButton {
        sender.layer.cornerRadius = 5
        sender.clipsToBounds = true
        return sender
    }
    
    func configureButtonsColor() {
        self.backgroundColor = UIColor.white
        
        self.boldButton.setTitle("Bold", for: .normal)
        self.boldButton.setTitle("Bold", for: .selected)
        self.boldButton.setTitleColor(buttonUnSelectedStateColor, for: .normal)
        self.boldButton.setTitleColor(buttonSelectedStateColor, for: .selected)
        self.boldButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.boldButton = self.roundedButton(sender: self.boldButton)
        
        
        self.italicsButton.setTitle("Italics", for: .normal)
        self.italicsButton.setTitle("Italics", for: .selected)
        self.italicsButton.setTitleColor(buttonUnSelectedStateColor, for: .normal)
        self.italicsButton.setTitleColor(buttonSelectedStateColor, for: .selected)
        self.italicsButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.italicsButton = self.roundedButton(sender: self.italicsButton)
        
        
        self.underlinedButton.setTitle("Underline", for: .normal)
        self.underlinedButton.setTitle("Underline", for: .selected)
        self.underlinedButton.setTitleColor(buttonUnSelectedStateColor, for: .normal)
        self.underlinedButton.setTitleColor(buttonSelectedStateColor, for: .selected)
        self.underlinedButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.underlinedButton = self.roundedButton(sender: self.underlinedButton)
        
        
        self.boldButton.setTitle("Bold", for: .normal)
        self.boldButton.setTitleColor(buttonUnSelectedStateColor, for: .normal)
        self.boldButton.setTitleColor(buttonSelectedStateColor, for: .selected)
        self.boldButton.backgroundColor = buttonBackgroungUnSelectedStateColor
        self.boldButton = self.roundedButton(sender: self.boldButton)
    }
    
    @IBAction func boldButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender: sender)
        boldButtonTapAction?(sender)
    }
    
    @IBAction func italicsButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender: sender)
        italicsButtonTapAction?(sender)
    }
    
    @IBAction func underlinedButtonTapped(sender: UIButton) {
        self.setButtonBackgroundColor(sender: sender)
        underlinedButtonTapAction?(sender)
    }
    
    func setButtonBackgroundColor(sender: UIButton) {
        if !sender.isSelected {
            sender.backgroundColor = buttonBackgroundSelectedStateColor
        } else {
            sender.backgroundColor = buttonBackgroungUnSelectedStateColor
        }
    }
    
    @IBAction func imageAtachmentButtonTapped(sender: UIButton) {
        imageAtachmentButtonTapAction?(sender)
    }

}
