//
//  UITranscationHeaderCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/22.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class UITranscationHeaderCell: NSTableCellView {
    @IBOutlet weak var vwBack: NSView!
    @IBOutlet weak var lbTime: NSTextField!
    @IBOutlet weak var lbType: NSTextField!
    @IBOutlet weak var lbAmount: NSTextField!
    @IBOutlet weak var lbBalance: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func setModel(model:UIBaseModel){
        lbTime.stringValue = "Transaction time".localized
        lbType.stringValue = "Type".localized
        lbAmount.stringValue = "volume of trade".localized
        lbBalance.stringValue = "Balance".localized
        vwBack.wantsLayer = true
        vwBack.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
    }
}
