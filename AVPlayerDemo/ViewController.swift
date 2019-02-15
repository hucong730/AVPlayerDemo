//
//  ViewController.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/21.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    private var controller = HCPlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.red
//        guard let url = URL(string: "http://v1.go2yd.com/user_upload/1546341529460656428fb2f0a58a9b3809cbd2535cb19.mp4_bd.mp4") else { return }

        let url = "http://v1.go2yd.com/user_upload/1546341529460656428fb2f0a58a9b3809cbd2535cb19.mp4_bd.mp4"

        self.view.addSubview(controller.playerView)
        controller.playerView.snp.makeConstraints { make in
            make.center.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        controller.mediaUrls = [url]
        controller.play()
        
    }

}

