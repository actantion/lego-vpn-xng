//
//  UITipsCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/22.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class UITipsCell: NSTableCellView {

    @IBOutlet weak var lbTips: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func setModel(model:UIBaseModel){
        lbTips.stringValue = model.title
    }
}
