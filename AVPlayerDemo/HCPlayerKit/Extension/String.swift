//
//  String.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/30.
//  Copyright © 2019 胡聪. All rights reserved.
//

import Foundation

extension String {
    
    
    public func md5String() -> String? {
        guard let str = self.cString(using: String.Encoding.utf8) else { return nil }
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        var temp: UInt8 = 0
        let md = withUnsafeMutablePointer(to: &temp) { ptr in
            return ptr
        }
        CC_MD5(str, strLen, md)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", md[i])
        }
        return String(format: hash as String)
    }
}

