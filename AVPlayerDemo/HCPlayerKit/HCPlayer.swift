//
//  HCPlayer.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/21.
//  Copyright © 2019 胡聪. All rights reserved.
//
import AVFoundation

class HCPlayer {
    
    
    private var _player: AVQueuePlayer!
    private var _timeObserver: Any!
    var playerView: HCPlayerView!
    
    
    var mediaUrls: [String]? {
        didSet {
            self.list.removeAll()
            self._player.removeAllItems()
            guard let urls = mediaUrls else { return }
            for url in urls {
                let mediaItem = HCMediaItem(url: url)
                self.list.append(mediaItem)
                self._player.insert(mediaItem.playerItem, after: nil)
            }
        }
    }
    
    private lazy var list = [HCMediaItem]()
//    private lazy var cache = NSCache()
    
    init() {
        //初始化播放器
        self.initPlayer()
        //初始化播放视图
        self.initPlayerView()
    }
    
    func initPlayerView() {
        self.playerView = HCPlayerView(frame: CGRect.zero, player: self._player)
    }

    private func initPlayer() {
        self._player = AVQueuePlayer()
        
        self._timeObserver = self._player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            if let currentItem = self?._player.currentItem {
                //更新播放时间
                let playTime = CMTimeGetSeconds(currentItem.currentTime())
                self?.playerView.updatePlay(time: UInt(playTime))
                
                //设置播放进度
                let progress = playTime / CMTimeGetSeconds(currentItem.asset.duration)
                self?.playerView.updatePlay(progress: Float(progress))
            }
        }
        
        //更新缓存进度
        self._player.cacheProgressBlock = {
            [weak self] progress in
            self?.playerView.updateCache(progress: progress)
        }
        
        //获取视频大小
        self._player.mediaItem?.videoSizeBlock = {
            videoSize in
        }
        
        //获取视频播放时长
        self._player.videoTimeLengthBlock = {
            [weak self] videoTimeLength in
            self?.playerView.setPlay(totalTimeLength: videoTimeLength)
        }
    }
    
    func play() {
        self._player.mediaItem?.reset()
        self._player.mediaItem = self.list.first
        self._player.play()
    }
    
    func pause() {
        self._player.pause()
    }
    
    func resume() {
        self._player.play()
    }
    
    func stop() {
        self._player.pause()
        self._player.cancelPendingPrerolls()
    }
    
    deinit {
        //释放资源
//        self._player.automaticallyWaitsToMinimizeStalling
        self._player.removeAllItems()
        self._player.removeTimeObserver(self._timeObserver)
    }
}

private var mediaItemKey: Void?
private var cacheProgressBlockKey: Void?
private var videoTimeLengthBlockKey: Void?
extension AVPlayer {
    var mediaItem: HCMediaItem? {
        set {
            objc_setAssociatedObject(self, &mediaItemKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            newValue?.cacheProgressBlock = {
                [weak self] progress in
                self?.cacheProgressBlock?(progress)
            }
            
            newValue?.videoTimeLengthBlock = {
                [weak self] timeLenth in
                self?.videoTimeLengthBlock?(timeLenth)
            }
        }
        get {
            return objc_getAssociatedObject(self, &mediaItemKey) as? HCMediaItem
        }
    }
    
    var cacheProgressBlock: ((Float) -> Void)? {
        set {
            objc_setAssociatedObject(self, &cacheProgressBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &cacheProgressBlockKey) as? (Float) -> Void
        }
    }
    
    var videoTimeLengthBlock: ((UInt) -> Void)? {
        set {
            objc_setAssociatedObject(self, &videoTimeLengthBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &videoTimeLengthBlockKey) as? (UInt) -> Void
        }
    }
}
