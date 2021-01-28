//
//  String+Ext.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {

func md5() -> String {

    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate()
    var hexString = ""
    for byte in digest {
        hexString += String(format:"%02x", byte)
    }

    return hexString
}
    
}
