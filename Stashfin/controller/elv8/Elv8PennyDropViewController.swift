//
//  Elv8PennyDropViewController.swift
//  Stashfin
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class Elv8PennyDropViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8PennyDropViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8PennyDropViewController
    }
    
    var player: AVPlayer?
    @IBOutlet weak var videoViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeVideoPlayerWithVideo()
        
    }
    
 
    
    func initializeVideoPlayerWithVideo() {
        
        // get the path string for the video from assets
        let videoString:String? = Bundle.main.path(forResource: "elv8_peny_drop_flow", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        
        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl)
        
        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        // make the layer the same size as the container view
        layer.frame = videoViewContainer.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // add the layer to the container view
        videoViewContainer.layer.addSublayer(layer)
        if let ply =  player{
            ply.play()
        }
    }
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
//        self.changeViewController(controllerName: Constants.Controllers.EL_AADHAAR_SCAN)
        
        let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
        controller.url = ""
        controller.urlType = "elv8One"
        self.goToNextViewController(controller:controller)
        
    }
    
}
