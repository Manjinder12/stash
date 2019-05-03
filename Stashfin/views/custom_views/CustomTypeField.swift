//
//  RCUiTextField.swift
//  StashFinDemo
//
//  Created by Macbook on 12/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView


@IBDesignable
class CustomUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame:frame)
        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        updateView()
    }

    @IBInspectable var fontSize:CGFloat{
        get {
            return self.font?.pointSize ?? 15.0
        }
        set {
            self.font =  UIFont(name: Fonts.avenirNextRegular,size:newValue)!
            self.sizeToFit()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        updateView()
    }
//
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateView()
//    }
    
    func updateView() {
        autocorrectionType = .no
        clipsToBounds = true
        font = UIFont(name: Fonts.avenirNextRegular,size:fontSize)
        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = UIFont(name: Fonts.avenirNextRegular, size: fontSize)!
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont])

        let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))

        // left
        leftView              = indentView
        leftViewMode          = .always

        // right
        rightView = indentView
        rightViewMode = .always
    }
}

//class DropDownButton: UIButton {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        setImage(UIImage(named: "drop-down-arrow"), for: .normal)
//
//        sizeToFit()
//
//        titleEdgeInsets = UIEdgeInsets(top: 0, left: bounds.width - 17.0, bottom: 0, right: 0)
//        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
//    }
//}

@IBDesignable
class DropDownButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame:frame)
        setUpButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setUpButton()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setUpButton()
//    }
    override func prepareForInterfaceBuilder() {
        setUpButton()
    }

    
    func setUpButton() {

        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.25;
        layer.cornerRadius = 5.0;
//        setImage(#imageLiteral(resourceName: "drop-down-arrow"), for: .normal)
//        sizeToFit()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - 18), bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
            imageView?.contentMode = .scaleAspectFit

//            titleEdgeInsets = UIEdgeInsets(top: 0, left: bounds.width - 17.0, bottom: 0, right: 0)
//            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
        
        
        titleLabel?.font =  UIFont(name: Fonts.avenirNextRegular, size: 15.0)
//        titleLabel?.adjustsFontSizeToFitWidth = true
        setTitleColor(UIColor.black, for: [])
    }
}

@IBDesignable
class RCButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUpButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setUpButton()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setUpButton()
//    }
    override func prepareForInterfaceBuilder() {
        setUpButton()
    }

    func setUpButton() {
        layer.cornerRadius = 0.50 * frame.height
        frame.size.height = 40
        self.clipsToBounds = true
        setTitleColor(UIColor.white, for: [])
    }
}

@IBDesignable
class CustomUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupField()
    }

    override func prepareForInterfaceBuilder() {
        setupField()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupField()
//    }
    
//    @IBInspectable var textColors: UIColor? = .black
    @IBInspectable var textColors: UIColor? = UIColor.black {
        didSet {
            self.textColor = textColors!
        }
    }
    
    @IBInspectable var fontSize:CGFloat{
        get{
            return self.font?.pointSize ?? 15.0
        }
        set{
            self.font = UIFont(name: Fonts.avenirNextRegular, size: newValue)
            self.sizeToFit()
        }
    }
//
    func setupField(){
//        textColor = textColors?.cgColor
        font = UIFont(name: Fonts.avenirNextRegular, size: fontSize)
//        backgroundColor = UIColor(white: 1, alpha: 0.5)
        clipsToBounds = true
    }
}


@IBDesignable
class CustomUILabelBold: UILabel {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupField()
    }
    
    override func prepareForInterfaceBuilder() {
        setupField()
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        setupField()
    //    }
    @IBInspectable var textColors: UIColor? = UIColor.black {
        didSet {
            self.textColor = textColors!
        }
    }
    
    @IBInspectable var fontSize:CGFloat{
        get{
            return self.font?.pointSize ?? 15.0
        }
        set{
            self.font = UIFont(name: Fonts.avenirNextBold, size: newValue)
            self.sizeToFit()
        }
    }
    //
    func setupField(){
        font = UIFont(name: Fonts.avenirNextBold, size: fontSize)
        //        backgroundColor = UIColor(white: 1, alpha: 0.5)
        clipsToBounds = true
    }
}


@IBDesignable
class RoundPagerView: FSPagerView{
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
}

@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
}

@IBDesignable
class CardView: RoundUIView {
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = .black
    @IBInspectable var shadowOpacity: Float = 0.2
    
    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}

@IBDesignable class SeparatorStackView: UIStackView {
    
    @IBInspectable var separatorColor: UIColor? = .black {
        didSet {
            invalidateSeparators()
        }
    }
    @IBInspectable var separatorWidth: CGFloat = 0.5 {
        didSet {
            invalidateSeparators()
        }
    }
    @IBInspectable private var separatorTopPadding: CGFloat = 0 {
        didSet {
            separatorInsets.top = separatorTopPadding
        }
    }
    @IBInspectable private var separatorBottomPadding: CGFloat = 0 {
        didSet {
            separatorInsets.bottom = separatorBottomPadding
        }
    }
    @IBInspectable private var separatorLeftPadding: CGFloat = 0 {
        didSet {
            separatorInsets.left = separatorLeftPadding
        }
    }
    @IBInspectable private var separatorRightPadding: CGFloat = 0 {
        didSet {
            separatorInsets.right = separatorRightPadding
        }
    }
    
    var separatorInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateSeparators()
        }
    }
    
    private var separators: [UIView] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateSeparators()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        invalidateSeparators()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        invalidateSeparators()
    }
    
    
    private func invalidateSeparators() {
        guard arrangedSubviews.count > 1 else {
            separators.forEach({$0.removeFromSuperview()})
            separators.removeAll()
            return
        }
        
        if separators.count > arrangedSubviews.count {
            separators.removeLast(separators.count - arrangedSubviews.count)
        } else if separators.count < arrangedSubviews.count {
            separators += Array<UIView>(repeating: UIView(), count: arrangedSubviews.count - separators.count)
        }
        
        separators.forEach({$0.backgroundColor = self.separatorColor; self.addSubview($0)})
        
        for (index, subview) in arrangedSubviews.enumerated() where arrangedSubviews.count >= index + 2 {
            let nextSubview = arrangedSubviews[index + 1]
            let separator = separators[index]
            
            let origin: CGPoint
            let size: CGSize
            
            if axis == .horizontal {
                let originX = (nextSubview.frame.maxX - subview.frame.minX)/2 + separatorInsets.left - separatorInsets.right
                origin = CGPoint(x: originX, y: separatorInsets.top)
                let height = frame.height - separatorInsets.bottom - separatorInsets.top
                size = CGSize(width: separatorWidth, height: height)
            } else {
                let originY = (nextSubview.frame.maxY - subview.frame.minY)/2 + separatorInsets.top - separatorInsets.bottom
                origin = CGPoint(x: separatorInsets.left, y: originY)
                let width = frame.width - separatorInsets.left - separatorInsets.right
                size = CGSize(width: width, height: separatorWidth)
            }
            
            separator.frame = CGRect(origin: origin, size: size)
        }
    }
}
