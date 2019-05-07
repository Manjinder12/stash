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
