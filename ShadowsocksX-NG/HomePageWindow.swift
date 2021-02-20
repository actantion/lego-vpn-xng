//
//  HomePageWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/18.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa
import Masonry

//let APP_MAIN_COLOR=kRBColor(18, 181, 170);
let APP_GREEN_COLOR = NSColor.init(red: 18/255, green: 181/255, blue: 170/255, alpha: 1)
let APP_BLACK_COLOR = NSColor.init(red: 255, green: 255, blue: 255, alpha: 1)

class HomePageWindow: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var lbProgressDesc: NSTextField!
    @IBOutlet weak var constraintFee: NSLayoutConstraint!
    @IBOutlet weak var lbProgressFee: NSTextField!
    @IBOutlet weak var lbProgressLoading: NSTextField!
    @IBOutlet weak var TenonProgressView: NSView!
    @IBOutlet weak var lbConnectTag: NSTextField!
    @IBOutlet weak var imgConnectTag: NSImageView!
    @IBOutlet weak var imgConnect: NSImageView!
    @IBOutlet weak var lbConnect: NSTextField!
    @IBOutlet weak var vwConnect: NSView!
    @IBOutlet weak var vwEarnCoin: NSView!
    @IBOutlet weak var vwUpdateToPro: NSView!
    @IBOutlet weak var vwVersionBack: NSScrollView!
    @IBOutlet weak var vwFreeTag: NSView!
    @IBOutlet weak var lbVersion: NSTextField!
    @IBOutlet weak var lbLeftDays: NSTextField!
    @IBOutlet weak var lbTenonCoin: NSTextField!
    @IBOutlet weak var lbVersionType: NSTextField!
    @IBOutlet weak var vwScrollview: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    
    var setWnd:SettingWindow!
    var earnWnd:EarnCoinWindow!
    var connectCount:Int32 = 5
    var secondTimer:Timer!
    var timer:Timer!
    var isConnect:Bool = false
    
    let countryCode:[String] = ["America", "Singapore", "Brazil","Germany","Netherlands", "France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England", "China"]
    var countryNodes:[String] = []
    let iCon:[String] = ["us", "sg", "br","de", "nl", "fr","kr", "jp", "ca","au","hk", "in", "gb", "cn"]
    
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
        
        self.vwConnect.wantsLayer = true
        self.vwConnect.layer?.masksToBounds = true
        self.vwConnect.layer?.cornerRadius = 62.5
        resetConnect()
        
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100))
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CountryChoseCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"))
        tableView.reloadData()
        
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return countryCode.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView:CountryChoseCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"), owner: self) as! CountryChoseCell
        
        cellView.imgIcon.image = NSImage.init(imageLiteralResourceName:iCon[row])
        cellView.lbCountryName.stringValue = countryCode[row]
        cellView.lbNodes.stringValue = "\(countryNodes[row])个节点"
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        print("row = \(row)")
        return true
    }
    @IBAction func clickTB(_ sender: Any) {
        print("点击提币")
    }
    @IBAction func clickEarnCoin(_ sender: Any) {
        print("点击赚币")
        if earnWnd != nil {
            earnWnd.close()
        }
        earnWnd = EarnCoinWindow(windowNibName: .init(rawValue: "EarnCoinWindow"))
        earnWnd.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        earnWnd.window?.makeKeyAndOrderFront(nil)
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
    // 链接成功以后，直接显示连接成功，调用此方法
    func resetProgressView(){
        self.TenonProgressView.isHidden = true
        self.connectCount = 5
        if (timer != nil){
            timer.invalidate()
            timer = nil
        }
        if (secondTimer != nil) {
            secondTimer.invalidate()
            secondTimer = nil
        }
    }
    func resetConnectBtn() {
        self.vwConnect.layer?.backgroundColor = NSColor.init(red: 200, green: 200, blue: 200, alpha: 1).cgColor
        self.lbConnect.stringValue = "未连接"
        self.lbConnect.textColor = NSColor.white
        self.imgConnect.image = NSImage(named: NSImage.Name(rawValue: "no_link_icon"))
        self.imgConnectTag.isHidden = true
        self.lbConnectTag.isHidden = true
    }
    
    func ConnectProgressView(){
        self.TenonProgressView.isHidden = false
        self.lbProgressLoading.layer?.masksToBounds = true
        self.lbProgressLoading.layer?.cornerRadius = 8
        self.lbProgressLoading.layer?.borderWidth = 2
        self.lbProgressLoading.layer?.borderColor = APP_GREEN_COLOR.cgColor
        
        self.lbProgressFee.layer?.masksToBounds = true
        self.lbProgressFee.layer?.cornerRadius = 8
        
        self.constraintFee.constant = 0
        self.lbProgressDesc.stringValue = "正在为您链接...\(connectCount)s"
        timer = Timer.scheduledTimer(timeInterval: 0.008, target: self, selector: #selector(showProgress), userInfo: nil, repeats: true)
        secondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showSecondProgress), userInfo: nil, repeats: true)
    }
    @objc func showProgress() {
        self.constraintFee.constant += 0.43
        if self.constraintFee.constant >= lbProgressLoading.frame.width {
            resetProgressView()
            // 点击链接按钮，链接按钮的UI效果
            ConnectBtn()
        }
    }
    @objc func showSecondProgress() {
        connectCount -= 1
        self.lbProgressDesc.stringValue = "正在为您链接...\(connectCount)s"
    }
    
    func ConnectBtn() {
        self.vwConnect.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
        self.lbConnect.stringValue = "已链接"
        self.lbConnect.textColor = NSColor.black
        self.imgConnect.image = NSImage(named: NSImage.Name(rawValue: "link_icon"))
        self.imgConnectTag.isHidden = false
        self.lbConnectTag.isHidden = false
        self.lbConnectTag.stringValue = "P2P网络正在保护您的IP和数据隐私"
    }
    func resetConnect() {
        // 点击断开链接，重置链接按钮
        resetConnectBtn()
        // 点击断开链接，重制进度显示视图
        resetProgressView()
    }
    
    func Connect() {
        // 点击链接按钮，链接进程视图
        ConnectProgressView()
    }
    @IBAction func clickConnect(_ sender: NSButton) {
        if isConnect == false {
            print("点击链接1")
            Connect()
        }else{
            print("点击链接2")
            resetConnect()
        }
        isConnect = !isConnect
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
        if setWnd != nil {
            setWnd.close()
        }
        setWnd = SettingWindow(windowNibName: .init(rawValue: "SettingWindow"))
        setWnd.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        setWnd.window?.makeKeyAndOrderFront(nil)
    }
}
