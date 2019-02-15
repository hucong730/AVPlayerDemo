//
//  HCPlayerController.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/2/15.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit


class HCPlayerController: NSObject {
    
    private lazy var player: HCPlayer = {
        let player = HCPlayer()
        return player
    }()
    
    var playerView: UIView!
    
    var mediaUrls: [String]? {
        didSet {
            self.player.mediaUrls = mediaUrls
        }
    }
    
    override init() {
        super.init()
        self.playerView = self.player.playerView
        
    }
    
    func play() {
        self.player.play()
    }
    
    func playNext() {
        
    }
    
    func playPrev() {
        
    }
    
    func pause() {
        self.player.pause()
    }
    
    func resume() {
        self.player.resume()
    }
    
    func stop() {
        self.player.stop()
    }
}
