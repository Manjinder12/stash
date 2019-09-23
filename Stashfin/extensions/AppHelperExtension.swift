//
//  AppHelperExtension.swift
//  StashFinDemo
//
//  Created by Macbook on 11/03/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import MBProgressHUD
import Toast_Swift

extension UIViewController {
    func showProgress(_ progressLabel:String = ""){
        DispatchQueue.main.async {
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.mode = MBProgressHUDMode.indeterminate
            progressHUD.label.text = progressLabel
            progressHUD.contentColor = Colors.white
            progressHUD.bezelView.color = Colors.black
            progressHUD.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
            
            progressHUD.backgroundView.style=MBProgressHUDBackgroundStyle.init(rawValue: 14) ?? MBProgressHUDBackgroundStyle.solidColor
        }
    }
    
    func hideProgress(_ isAnimated:Bool=true) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
            self.view.alpha = 1.0
        }
    }
    
    func showToast(_ message:String, showDialog:Bool=false, title:String="Alert") {
        if showDialog{
            
            DispatchQueue.main.async {
                let alert = UIAlertController.init(title: title, message: "\n\(message)", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(alert,animated: true,completion: nil)
            }
        }else{
            self.view.makeToast(message, duration: 3.0, position: .center)
        }
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage, number: Int=2) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / CGFloat(number)
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}


enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        var base64String:String?
        
        switch format {
        case .png:
            imageData = self.pngData()
            if let img = imageData?.base64EncodedString(){
                base64String = "data:image/png;base64,"+img
            }
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
            
            if let img = imageData?.base64EncodedString(){
                base64String = "data:image/jpeg;base64,"+img
            }
        }
        
        return base64String
    }
}

extension String {
    func imageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}

extension UIImage {
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        var newRect = CGRect(origin: .zero, size: CGSize(width: size.width*percentage, height: size.height*percentage))
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        self.draw(in: newRect)
        defer {UIGraphicsEndImageContext()}
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(MB: Double) -> UIImage? {
        guard let fileSize = self.pngData()?.count else {return nil}
        let fileSizeInMB = CGFloat(fileSize)/(1024.0*1024.0)//form bytes to MB
        let percentage = 1/fileSizeInMB
        return resize(withPercentage: percentage)
    }
}

extension Data{
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

extension String{
    func toData() ->Data? {
        return self.data(using: .utf8, allowLossyConversion: true)
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}


class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}

public class CustomTableView: UITableView {
    
    override public func reloadData() {
        super.reloadData()
        
        if self.numberOfRows(inSection: 0) == 0 {
            if self.viewWithTag(1111) == nil {
                let noDataLabel = UILabel()
                noDataLabel.textAlignment = .center
                noDataLabel.text = "No Data Available"
                noDataLabel.tag = 1111
                noDataLabel.center = self.center
                self.backgroundView = noDataLabel
            }
            
        } else {
            if self.viewWithTag(1111) != nil {
                self.backgroundView = nil
            }
        }
    }
}


extension UITextView {
    
    
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        
//        let style = NSMutableParagraphStyle()
//        style.alignment = .left
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
//        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: fullRange)
        
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: linkRange)
  attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)
        
        self.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.blue,
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,
            ] as [NSAttributedString.Key : Any]
        
        self.attributedText = attributedOriginalText
    }
    
}

//import CommonCrypto
extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

extension UIImage {
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
