//
//  Elv8AadhaarViewController.swift
//  Stashfin
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import AVFoundation
import AVFoundation
import QRCodeReader

class Elv8AadhaarViewController: BaseLoginViewController, QRCodeReaderViewControllerDelegate {
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8AadhaarViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8AadhaarViewController
    }
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        qrSetup()
    }
    
    private func qrSetup(){
        
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        //        self.changeViewController(controllerName: Constants.Controllers.EL_DEBIT)
        
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let rslt=result{
                print("rslt: \(rslt)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    let alert=UIAlertController.init(title: "Aadhaar Scan!", message: "\nYou have successfully scanned a document! If you have scanned your Aadhaar Card, press 'Submit'." , preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Submit", style: .default, handler: {(_) -> Void in
                                            self.submitScanData(data: rslt.value);
                    }))
                    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert,animated: true,completion: nil)
                })
            
            }
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    private func submitScanData(data:String){
        let params=["scanResponse":data,"rawString":data,"mode":"elv8_aadhaarScanDoc"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            switch status{
            case .success:
                self.changeViewController(response: result)
            case .errors(let error):
                self.showToast(error)
            }
            
        }
        
        
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        //        if let cameraName = newCaptureDevice.device.localizedName {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
        //        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
