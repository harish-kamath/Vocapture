//
//  ViewController.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        setupView()
    }
    
    func setupView() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "yolo_v3_1080p", ofType: "mov")!)
        let player = AVPlayer(url: path)
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        self.viewWithTag("loginMainView").sendSubviewToBack(videoView)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        
        NotificationCenter.default.addObserver(self, selector:  #selector(LoginVC.videoDidPlayToEnd(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
    }
    
    @objc func videoDidPlayToEnd(_ notification: Notification) {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero)
    }

//    var avPlayer: AVPlayer!
//    var avPlayerLayer: AVPlayerLayer!
//    var paused: Bool = false

//    override func viewDidLoad() {
//
//        let theURL = Bundle.main.url(forResource: "yolo_v3_1080p", withExtension: "mp4")
//
//        avPlayer = AVPlayer(url: theURL!)
//        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        avPlayer.volume = 0
//        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
//
//        avPlayerLayer.frame = view.layer.bounds
//        view.backgroundColor = UIColor.clear;
//        view.layer.insertSublayer(avPlayerLayer, at: 0)
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: Selector("playerItemDidReachEnd:"),
//                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                                         object: avPlayer.currentItem)
//    }
//
//    func playerItemDidReachEnd(notification: NSNotification) {
//        let p: AVPlayerItem = notification.object as! AVPlayerItem
//        p.seek(to: CMTime.zero)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        avPlayer.play()
//        paused = false
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        avPlayer.pause()
//        paused = true
//    }
}


