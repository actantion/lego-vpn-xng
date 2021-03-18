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
let APP_GREEN_COLOR1 = NSColor.init(red: 100/255, green: 191/255, blue: 190/255, alpha: 1)
let APP_BLACK_COLOR = NSColor.init(red: 255, green: 255, blue: 255, alpha: 1)
let APP_BLACK_COLOR1 = NSColor.init(red: 198, green: 198, blue: 198, alpha: 1)
let APP_BLACK_COLOR2 = NSColor.init(red: 158, green: 158, blue: 158, alpha: 1)

class HomePageWindow: NSWindowController, NSWindowDelegate, NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var lbNoNameUser: NSTextField!
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
    @IBOutlet weak var lbFreeTagLabel: NSTextField!
    @IBOutlet weak var lbVersion: NSTextField!
    @IBOutlet weak var lbLeftDays: NSTextField!
    @IBOutlet weak var lbTenonCoin: NSTextField!
    @IBOutlet weak var lbVersionType: NSTextField!
    @IBOutlet weak var vwScrollview: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var lbPrivateKey: NSTextField!
    @IBOutlet weak var lbHigher: NSTextField!
    @IBOutlet weak var lbTB: NSTextField!
    @IBOutlet weak var lbEarn: NSTextField!
    
    
    @IBOutlet weak var chooseCountry: NSScrollView!
    @IBOutlet weak var countryName: NSTextField!
    @IBOutlet weak var nodeCount: NSTextField!
    @IBOutlet weak var countryImange: NSImageView!
    @IBOutlet weak var btnChoseCountry: NSButton!
    @IBOutlet weak var accountAddress: NSTextField!
    @IBOutlet weak var privateKeyText: NSTextField!
    @IBOutlet weak var privateKeyButton: NSButton!
    @IBOutlet weak var aboutProduction: NSTextField!
    @IBOutlet weak var serviceSupport: NSTextField!
    

    var setWnd:SettingWindow!
    var earnWnd:EarnCoinWindow!
    var withdrawWnd:WithdrawCoinWindow!
    var connectCount:Int32 = 5
    var secondTimer:Timer!
    var timer:Timer!
    var isConnect:Bool = false
    var isSelect: Bool = false
    var choosyCountryClicked = false
    var privateKeyShowed = false
    @IBOutlet weak var shareButtoon: NSButton!
    
    let countryCode:[String] = ["United States", "Singapore", "Brazil","Germany","Netherlands", "France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England", "China"]
    var countryNodes:[String] = []
    let iCon:[String] = ["us", "sg", "br","de", "nl", "fr","kr", "jp", "ca","au","hk", "in", "gb", "cn"]
    

    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        // 显示版本号
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            self.lbVersion.stringValue = "V\(appVersion)"
        }
        
        initView()
        choosyCountryClicked = false
        requestData()
        print("windowDidLoad ok.")
    }
    

    func windowWillClose(_ aNotification: Notification) {
//        UserDefaults.standard.set(false, forKey: "ShadowsocksOn")
//        let use_st: Int32 = 1
//        SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country,
//                local_country: TenonP2pLib.sharedInstance.local_country,
//                smart_route:use_st)
//
//        ProxyConfHelper.disableProxy()
//        NSApplication.shared.terminate(self)
//        _exit(0)
        self.window?.orderOut(nil)
    }
    

    
    func getCountryShort(countryCode:String) -> String {
        switch countryCode {
        case "America":
            return "US"
        case "Singapore":
            return "SG"
        case "Brazil":
            return "BR"
        case "Germany":
            return "DE"
        case "Netherlands":
            return "NL"
        case "France":
            return "FR"
        case "Korea":
            return "KR"
        case "Japan":
            return "JP"
        case "Canada":
            return "CA"
        case "Australia":
            return "AU"
        case "Hong Kong":
            return "HK"
        case "India":
            return "IN"
        case "England":
            return "GB"
        case "China":
            return "CN"
        default:
            return ""
        }
    }
    
    func showCopySuccessAlert() {
        let a: NSAlert = NSAlert()
        a.messageText = "success".localized
        a.informativeText = "copy success".localized
        a.addButton(withTitle: "OK".localized)
        a.alertStyle = NSAlert.Style.warning

        a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
            if(modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn){
                
            }
        })
    }
    
    func copyStringToPasteboard(string: String) {
        let pboard = NSPasteboard.general
        pboard.declareTypes([.string], owner: nil)
        pboard.setString(string, forType: .string)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        self.copyStringToPasteboard(string: "https://www.tenonvpn.net?id=" + TenonP2pLib.sharedInstance.account_id_)
        self.showCopySuccessAlert()
    }
    
    @IBAction func onEditAccount(_ sender: Any) {
    }
    
    @IBAction func onPrivateKeyEdit(_ sender: Any) {
        if privateKeyShowed {
            privateKeyButton.image = NSImage.init(imageLiteralResourceName:"hidden_icon")
            self.privateKeyText.stringValue = "**********************************************************************************************";
        } else {
            privateKeyButton.image = NSImage.init(imageLiteralResourceName:"show_icon")
            self.privateKeyText.stringValue = TenonP2pLib.sharedInstance.private_key_;
        }
        
        privateKeyShowed = !privateKeyShowed;
    }
    
    @IBAction func clickChooseCountry(_ sender: Any) {
        print("clickChooseCountry: \(choosyCountryClicked)")
        isSelect = false
        if !choosyCountryClicked{
            choosyCountryClicked = true
            vwScrollview.isHidden = false
        }else{
            vwScrollview.isHidden = true
            choosyCountryClicked = false
        }
    }
    
    @IBAction func chooseCountry(_ sender: Any) {
        print("chooseCountry")
    }
    
    func showTenonBalance(){
        TenonP2pLib.sharedInstance.PayforVpn()
        self.lbLeftDays.stringValue = "VIP ".localized +  String(TenonP2pLib.sharedInstance.vip_left_days) + " DAYS".localized
        self.lbTenonCoin.stringValue = String(TenonP2pLib.sharedInstance.now_balance) + " Tenon"
        self.lbVersionType.stringValue = "Professional".localized
        self.lbFreeTagLabel.stringValue = "Free".localized
        self.lbNoNameUser.stringValue = "Anonymous User".localized
        self.lbPrivateKey.stringValue = "Private key".localized
        self.lbHigher.stringValue = "Higher performance".localized
        self.lbTB.stringValue = "Withdraw".localized
        self.lbEarn.stringValue = "Earn".localized
        self.accountAddress.stringValue = TenonP2pLib.sharedInstance.account_id_;
        self.privateKeyText.stringValue = "**********************************************************************************************";
    }
    
    func initView(){
        choosyCountryClicked = false
        self.vwVersionBack.layer?.cornerRadius = 4
        self.vwVersionBack.layer?.masksToBounds = true
        showTenonBalance()
        self.vwUpdateToPro.isHidden = true
        
        self.vwConnect.wantsLayer = true
        self.vwConnect.layer?.masksToBounds = true
        self.vwConnect.layer?.cornerRadius = 62.5
        resetConnect()
        countryName.stringValue = "United States".localized
        aboutProduction.stringValue = "About".localized
        serviceSupport.stringValue = "Support".localized
        
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100))
        }
        
        shareButtoon.title = "Share".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CountryChoseCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"))
        tableView.reloadData()
        
        self.nodeCount.stringValue = countryNodes[0] + "nodes".localized
        
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
        cellView.lbCountryName.stringValue = countryCode[row].localized
        cellView.lbNodes.stringValue = "\(countryNodes[row])"+"nodes".localized

        return cellView
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        if (isSelect) {
            return false
        }
        
        isSelect = true
        let myRowView:NSTableRowView = tableView.rowView(atRow: row, makeIfNecessary: false)!
        myRowView.selectionHighlightStyle = NSTableView.SelectionHighlightStyle.none
        myRowView.isEmphasized = false
        isSelect = true
        choosyCountryClicked = false
        TenonP2pLib.sharedInstance.choosed_country_idx = row
        self.countryName.stringValue = countryCode[row].localized
        self.countryImange.image = NSImage.init(imageLiteralResourceName:iCon[row])
        self.nodeCount.stringValue = countryNodes[row] + "nodes".localized
        TenonP2pLib.sharedInstance.choosed_country = getCountryShort(countryCode: countryCode[row])
        TenonP2pLib.sharedInstance.choosed_country = TenonP2pLib.sharedInstance.choosed_country
        
        resetConnect()
        isConnect = false
        _ = UserDefaults.standard
        vwScrollview.isHidden = true
        return true
    }
    
    private func stopConnect() {
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (!isOn) {
            return;
        }
        
        isOn = false
        
        defaults.set(isOn, forKey: "ShadowsocksOn")
        let use_st: Int32 = 1
        SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country, local_country: TenonP2pLib.sharedInstance.local_country, smart_route:use_st)
        ProxyConfHelper.disableProxy()
    }
    
    @IBAction func clickTB(_ sender: Any) {
        print("点击提币")
        let url = URL.init(string: "https://www.tenonvpn.net/block_server")
        NSWorkspace.shared.open(url!)
//        if withdrawWnd != nil {
//            withdrawWnd.close()
//        }
//        withdrawWnd = WithdrawCoinWindow(windowNibName: .init(rawValue: "WithdrawCoinWindow"))
//        withdrawWnd.showWindow(self)
//        NSApp.activate(ignoringOtherApps: true)
//        withdrawWnd.window?.makeKeyAndOrderFront(nil)
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
        showTenonBalance()
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
        self.lbConnect.stringValue = "Disconnect".localized
        self.lbConnect.textColor = NSColor.white
        self.imgConnect.image = NSImage(named: NSImage.Name(rawValue: "no_link_icon"))
        self.imgConnectTag.isHidden = true
        self.lbConnectTag.isHidden = true
    }
    
    
//
//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//         UserDefaults.standard.set(false, forKey: "ShadowsocksOn")
//         let use_st: Int32 = 1
//         SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country,
//                     local_country: TenonP2pLib.sharedInstance.local_country,
//                     smart_route:use_st)
//
//          ProxyConfHelper.disableProxy()
//         _exit(0)
//        return true
//    }
    
    @IBAction func clickToService(_ sender: Any) {
        var url = URL.init(string: "https://t.me/tenonvpn_vip")
        NSWorkspace.shared.open(url!)
    }
    
    func ConnectProgressView(){
        self.TenonProgressView.isHidden = false
        self.lbProgressLoading.layer?.masksToBounds = true
        self.lbProgressLoading.layer?.cornerRadius = 8
        self.lbProgressLoading.layer?.borderWidth = 1
        self.lbProgressLoading.layer?.borderColor = APP_GREEN_COLOR.cgColor
        
        self.lbProgressFee.layer?.masksToBounds = true
        self.lbProgressFee.layer?.cornerRadius = 8
        
        self.constraintFee.constant = 0
        self.lbProgressDesc.stringValue = "Linking for you".localized + "...\(connectCount)s"
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
        self.lbProgressDesc.stringValue = "Linking for you".localized + "...\(connectCount)s"
    }
    
    func ConnectBtn() {
        self.vwConnect.layer?.backgroundColor = APP_GREEN_COLOR.cgColor
        self.lbConnect.stringValue = "Connected".localized
        self.lbConnect.textColor = NSColor.black
        self.imgConnect.image = NSImage(named: NSImage.Name(rawValue: "link_icon"))
        self.imgConnectTag.isHidden = false
        self.lbConnectTag.isHidden = false
        self.lbConnectTag.stringValue = "P2P networks are protecting your IP and data privacy".localized
    }
    func resetConnect() {
        // 点击断开链接，重置链接按钮
        resetConnectBtn()
        // 点击断开链接，重制进度显示视图
        resetProgressView()
        
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (!isOn) {
            return;
        }
        
        isOn = false
        defaults.set(isOn, forKey: "ShadowsocksOn")
        let use_st: Int32 = 1
        SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country, local_country: TenonP2pLib.sharedInstance.local_country, smart_route:use_st)
        ProxyConfHelper.disableProxy()
    }
    
    func Connect() {
        // 点击链接按钮，链接进程视图
        ConnectProgressView()
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        isOn = true
        defaults.set(isOn, forKey: "ShadowsocksOn")
        let use_st: Int32 = 1
        SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country, local_country: TenonP2pLib.sharedInstance.local_country, smart_route:use_st)
        let mode = "global";  // defaults.string(forKey: "ShadowsocksRunningMode")
        
        if isOn {
            if mode == "auto" {
                ProxyConfHelper.enablePACProxy()
            } else if mode == "global" {
                ProxyConfHelper.enableGlobalProxy()
            } else if mode == "manual" {
                ProxyConfHelper.disableProxy()
            } else if mode == "externalPAC" {
                ProxyConfHelper.enableExternalPACProxy()
            }
        }
        
        resetProgressView()
        ConnectBtn()
    }
    
    func showOutbandwidthAlert() {
        let a: NSAlert = NSAlert()
        a.messageText = "TenonOver".localized
        a.informativeText = "OutBandwidth".localized
        a.addButton(withTitle: "recharge".localized)
        a.addButton(withTitle: "use tomorrow".localized)
        a.alertStyle = NSAlert.Style.warning

        a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
            if(modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn){
                let url = URL.init(string: "https://www.tenonvpn.net/pp_one_month/" + TenonP2pLib.sharedInstance.account_id_)
                NSWorkspace.shared.open(url!)
            }
        })
    }
    @IBAction func clickConnect(_ sender: NSButton) {
        if (TenonP2pLib.sharedInstance.IsExceededBandwidth()) {
            print("点击logo")
            showOutbandwidthAlert()
            return
        }
        
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
        self.lbTenonCoin.stringValue = "Free".localized
        self.lbVersionType.stringValue = "Community".localized
    }
    @IBAction func clickAbout(_ sender: Any) {
        if setWnd != nil {
            setWnd.close()
        }
        setWnd = SettingWindow(windowNibName: .init(rawValue: "SettingWindow"))
        setWnd.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        setWnd.window?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func clickLogo(_ sender: NSButton) {
        print("点击logo")
//        if setWnd != nil {
//            setWnd.close()
//        }
//        setWnd = SettingWindow(windowNibName: .init(rawValue: "SettingWindow"))
//        setWnd.showWindow(self)
//        NSApp.activate(ignoringOtherApps: true)
//        setWnd.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc func requestData() {
        if TenonP2pLib.sharedInstance.GetBackgroudStatus() != "ok" {
            if TenonP2pLib.sharedInstance.GetBackgroudStatus() == "cni" {
                stopConnect()
            }
            
            if TenonP2pLib.sharedInstance.GetBackgroudStatus() == "bwo" {
                //noticeLabel.stringValue = "Free 100M/day used up, buy tenon or use tomorrow.".localized
                stopConnect()
                print("out of bandwidth.")
            }
            
            if TenonP2pLib.sharedInstance.GetBackgroudStatus() == "oul" {
                stopConnect()
            }
        }
        
        let trascationValue:String = TenonP2pLib.sharedInstance.GetTransactions()
        let dataArray = trascationValue.components(separatedBy: ";")
        for value in dataArray{
            if value == ""{
                continue
            }
            let model = TranscationModel()
            let dataDetailArray = value.components(separatedBy: ",")
            model.dateTime = dataDetailArray[0]
            model.type = dataDetailArray[1]
            let acc = dataDetailArray[2]
            model.acount = acc.prefix(5).uppercased() + ".." + acc.suffix(5).uppercased()
            model.amount = dataDetailArray[3]
            // transcationList.append(model)
        }
        
        
        TenonP2pLib.sharedInstance.PayforVpn()

       
        self.lbLeftDays.stringValue = "VIP ".localized +  String(TenonP2pLib.sharedInstance.vip_left_days) + " DAYS".localized
        self.lbTenonCoin.stringValue = String(TenonP2pLib.sharedInstance.now_balance) + " Tenon"
        TenonP2pLib.sharedInstance.GetBandwidthInfo()
        if (TenonP2pLib.sharedInstance.IsExceededBandwidth()) {
            resetConnect()
            isConnect = false
        }
        
        self.perform(#selector(requestData), with: nil, afterDelay: 3)
    }
}
