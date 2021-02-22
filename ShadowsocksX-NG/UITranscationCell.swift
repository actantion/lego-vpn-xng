//
//  UITranscationCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/22.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class UITranscationCell: NSTableCellView {

    @IBOutlet weak var lbTime: NSTextField!
    @IBOutlet weak var lbType: NSTextField!
    @IBOutlet weak var lbAmount: NSTextField!
    @IBOutlet weak var lbBanlce: NSTextField!
    @IBOutlet weak var vwBack: NSView!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func setModel(model:UIBaseModel){
        vwBack.wantsLayer = true
        vwBack.layer?.backgroundColor = model.color.cgColor
        lbTime.stringValue = model.dataArray[0] as! String
        lbType.stringValue = model.dataArray[1] as! String
        lbAmount.stringValue = model.dataArray[2] as! String
        lbBanlce.stringValue = model.dataArray[3] as! String
    }
}
