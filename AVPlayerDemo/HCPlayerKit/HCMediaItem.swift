//
//  HCMediaItem.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/25.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit
import AVFoundation

typealias HCHttpParameter = [String: String]

class HCMediaItem: NSObject {
    
    var canPlayBlock: (() -> ())?
    var canResumePlayBlock: (() -> ())?
    var pauseAndLoadingBlock: (() -> ())?
    var videoSizeBlock: ((CGSize) -> ())?
    var videoTimeLengthBlock: ((UInt) -> ())?
    var cacheProgressBlock: ((Float) -> ())?
    
    var url: URL {
        return _url
    }
    
    var playerItem: AVPlayerItem {
        return _playerItem
    }
    
    var videoSize: CGSize {
        return _videoSize
    }
    
    var videoTotalSeconds: CFTimeInterval {
        return _videoTotalSeconds
    }

    private var _asset: AVURLAsset!
    private var _playerItem: AVPlayerItem!
    private var _url: URL!
    private var _videoSize: CGSize = CGSize.zero
    private var _videoTotalSeconds: CFTimeInterval = 0
    init(url: String, http headers: HCHttpParameter? = nil) {
        super.init()
        self._url = URL(string: url) ?? URL(string: "")!
        if headers == nil {
            self._asset = AVURLAsset(url: self._url)
        } else {
            self._asset = AVURLAsset(url: self._url, options: ["AVURLAssetHTTPHeaderFieldsKey" : headers!])
        }
//        self._asset.resourceLoader.setDelegate(self, queue: nil)
        self._playerItem = AVPlayerItem(asset: self._asset)
        
        //获取视频时间和大小
        self._asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            DispatchQueue.main.async {
                [weak self] in

                let videoSize = self?._asset.tracks(withMediaType: .video).first?.naturalSize ?? CGSize.zero
                let videoTotalSeconds = CMTimeGetSeconds(self?._asset.duration ?? CMTime(value: 0, timescale: 0))
                self?._videoSize = videoSize
                self?._videoTotalSeconds = videoTotalSeconds
                print("视频大小：\(videoSize), 视频长度：\(videoTotalSeconds)")
                self?.videoSizeBlock?(videoSize)
                self?.videoTimeLengthBlock?(UInt(videoTotalSeconds))
            }
        }
        
        self._playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self._playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self._playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self._playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            switch self.playerItem.status {
            case .readyToPlay:
                //可以开始播放
                self.canPlayBlock?()
            default:
                fatalError("play error")
            }
        }
        
        if keyPath == "loadedTimeRanges" {
            //获取缓冲总进度
            let loadedTimeRanges = self._playerItem.loadedTimeRanges
            //获取缓冲区域
            if loadedTimeRanges.count > 0 {
                let timeRange = loadedTimeRanges[0].timeRangeValue
                //开始时间
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                //已经缓冲的时间
                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
                //计算缓冲总时间
                let totalSeconds = startSeconds + durationSeconds
                //缓冲进度
                
                let cacheProgress = totalSeconds / self._videoTotalSeconds
                print("缓冲进度：\(cacheProgress)")
                self.cacheProgressBlock?(Float(cacheProgress))
            }
        }
        
        if keyPath == "playbackLikelyToKeepUp" {
            if self.playerItem.isPlaybackLikelyToKeepUp {
                //缓冲够了，可以继续播放
                self.canResumePlayBlock?()
            }
        }
        
        if keyPath == "playbackBufferEmpty" {
            if self.playerItem.isPlaybackBufferEmpty {
                //缓冲不够，暂停播放
                self.pauseAndLoadingBlock?()
            }
        }
    }
    
    func reset() {
        self.canPlayBlock = nil
        self.canResumePlayBlock = nil
        self.pauseAndLoadingBlock = nil
        self.videoSizeBlock = nil
        self.videoTimeLengthBlock = nil
        self.cacheProgressBlock = nil
    }
    
    deinit {
        self._playerItem.removeObserver(self, forKeyPath: "status")
        self._playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self._playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self._playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
}


//extension HCMediaItem: AVAssetResourceLoaderDelegate {
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
//
//
//
//        return true
//    }
//}

