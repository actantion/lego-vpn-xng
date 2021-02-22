//
//  Utils.swift
//  ShadowsocksX-NG
//
//  Created by 邱宇舟 on 16/6/7.
//  Copyright © 2016年 qiuyuzhou. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
//            UserDefaults.standard.set(row, forKey: "APP_LANGUAGE")
        let language = UserDefaults.standard.integer(forKey: "APP_LANGUAGE")
        if language == 0 {
            // 中文
            let data = "zh-Hans"
            let bdl = Bundle.main.path(forResource: data, ofType: "lproj")
            
        }else{
            // 英文
            let data = "en"
        }
        return NSLocalizedString(self, tableName: "Localizable", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: "Localizable", comment: withComment)
    }
}

extension Data {
    func sha1() -> String {
        let data = self
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
}

enum ProxyType {
    case pac
    case global
}

struct Globals {
    static var proxyType = ProxyType.pac
}
