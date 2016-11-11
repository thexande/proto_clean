//
//  CreatePollViewController.swift
//  proto
//
//  Created by Alexander Murphy on 10/26/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import UIKit
import Player
import AVFoundation

class CreatePollViewController: UIViewController, PlayerDelegate {
    
    var croppingEnabled: Bool = true
    var libraryEnabled: Bool = true
    private var player: Player!
    public var optionOneVideoURL: URL?
    public var optionTwoVideoURL: URL?
    public var selectedOption: Int?
    
    var Player1: Player = Player()
    var Player2: Player = Player()

    @IBOutlet weak var pollFormatSegment: UISegmentedControl!
    @IBOutlet weak var optionOneImageView: UIImageView!
    @IBOutlet weak var optionTwoImageView: UIImageView!
    @IBOutlet weak var optionOneVideoView: UIView!
    @IBOutlet weak var optionTwoVideoView: UIView!
    @IBOutlet weak var playOptionOneVideo: UIButton!
    @IBOutlet var mainView: UIView!
    
    // Interface Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure poll video player views
        self.configureVideoPlayer(playerInstance: self.Player1, playerView: self.optionOneVideoView)
        self.configureVideoPlayer(playerInstance: self.Player2, playerView: self.optionTwoVideoView)

        // crop circles
        ImageHelper.circleCrop(imageView: optionOneImageView)
        ImageHelper.circleCrop(imageView: optionTwoImageView)
        ViewHelper.circleCrop(view: optionOneVideoView)
        
        // set video preview images and bring to front
        if (self.optionOneVideoURL != nil) {
            self.optionOneImageView.image = VideoHelper.getVideoFirstFrame(videoURL: self.optionOneVideoURL!)
            mainView.bringSubview(toFront: optionOneVideoView)
            playVideo(videoURL: self.optionOneVideoURL!, playerInstance: Player1)
        }
        if (self.optionTwoVideoURL != nil) {
            self.optionTwoImageView.image = VideoHelper.getVideoFirstFrame(videoURL: self.optionTwoVideoURL!)
            mainView.bringSubview(toFront: optionOneVideoView)
            playVideo(videoURL: self.optionTwoVideoURL!, playerInstance: Player2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showVideoCamera") {
            let destination = segue.destination as! VideoCameraViewController
            destination.selectedOption = self.selectedOption
        }
    }
    
    func configureVideoPlayer(playerInstance: Player, playerView: UIView) {
        self.view.autoresizingMask = ([UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight])
        playerInstance.delegate = self
        playerInstance.view.frame = playerView.bounds
        self.addChildViewController(playerInstance)
        playerView.addSubview(playerInstance.view)
        playerInstance.didMove(toParentViewController: self)
        playerInstance.playbackLoops = false
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        playerInstance.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func playVideo(videoURL: URL, playerInstance: Player) {
        print("now playing video", videoURL)
        playerInstance.setUrl(videoURL)
        playerInstance.playFromBeginning()
    }
    
    // MARK: UIGestureRecognizer
    
    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        // handle player 1 tap
        switch (Player1.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            Player1.playFromBeginning()
        case PlaybackState.paused.rawValue:
            Player1.playFromCurrentTime()
        case PlaybackState.playing.rawValue:
            Player1.pause()
        case PlaybackState.failed.rawValue:
            Player1.pause()
        default:
            Player1.pause()
        }
        // handle player 2 tap
        switch (Player2.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            Player2.playFromBeginning()
        case PlaybackState.paused.rawValue:
            Player2.playFromCurrentTime()
        case PlaybackState.playing.rawValue:
            Player2.pause()
        case PlaybackState.failed.rawValue:
            Player2.pause()
        default:
            Player2.pause()
        }
    }
    
    // MARK: PlayerDelegate
    
    func playerReady(_ player: Player) {
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerWillComeThroughLoop(_ player: Player) {
        
    }
    
    func currentSegmentState() -> String {
        if(pollFormatSegment.selectedSegmentIndex == 0) {
            return "photo"
        }
        else if(pollFormatSegment.selectedSegmentIndex == 1) {
            return "video"
        }
        else if(pollFormatSegment.selectedSegmentIndex == 2) {
            return "voice"
        } else {
            return "none"
        }
    }
    
    @IBAction func addOptionOne(_ sender: AnyObject) {
        
        if(currentSegmentState() == "photo"){
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                //self?.imageView.image = image
                self?.optionOneImageView.image = image
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
        else if(currentSegmentState() == "video") {
            // have we recorded video yet?
            if(self.optionOneVideoURL != nil) {
                self.mainView.bringSubview(toFront: optionOneVideoView)
                self.playVideo(videoURL: self.optionOneVideoURL!, playerInstance: Player1)
            } else {
                self.selectedOption = 1
                performSegue(withIdentifier: "showVideoCamera", sender: self)
            }
        }
//        else if(currentSegmetState() == "voice" {
//            
//        }
    }
   
   
    @IBAction func addOptionTwo(_ sender: AnyObject) {
        if(currentSegmentState() == "photo"){
            let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                //self?.imageView.image = image
                self?.optionTwoImageView.image = image
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
        else if(currentSegmentState() == "video") {
            // have we recorded video yet?
            if(self.optionTwoVideoURL != nil) {
                self.mainView.bringSubview(toFront: optionOneVideoView)
                self.playVideo(videoURL: self.optionTwoVideoURL!, playerInstance: Player1)
            } else {
                self.selectedOption = 2
                performSegue(withIdentifier: "showVideoCamera", sender: self)
            }
        }
//        else if(currentSegmentState() == "voice" {
//            
//        }
    }

    @IBAction func pollFormatChange(_ sender: AnyObject) {

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
