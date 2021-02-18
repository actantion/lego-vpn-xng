//
//  HomePageWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/18.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

//let APP_MAIN_COLOR=kRBColor(18, 181, 170);
let APP_GREEN_COLOR = NSColor.init(red: 18, green: 181, blue: 170, alpha: 1)
let APP_BLACK_COLOR = NSColor.init(red: 255, green: 255, blue: 255, alpha: 1)

class HomePageWindow: NSWindowController {

    @IBOutlet weak var vwConnect: NSView!
    @IBOutlet weak var vwEarnCoin: NSView!
    @IBOutlet weak var vwUpdateToPro: NSView!
    @IBOutlet weak var vwVersionBack: NSScrollView!
    @IBOutlet weak var vwFreeTag: NSView!
    @IBOutlet weak var lbVersion: NSTextField!
    @IBOutlet weak var lbLeftDays: NSTextField!
    @IBOutlet weak var lbTenonCoin: NSTextField!
    @IBOutlet weak var lbVersionType: NSTextField!
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        // 显示版本号
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            self.lbVersion.stringValue = "v\(appVersion)"
        }
        initView()
        
    }
    
    func initView(){
        self.vwVersionBack.layer?.cornerRadius = 4
        self.vwVersionBack.layer?.masksToBounds = true
        self.lbLeftDays.stringValue = "0 天后到期"
        self.lbTenonCoin.stringValue = "0 Tenon"
        self.lbVersionType.stringValue = "专业版"
        self.vwUpdateToPro.isHidden = true
        
        self.vwConnect.layer?.masksToBounds = true
        self.vwConnect.layer?.cornerRadius = self.vwConnect.frame.width/2
        
//        CALayer *viewLayer = [CALayer layer];
//         NSView *backgroundView= [[NSView alloc]init];
//         [backgroundView setWantsLayer:YES];
//         [backgroundView setLayer:viewLayer];
//         backgroundView.layer.backgroundColor = [NSColor colorWithRed:0.14 green:0.62 blue:0.93 alpha:1.0].CGColor;
//         [backgroundView setNeedsDisplay:YES];
//        let layer = CALayer.init()
        self.vwConnect.layer?.backgroundColor = NSColor.lightGray.cgColor
//        self.vwConnect. = NSColor.lightGray
    }
    @IBAction func clickTB(_ sender: Any) {
        print("点击提币")
    }
    @IBAction func clickEarnCoin(_ sender: Any) {
        print("点击赚币")
    }
    @IBAction func clickUpdateToPro(_ sender: Any) {
        print("点击到专业")
        self.vwEarnCoin.isHidden = false
        self.vwFreeTag.isHidden = false
        self.lbLeftDays.stringValue = "0 天后到期"
        self.lbTenonCoin.stringValue = "0 Tenon"
        self.lbVersionType.stringValue = "专业版"
        self.vwUpdateToPro.isHidden = true
    }
    @IBAction func clickConnect(_ sender: Any) {
    }
    @IBAction func clickFree(_ sender: Any) {
        print("点击免费")
        self.vwFreeTag.isHidden = true
        self.vwUpdateToPro.isHidden = false
        self.vwEarnCoin.isHidden = true
        
        self.lbLeftDays.stringValue = "FREE!"
        self.lbTenonCoin.stringValue = "免费"
        self.lbVersionType.stringValue = "社区版本"
    }
    @IBAction func clickLogo(_ sender: NSButton) {
        print("点击logo")
    }
}
