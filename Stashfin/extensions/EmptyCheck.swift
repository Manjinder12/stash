//
//  EmptyCheck.swift
//  StashFinDemo
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import Foundation


extension Optional where Wrapped==String{
    var isNilOrEmpty:Bool{
        return self?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
    }
}

extension Optional where Wrapped==String{
    var isNilOrValue : String{
        guard  let value=self, !(value.isEmpty) else {
            return ""
        }
        return value
    }
}

extension String {
    
    func hmac() -> String {
        let key: String = "c67a0844433cd8f543373638fe9372835f0131935e3b4936a3a393aa19aa0bd6"
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UITextField {
    func isEditBoxNotEmpty(hint:String = "* Required") -> Bool {
        if(self.text.isNilOrEmpty){
            self.becomeFirstResponder()
            self.attributedPlaceholder = NSAttributedString(string: hint, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            let baseColor: CGColor = UIColor.red.cgColor
            let numberOfShakes: Float = 3
            //            let revert: Bool = true
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
            animation.fromValue = baseColor
            animation.toValue = UIColor.red.cgColor
            animation.duration = 0.4
            animation.autoreverses = true
            //            if revert { animation.autoreverses = true } else { animation.autoreverses = false }
            self.layer.add(animation, forKey: "")
            
            let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
            shake.duration = 0.08
            shake.repeatCount = numberOfShakes
            shake.autoreverses = true
            //            if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
            shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
            shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
            self.layer.add(shake, forKey: "position")
            return false
        }else{
            self.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            return true
        }
        
    }
}
