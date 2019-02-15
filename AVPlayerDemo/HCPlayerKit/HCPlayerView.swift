//
//  HCPlayerView.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/21.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit
import AVFoundation

class HCPlayerView: UIView {
    
    private var _playerControlView: HCPlayerControlView = {
        let view = HCPlayerControlView()
        return view
    }()
    
    private var _playerLayer: AVPlayerLayer!
    

    init(frame: CGRect, player: AVPlayer) {
        super.init(frame: frame)
        self._playerLayer = AVPlayerLayer(player: player)
        self.initPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initPlayerView() {
        self.layer.addSublayer(self._playerLayer)
//        self._playerLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(self._playerControlView)
        self._playerControlView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds.width > 0 {
            self._playerLayer.frame = self.bounds
        }
    }
    
    
    /// 更新播放进度
    ///
    /// - Parameter progress: 播放进度
    func updatePlay(progress: Float) {
        self._playerControlView.updatePlay(progress: progress)
    }
    
    /// 更新当前播放时间
    ///
    /// - Parameter time: 时间
    func updatePlay(time: UInt) {
        self._playerControlView.updatePlayTime(time)
    }
    
    /// 设置播放总时长
    ///
    /// - Parameter totalTimeLength: 总时长
    func setPlay(totalTimeLength: UInt) {
        self._playerControlView.setTimeLength(totalTimeLength)
    }
    
    
    /// 更新缓存进度
    ///
    /// - Parameter progress: 缓存进度
    func updateCache(progress: Float) {
        self._playerControlView.updateCache(progress: progress)
    }
    
    
}
