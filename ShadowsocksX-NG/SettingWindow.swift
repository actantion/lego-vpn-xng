//
//  SettingWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class SettingWindow: NSWindowController {
    @IBOutlet weak var vwChoseLanguage: NSScrollView!
    @IBOutlet weak var vwVpnModel: NSScrollView!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        initView()
    }
    
    
    @IBAction func clickChoseVpnModel(_ sender: Any) {
        print("点击代理模式")
    }
    @IBAction func clickChoseLanguage(_ sender: Any) {
        print("点击语言选择")
    }
    
    @IBAction func clickTGGroup(_ sender: Any) {
        print("点击TG群")
//        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://e.weibo.com/pc175"]];
        NSWorkspace.shared.open(NSURL.init(string: "https://t.me/tenonvpn")! as URL)
    }
    @IBAction func clickHost(_ sender: Any) {
        print("点击官网")
        NSWorkspace.shared.open(NSURL.init(string: "https://www.tenonvpn.net")! as URL)
    }
    @IBAction func clickTwitter(_ sender: Any) {
        print("点击Twitter")
        NSWorkspace.shared.open(NSURL.init(string: "https://twitter.com/tim_swu")! as URL)
    }
    @IBAction func clickFacebook(_ sender: Any) {
        print("点击Facebook")
        NSWorkspace.shared.open(NSURL.init(string: "https://www.facebook.com/TenonVPN")! as URL)
    }
    @IBAction func clickEmail(_ sender: Any) {
        print("点击邮箱")
    }
    @IBAction func clickSkype(_ sender: Any) {
        print("点击Skype")
    }
    func initView(){
        vwChoseLanguage.wantsLayer = true
        vwChoseLanguage.layer?.cornerRadius = 22.5
        vwChoseLanguage.layer?.masksToBounds = true
        
        vwVpnModel.wantsLayer = true
        vwVpnModel.layer?.cornerRadius = 22.5
        vwVpnModel.layer?.masksToBounds = true
    }
}
