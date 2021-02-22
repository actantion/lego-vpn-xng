//
//  SettingWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class SettingWindow: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {
    @IBOutlet weak var vwChoseLanguage: NSScrollView!
    @IBOutlet weak var vwVpnModel: NSScrollView!
    @IBOutlet weak var scrollLanguage: NSScrollView!
    @IBOutlet weak var tableLanguage: NSTableView!
    @IBOutlet weak var lbChosedLanguage: NSTextField!
    @IBOutlet weak var lbTItleChoseLanguage: NSTextField!
    @IBOutlet weak var scrollVpnManager: NSScrollView!
    @IBOutlet weak var tableVpnManager: NSTableView!
    @IBOutlet weak var lbProxyModel: NSTextField!
    @IBOutlet weak var lbRouteType: NSTextField!
    var dataLanguageArray = [UIBaseModel]()
    var dataVpnManagerArray = [UIBaseModel]()
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        initView()
        
        scrollLanguage.isHidden = true
        scrollVpnManager.isHidden = true
        
        dataLanguageArray.append(UIBaseModel(type: .UITipsType, title: "中文"))
        dataLanguageArray.append(UIBaseModel(type: .UITipsType, title: "English"))
        
        dataVpnManagerArray.append(UIBaseModel(type: .UITipsType, title: "global_route".localized))
        dataVpnManagerArray.append(UIBaseModel(type: .UITipsType, title: "smart_route".localized))
        
        tableLanguage.delegate = self
        tableLanguage.dataSource = self
        tableLanguage.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITipsCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"))
        
        tableVpnManager.delegate = self
        tableVpnManager.dataSource = self
        tableVpnManager.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITipsCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"))
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableLanguage == tableView {
            return dataLanguageArray.count
        }else{
            return dataVpnManagerArray.count
        }
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableLanguage == tableView {
            let cellView:UITipsCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"), owner: self) as! UITipsCell
            cellView.setModel(model: dataLanguageArray[row])
            return cellView
        }else{
            let cellView:UITipsCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"), owner: self) as! UITipsCell
            cellView.setModel(model: dataVpnManagerArray[row])
            return cellView
        }
        
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        print("row = \(row)")
        if tableLanguage == tableView {
            let defaults = UserDefaults.standard
            defaults.set(row, forKey: "APP_LANGUAGE")
            scrollLanguage.isHidden = true
        }else{
            let defaults = UserDefaults.standard
            defaults.set(row, forKey: "APP_VPN_MANGUAGER")
            scrollVpnManager.isHidden = true
        }
        initView()
        return true
    }
    
    @IBAction func clickChoseVpnModel(_ sender: Any) {
        print("点击代理模式")
        tableVpnManager.reloadData()
        if scrollVpnManager.isHidden == false {
            scrollVpnManager.isHidden = true
        }else{
            scrollVpnManager.isHidden = false
        }
    }
    @IBAction func clickChoseLanguage(_ sender: Any) {
        print("点击语言选择")
//        let defaults = UserDefaults.standard
//        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
//        isOn = !isOn
//        defaults.set(isOn, forKey: "ShadowsocksOn")
        tableLanguage.reloadData()
        if scrollLanguage.isHidden == false {
            scrollLanguage.isHidden = true
        }else{
            scrollLanguage.isHidden = false
        }
        
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
//    #define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
    func initView(){
        vwChoseLanguage.wantsLayer = true
        vwChoseLanguage.layer?.cornerRadius = 22.5
        vwChoseLanguage.layer?.masksToBounds = true
        
        vwVpnModel.wantsLayer = true
        vwVpnModel.layer?.cornerRadius = 22.5
        vwVpnModel.layer?.masksToBounds = true
        
        lbTItleChoseLanguage.stringValue = "Language".localized
        let language = UserDefaults.standard.integer(forKey: "APP_LANGUAGE")
        if language == 1 {
            lbChosedLanguage.stringValue = "English"
        }else{
            lbChosedLanguage.stringValue = "中文"
        }
        
        lbProxyModel.stringValue = "proxy pattern".localized
        let proxy = UserDefaults.standard.integer(forKey: "APP_VPN_MANGUAGER")
        print("proxy = \(proxy)")
        if proxy == 1 {
            lbRouteType.stringValue = "smart_route".localized
        }else{
            lbRouteType.stringValue = "global_route".localized
        }
    }
}
