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
    case UITipsType // 提示
}

class UIBaseModel : NSObject{
    var type:BaseModelType = .UISpaceType
    var title:String = ""
    var subTitle:String = ""
    var desc:String = ""
    var mark:String = ""
    var cellHeight:CGFloat = 0.0
    var color:NSColor = NSColor.clear
    var dataArray:Array<Any> = []
    init(type:BaseModelType = .UISpaceType, title:String = "", subTitle:String = "", desc:String = "", mark:String = "", cellHeight:CGFloat = 0.0, color:NSColor = NSColor.clear, dataArray:[Any] = [NSObject]()) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.desc = desc
        self.mark = mark
        self.cellHeight = cellHeight
        self.color = color
        self.dataArray = dataArray
    }
}
