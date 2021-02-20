//
//  UIMethodCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class UIMethodCell: NSTableCellView {
    @IBOutlet weak var vwBack: NSView!
    @IBOutlet weak var lbMethod: NSTextField!
    @IBOutlet weak var lbTitle: NSTextField!
    @IBOutlet weak var lbSubTitle: NSTextField!
    @IBOutlet weak var btnMethod: NSButton!
    var clickBlock:VoidBlock!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    func setModel(model:UIBaseModel) {
        vwBack.wantsLayer = true
        vwBack.layer?.masksToBounds = true
        vwBack.layer?.cornerRadius = 16
        vwBack.layer?.backgroundColor = NSColor.init(red: 18/255, green: 25/255, blue: 25/255, alpha: 1).cgColor

        btnMethod.wantsLayer = true
        btnMethod.layer?.masksToBounds = true
        btnMethod.layer?.cornerRadius = 18
        btnMethod.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
        
        lbMethod.stringValue = model.title
        lbTitle.stringValue = model.subTitle
        lbSubTitle.stringValue = model.desc
        btnMethod.title = model.mark
    }
    @IBAction func clickBtn(_ sender: Any) {
        clickBlock?()
    }
}
