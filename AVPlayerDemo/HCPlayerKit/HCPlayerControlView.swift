//
//  HCPlayerControlView.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/25.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit
import SnapKit

class HCPlayerControlView: UIView {

    /// 滚动条，控制视频进度
    private lazy var _slider: UISlider = {
        let slider = UISlider()
        slider.maximumTrackTintColor = UIColor.lightGray
        slider.minimumTrackTintColor = UIColor.white
        slider.setThumbImage(UIColor.white.createImage(size: CGSize(width: 10, height: 10))?.image(with: 5), for: UIControl.State.normal)
        return slider
    }()
    
    /// 当前播放时间
    private lazy var _currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    /// 总播放时间
    private lazy var _totalTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    /// 弹幕按钮
    private lazy var _barrageBtn: HCButton = {
        let btn = HCButton()
        return btn
    }()

    /// 横竖屏按钮
    private lazy var _landscapeBtn: HCButton = {
        let btn = HCButton()
        return btn
    }()
    
    /// 播放进度条，显示视频播放进度
    private lazy var _playProgressBar: UIProgressView = {
        let view = UIProgressView()
        return view
    }()
    
    /// 缓存进度条，显示视频缓存的进度
    private lazy var _cacheProgressBar: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = UIColor.yellow
        view.trackTintColor = UIColor.black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(self._slider)
        self.addSubview(self._currentTimeLabel)
        self.addSubview(self._totalTimeLabel)
        self.addSubview(self._barrageBtn)
        self.addSubview(self._landscapeBtn)
//        self.addSubview(self._playProgressBar)
        self.addSubview(self._cacheProgressBar)
        
        let margin: CGFloat = 10
        let padding: CGFloat = 5
        
        //获取宽度
//        self._currentTimeLabel.text = "88:88"
//        self._currentTimeLabel.sizeToFit()
//        let width = self._currentTimeLabel.frame.width
//        print("width = \(width)")
        let width = 40
        
        self._currentTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
            make.bottom.equalToSuperview().offset(-margin)
            make.width.equalTo(width)
        }
        
        self._slider.snp.makeConstraints { make in
            make.centerY.equalTo(self._currentTimeLabel)
            make.leading.equalTo(self._currentTimeLabel.snp.trailing).offset(padding)
        }
        
        self._totalTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self._currentTimeLabel)
            make.width.equalTo(width)
            make.leading.equalTo(self._slider.snp.trailing).offset(padding)
        }
        
        self._barrageBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self._currentTimeLabel)
            make.leading.equalTo(self._totalTimeLabel.snp.trailing).offset(padding)
        }
        
        self._landscapeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self._currentTimeLabel)
            make.leading.equalTo(self._barrageBtn.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().offset(-margin)
        }
        
//        self.playProgressBar.snp.makeConstraints { make in
//            make.leading.bottom.trailing.equalToSuperview()
//            make.height.equalTo(0.5)
//        }
        
        self._cacheProgressBar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
       
    }
    
    func updatePlayTime(_ seconds: UInt) {
        let min = String(format: "%02d", seconds / 60)
        let second = String(format: "%02d", seconds % 60)
        self._currentTimeLabel.text = min + ":" + second
    }
    
    func updateCache(progress: Float) {
        self._cacheProgressBar.progress = progress
    }
    
    func updatePlay(progress: Float) {
//        self.playProgressBar.progress = progress
        self._slider.value = progress
    }
    
    func setTimeLength(_ seconds: UInt) {
        let min = String(format: "%02d", seconds / 60)
        let second = String(format: "%02d", seconds % 60)
        self._totalTimeLabel.text = min + ":" + second
    }
    
    func test(clourse: () -> ()) {
        clourse()
    }
    
    func test2(clourse: @escaping () -> ()) {
        clourse()
    }
    
    func test3(clourse: @escaping () -> ()) {
        DispatchQueue.global().async {
            clourse()
        }
    }
    
}
