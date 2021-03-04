//
//  UIWithdrawCell.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/3/4.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa
typealias twoStringValueBlock = (String,String) -> Void
class UIWithdrawCell: NSTableCellView,NSTextFieldDelegate {
    @IBOutlet weak var textFiled: NSTextField!
    @IBOutlet weak var withdrawTextFiled: NSTextField!
    @IBOutlet weak var btnWithdraw: NSButton!
    @IBOutlet weak var btnTX: NSButton!
    var clickTX:twoStringValueBlock!
    @IBOutlet weak var lbWithdrawCount: NSTextField!
    @IBOutlet weak var vwBack: NSView!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        textFiled.delegate = self
        withdrawTextFiled.delegate = self
        let textAttributes = [
            NSAttributedStringKey.strokeColor: NSColor.lightGray,
            NSAttributedStringKey.font: NSFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
        ] as [NSAttributedStringKey : Any]
        textFiled.placeholderAttributedString = NSAttributedString.init(string: "输入或粘贴地址", attributes: (textAttributes ))
        withdrawTextFiled.placeholderAttributedString = NSAttributedString.init(string: "最低数量100", attributes: (textAttributes ))
    }
    func setModel(model:UIBaseModel) {
        vwBack.wantsLayer = true
        vwBack.layer?.masksToBounds = true
        vwBack.layer?.cornerRadius = 16
        vwBack.layer?.backgroundColor = NSColor.init(red: 18/255, green: 25/255, blue: 25/255, alpha: 1).cgColor
        
        btnWithdraw.wantsLayer = true
        btnWithdraw.layer?.backgroundColor = NSColor.clear.cgColor
        
        btnTX.wantsLayer = true
        btnTX.layer?.masksToBounds = true
        btnTX.layer?.cornerRadius = 22.5
        btnTX.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
    }
    @IBAction func clickAllTenon(_ sender: Any) {
        print("全部提现")
        withdrawTextFiled.stringValue = "11111"
    }
    
    @IBAction func clickTX(_ sender: Any) {
        if textFiled.stringValue.count == 0 {
            print("私钥为空")
            return
        }else if withdrawTextFiled.stringValue.count == 0{
            print("提现金额为空")
            return
        }
        clickTX?(textFiled.stringValue,withdrawTextFiled.stringValue)
    }
}
