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

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.present(self.storyboard!.instantiateViewController(withIdentifier: "LoginView"), animated: true, completion:nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed Login")
        
        if !(result.isCancelled){
        
        self.present(self.storyboard!.instantiateViewController(withIdentifier: "cameraView"), animated: true, completion:nil)
        }
    }
    
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var skipLoginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var dontHaveAccountLabel: UILabel!
    @IBOutlet var logo: UIImageView!
//    @IBOutlet var loginSelector: UISegmentedControl!
    @IBOutlet var usernameInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var FBLoginButton: FBSDKLoginButton!
    
    
//    let FBLoginButton : FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
    
    func fetchProfile() {
        print("fetch profile")
        self.present(self.storyboard!.instantiateViewController(withIdentifier: "cameraView"), animated: true, completion:nil)
        let parameters = ["fields": "email, first name, last name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {
            (connection, result, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
    
            
//            if let email = result!["email"] as? String {
//                print(email)
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        setupVideo()
        setupSelector()
        
        FBLoginButton = {
            let button = FBSDKLoginButton()
            button.readPermissions = ["email"]
            return button
        }()
        
        view.addSubview(FBLoginButton)
        FBLoginButton.center = view.center
        FBLoginButton.delegate = self
        
        let t = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
            
            print("fd")
            print(FBSDKAccessToken.current())
            if let token = FBSDKAccessToken.current() {
                self.fetchProfile()
                
            }
        })
        
        
        loginButton.layer.cornerRadius = loginButton.frame.size.width / 6
        skipLoginButton.layer.cornerRadius = skipLoginButton.frame.size.width / 6
        signUpButton.layer.cornerRadius = signUpButton.frame.size.width / 6
        
        // not rounding corners as intended, likely bc it's not a button
        dontHaveAccountLabel.layer.cornerRadius = dontHaveAccountLabel.frame.size.width / 6
        
        loginButton.isHidden = true
        skipLoginButton.isHidden = true
        signUpButton.isHidden = true
        dontHaveAccountLabel.isHidden = true
        usernameInput.isHidden = true
        passwordInput.isHidden = true
        
    }
    
    
    func setupVideo() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "yolo_v3_1080p", ofType: "mov")!)
        let player = AVPlayer(url: path)
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        self.mainView.sendSubviewToBack(videoView)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        
        NotificationCenter.default.addObserver(self, selector:  #selector(LoginVC.videoDidPlayToEnd(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
        
    }
    
    func setupSelector() {
        let signInOption = NSLocalizedString("Sign In", comment: "Sign into an existing account")
        let signUpOption = NSLocalizedString("Sign Up", comment: "Create a new Account")
        
        let loginSelector = UISegmentedControl(items: [signInOption, signUpOption])
        
        loginSelector.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loginSelector.selectedSegmentIndex = 0
       
        
//        loginSelector.addTarget(self,
//                                   action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        loginSelector.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(loginSelector)
        
        let topConstraint = loginSelector.topAnchor.constraint(equalTo: logo.safeAreaLayoutGuide.bottomAnchor, constant: 8)

        let margins = logo.layoutMarginsGuide

        let leadingConstraint = loginSelector.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = loginSelector.trailingAnchor.constraint(equalTo: margins.trailingAnchor)

        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        loginSelector.isHidden = true
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


