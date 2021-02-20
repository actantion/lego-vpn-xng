//
//  UIPrivateKeyCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

typealias VoidBlock = () -> Void
class UIPrivateKeyCell: NSTableCellView {

    @IBOutlet weak var btnCopy: NSButton!
    @IBOutlet weak var lbPrivateKey: NSTextField!
    @IBOutlet weak var lbMethod: NSTextField!
    @IBOutlet weak var vwBack: NSView!
    var clickBlockCopy:VoidBlock!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
    }
    func setModel(model:UIBaseModel) {
        vwBack.wantsLayer = true
        vwBack.layer?.masksToBounds = true
        vwBack.layer?.cornerRadius = 16
        vwBack.layer?.backgroundColor = NSColor.init(red: 18/255, green: 25/255, blue: 25/255, alpha: 1).cgColor
        
        btnCopy.wantsLayer = true
        btnCopy.layer?.masksToBounds = true
        btnCopy.layer?.cornerRadius = 18
        btnCopy.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
        
        lbMethod.stringValue = model.title
        lbPrivateKey.stringValue = model.subTitle
        btnCopy.title = model.mark
    }
    @IBAction func clickBtn(_ sender: Any) {
        clickBlockCopy?()
    }
}
