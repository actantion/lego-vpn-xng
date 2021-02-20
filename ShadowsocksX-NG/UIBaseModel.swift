//
//  UIBaseModel.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Foundation

enum BaseModelType{
    case UIPrivateKeyType       //保护好私钥
    case UIMethodType           //方法1，2，3
    case UITranscationHeaderType      //交易明细头
    case UITranscationType      //交易明细
    case UISpaceType            //空格
}

class UIBaseModel : NSObject{
    var type:BaseModelType = .UISpaceType
    var title:String = ""
    var subTitle:String = ""
    var desc:String = ""
    var mark:String = ""
    var cellHeight:CGFloat = 0.0
    init(type:BaseModelType = .UISpaceType, title:String = "", subTitle:String = "", desc:String = "", mark:String = "", cellHeight:CGFloat = 0.0) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.desc = desc
        self.mark = mark
        self.cellHeight = cellHeight
    }
}
