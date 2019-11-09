//
//  TenonMainWindowsController.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/8.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa
import CircularProgress

let APP_COLOR:NSColor = NSColor(red: 9/255, green: 222/255, blue: 202/255, alpha: 1)

class TenonMainWindowsController: NSWindowController,NSTableViewDelegate,NSTableViewDataSource,NSGestureRecognizerDelegate {
    @IBOutlet weak var progressCircularProgress: CircularProgress!
    @IBOutlet weak var notConnectProgress: CircularProgress!
    @IBOutlet weak var connectedProgress: CircularProgress!
    @IBOutlet weak var lbUpgrade: NSTextField!
    @IBOutlet weak var lbTitleBalanced: NSTextField!
    @IBOutlet weak var lbTitleAddress: NSTextField!
    @IBOutlet weak var btnUpgrade: NSButton!
    @IBOutlet weak var lbUSD: NSTextField!
    @IBOutlet weak var lbTenon: NSTextField!
    @IBOutlet weak var lbAccountAddress: NSTextField!
    @IBOutlet weak var popMenuTableView: NSTableView!
    @IBOutlet weak var popMenu: NSView!
    @IBOutlet weak var baseView: NSView!
    @IBOutlet weak var btnChoseCountry: NSButton!
    @IBOutlet weak var lbConnect: NSTextField!
    @IBOutlet weak var imgConnect: NSImageView!
    @IBOutlet weak var cbRouteSwitch: NSButton!
    @IBOutlet weak var btnConnect: NSButton!
    
    @IBOutlet weak var lbCountryName: NSTextField!
    @IBOutlet weak var lbNodeCount: NSTextField!
    @IBOutlet weak var imgCountry: NSImageView!
    @IBOutlet weak var vwLine: NSView!
    @IBOutlet weak var exitButton: NSButton!
    @IBOutlet weak var settingsBtn: NSButton!
    @IBOutlet weak var upgradeBtn: NSButton!
    @IBOutlet weak var smartRouteLabel: NSTextField!
    
     
    var mySwitch: JSSwitch!
    
    var choosed_country:String! = "US"
    var transcationList = [TranscationModel]()
    let appDelegate = (NSApplication.shared.delegate) as! AppDelegate
    
    var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb"]
    var isSelect: Bool = false
    var accountSettingWndCtrl:AcountSettingWndController!
    public var local_country:String!;
    let kCurrentVersion = "2.0.2"

    
    @IBAction func clickSettings(_ sender: Any) {
        if accountSettingWndCtrl != nil {
            accountSettingWndCtrl.close()
        }
        accountSettingWndCtrl = AcountSettingWndController(windowNibName: .init(rawValue: "AcountSettingWndController"))
        accountSettingWndCtrl.showWindow(self)
        accountSettingWndCtrl.transcationList = transcationList
        accountSettingWndCtrl.refresh()
        NSApp.activate(ignoringOtherApps: true)
        accountSettingWndCtrl.window?.makeKeyAndOrderFront(nil)
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
    
    @IBAction func exitClick(_ sender: Any) {
       UserDefaults.standard.set(false, forKey: "ShadowsocksOn")
        var use_st: Int32 = 0
        if (mySwitch.on) {
            use_st = 1
        }
       SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route:use_st)

           ProxyConfHelper.disableProxy()
        _exit(0)
    }
    
    func startConnect() {
        progressCircularProgress.isIndeterminate = true;
        progressCircularProgress.lineWidth = 6
        progressCircularProgress.color = NSColor(red: 19/255, green: 244/255, blue: 220/255, alpha: 1)
        window?.contentView!.addSubview(progressCircularProgress)
        //progressCircularProgress.isHidden = true;
    }
    
//    func stopConnect() {
//        progressCircularProgress.isIndeterminate = true;
//        progressCircularProgress.lineWidth = 6
//        progressCircularProgress.color = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1)
//        window?.contentView!.addSubview(progressCircularProgress)
//    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        updateUI()
        requestData()
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }
        self.lbCountryName.stringValue = countryCode[TenonP2pLib.sharedInstance.choosed_country_idx]
        self.imgCountry.image = NSImage.init(imageLiteralResourceName:iCon[TenonP2pLib.sharedInstance.choosed_country_idx])
        self.lbNodeCount.stringValue = countryNodes[TenonP2pLib.sharedInstance.choosed_country_idx]
        self.choosed_country = getCountryShort(countryCode: countryCode[TenonP2pLib.sharedInstance.choosed_country_idx])
        TenonP2pLib.sharedInstance.choosed_country = self.choosed_country
        
        lbAccountAddress.stringValue = String(appDelegate.local_account_id.prefix(7)).uppercased() + "..." + String(appDelegate.local_account_id.suffix(7)).uppercased()
        popMenuTableView.delegate = self
        popMenuTableView.dataSource = self
        popMenuTableView.tableColumns[0].width = popMenuTableView.frame.size.width
        popMenuTableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CountryChoseCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"))
        popMenuTableView.reloadData()
        
        let area = NSTrackingArea.init(rect: btnConnect.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        btnConnect.addTrackingArea(area)
    }
    
    override func mouseEntered(with theEvent: NSEvent) {

        let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (connectedProgress.isHidden && isOn) {
            return
        }
        if (!isOn) {
            btnConnect.layer?.backgroundColor = NSColor(red: 198/255, green: 196/255, blue: 197/255, alpha: 1).cgColor
        } else {
            btnConnect.layer?.backgroundColor = NSColor(red: 0/255, green: 194/255, blue: 170/255, alpha: 1).cgColor
        }
        
    }
        
    override func mouseExited(with theEvent: NSEvent) {
        
        let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (connectedProgress.isHidden && isOn) {
            return
        }
        
        if (!isOn) {
            btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        } else {
            btnConnect.layer?.backgroundColor = NSColor(red: 4/255, green: 204/255, blue: 190/255, alpha: 1).cgColor
        }
        
    }
    
    @objc func requestData(){
        transcationList.removeAll()
        var balance = TenonP2pLib.sharedInstance.GetBalance()
        
        if balance == UInt64.max {
            balance = 0
        }
        lbTenon.stringValue = String(balance) + " Tenon"
        lbUSD.stringValue = String(format:"%.2f $",Double(balance)*0.002)
        
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
            model.acount = dataDetailArray[2]
            model.amount = dataDetailArray[3]
            transcationList.append(model)
        }
        self.perform(#selector(requestData), with: nil, afterDelay: 3)
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return countryCode.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView:CountryChoseCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"), owner: self) as! CountryChoseCell
        
        cellView.imgIcon.image = NSImage.init(imageLiteralResourceName:iCon[row])
        cellView.lbCountryName.stringValue = countryCode[row]
        cellView.lbNodes.stringValue = countryNodes[row]
        
        return cellView
    }
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        if isSelect == false {
            
            let myRowView:NSTableRowView = tableView.rowView(atRow: row, makeIfNecessary: false)!
            myRowView.selectionHighlightStyle = NSTableView.SelectionHighlightStyle.none
            myRowView.isEmphasized = false
            print("select row at index = " + String(row))
            isSelect = true
            btnChoseCountry.state = NSControl.StateValue(rawValue: 0)
            self.popMenu.isHidden = true
            
            TenonP2pLib.sharedInstance.choosed_country_idx = row
            self.lbCountryName.stringValue = countryCode[row]
            self.imgCountry.image = NSImage.init(imageLiteralResourceName:iCon[row])
            self.lbNodeCount.stringValue = countryNodes[row]
            self.choosed_country = getCountryShort(countryCode: countryCode[row])
            TenonP2pLib.sharedInstance.choosed_country = self.choosed_country
            
            _ = UserDefaults.standard
            let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
            if (!isOn) {
                return false
            }
            
            var use_st: Int32 = 0
            if (mySwitch.on) {
                use_st = 1
            }
            
            stopConnect()
//            SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route:use_st)
//
//            let mode = "global";  // defaults.string(forKey: "ShadowsocksRunningMode")
//                   btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
//            notConnectProgress.isHidden = false
//            connectedProgress.isHidden = true
//            notConnectProgress.progress = 0;
//
//                configureProgressBasedView();
//
//            if isOn {
//
//                if mode == "auto" {
//                    ProxyConfHelper.enablePACProxy()
//                } else if mode == "global" {
//                    ProxyConfHelper.enableGlobalProxy()
//                } else if mode == "manual" {
//                    ProxyConfHelper.disableProxy()
//                } else if mode == "externalPAC" {
//                    ProxyConfHelper.enableExternalPACProxy()
//                }
//            } else {
//
//
//                ProxyConfHelper.disableProxy()
//            }
            return true
        }else{
            return false
        }
    }
    func updateUI() {
        // MARK: 主页面背景色
        window?.backgroundColor = NSColor.white

        
        // MARK: 国家选择按钮
        btnChoseCountry.wantsLayer = true
        btnChoseCountry.layer?.backgroundColor = APP_COLOR.cgColor
        btnChoseCountry.layer?.cornerRadius = 4
        btnChoseCountry.layer?.masksToBounds = true
        lbCountryName.font = NSFont.systemFont(ofSize: 17)
        lbNodeCount.font = NSFont.systemFont(ofSize: 12)
        upgradeBtn.wantsLayer = true
        upgradeBtn.layer?.backgroundColor = NSColor(red: 4/255, green: 204/255, blue: 190/255, alpha: 1).cgColor
        upgradeBtn.layer?.masksToBounds = false
        upgradeBtn.layer?.cornerRadius = 4
        
        settingsBtn.wantsLayer = true
        settingsBtn.layer?.backgroundColor = NSColor(red: 4/255, green: 204/255, blue: 190/255, alpha: 1).cgColor
        settingsBtn.layer?.masksToBounds = false
        settingsBtn.layer?.cornerRadius = 4
        
        // MARK: connect按钮
        btnConnect.wantsLayer = true
        btnConnect.layer?.cornerRadius = 100
        btnConnect.layer?.masksToBounds = true
        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        
        // MARK:connect label
        lbConnect.font = NSFont.systemFont(ofSize: 22)
        vwLine.wantsLayer = true
        vwLine.layer?.backgroundColor = NSColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).cgColor
        
        
        mySwitch = JSSwitch(frame: CGRect(x: smartRouteLabel.frame.maxX, y: smartRouteLabel.frame.minY + 4, width: 60, height: 22));
        baseView.addSubview(mySwitch)
        mySwitch.callback_smart_route = click_smart_route
        mySwitch.on = true
        print(mySwitch.on) // true
        
        progressCircularProgress = CircularProgress(frame: CGRect(x: 43, y: 191, width: 256, height: 256))
          notConnectProgress = CircularProgress(frame: CGRect(x: 43, y: 191, width: 256, height: 256))
          notConnectProgress.lineWidth = 6
          notConnectProgress.color = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1)
        baseView.addSubview(notConnectProgress)
          notConnectProgress.isHidden = true
        smartRouteLabel.textColor = APP_COLOR
          connectedProgress = CircularProgress(frame: CGRect(x: 43, y: 191, width: 256, height: 256))
          connectedProgress.lineWidth = 6
          connectedProgress.color = NSColor(red: 19/255, green: 244/255, blue: 220/255, alpha: 1)
        baseView.addSubview(connectedProgress)
          connectedProgress.isHidden = true
        
        connectedProgress.wantsLayer = true
        notConnectProgress.wantsLayer = true
        let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        
        print ("sub window is on: \(UserDefaults.standard.bool(forKey: "ShadowsocksOn"))")
        if (!isOn) {
            imgConnect.image = NSImage.init(imageLiteralResourceName:"connect")
            lbConnect.stringValue = "Connect"
            btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
            lbTitleBalanced.font = NSFont.systemFont(ofSize: 20)
            lbTitleAddress.font = NSFont.systemFont(ofSize: 20)
            
            notConnectProgress.isHidden = false
            connectedProgress.isHidden = true
            return
        }
        imgConnect.image = NSImage.init(imageLiteralResourceName:"connected")
        lbConnect.stringValue = "Connected"
        
        
        btnConnect.layer?.backgroundColor = NSColor(red: 4/255, green: 204/255, blue: 190/255, alpha: 1).cgColor
        notConnectProgress.isHidden = true
        connectedProgress.isHidden = false
        lbTitleBalanced.font = NSFont.systemFont(ofSize: 20)
        lbTitleAddress.font = NSFont.systemFont(ofSize: 20)

        if (isOn) {
            configureProgressBasedView();
        }
    }

    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }

    
    
    @IBAction func clickUpgrade(_ sender: Any) {
        let version_str = TenonP2pLib.sharedInstance.CheckVersion()
        let plats = version_str.split(separator: ",")
        var down_url: String = "";
        for item in plats {
            let item_split = item.split(separator: ";")
            if (item_split[0] == "mac") {
                if (item_split[1].count > kCurrentVersion.count || item_split[1] > kCurrentVersion) {
                    down_url = String(item_split[2])
                }
                break
            }
        }
        
        if (down_url.isEmpty) {
            _ = dialogOKCancel(question: "", text: "Already the latest version.".localized)
        } else {
            NSWorkspace.shared.open(URL(string: down_url)!)
        }
        
    }
    
    private func animateWithRandomColor(
        _ circularProgress: CircularProgress,
        start: @escaping (CircularProgress) -> Void,
        tick: @escaping (CircularProgress) -> Void
    ) {
        var startAnimating: (() -> Void)!
        var timer: Timer!

        startAnimating = {
            //circularProgress.color = NSColor.uniqueRandomSystemColor()
            start(circularProgress)

            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                tick(circularProgress)
                if (circularProgress.progress > 0.95) {
                    timer.invalidate()
                    self.btnConnect.layer?.backgroundColor = NSColor(red: 4/255, green: 204/255, blue: 190/255, alpha: 1).cgColor
                    self.notConnectProgress.isHidden = true
                    self.connectedProgress.isHidden = false
                    self.connectedProgress.progress = 100;
                                      
                }
                               
            }
        }

        startAnimating()
    }

    
    private func configureProgressBasedView() {
        animateWithRandomColor(
            notConnectProgress,
            start: { circularProgress in
                circularProgress.resetProgress()

                let progress = Progress(totalUnitCount: 50)
                circularProgress.progressInstance = progress
            },
            tick: { circularProgress in
                circularProgress.progressInstance?.completedUnitCount += 6
            }
        )
    }
    
    func ResetConnect() {
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        isOn = !isOn
        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        notConnectProgress.isHidden = false
        connectedProgress.isHidden = true
        notConnectProgress.progress = 0;
        if (isOn) {
            configureProgressBasedView();
        }
        defaults.set(isOn, forKey: "ShadowsocksOn")
        var use_st: Int32 = 0
        if (mySwitch.on) {
            use_st = 1
        }
        SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route:use_st)

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
        } else {

            ProxyConfHelper.disableProxy()
        }
        
        
    }
    
    private func stopConnect() {
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (!isOn) {
            return;
        }
        
        isOn = !isOn
        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        notConnectProgress.isHidden = false
        connectedProgress.isHidden = true
        notConnectProgress.progress = 0;
        if (isOn) {
           configureProgressBasedView();
        }
        
        defaults.set(isOn, forKey: "ShadowsocksOn")
        var use_st: Int32 = 0
        if (mySwitch.on) {
           use_st = 1
        }
        
        SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route:use_st)
        ProxyConfHelper.disableProxy()
    }
    
    @IBAction func clickConnect(_ sender: Any) {
        ResetConnect();
    }
    
    public func click_smart_route() {
        let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (!isOn) {
            return
        }
        
        var use_smart_route: Int32 = 0;
        if (mySwitch.on) {
            use_smart_route = 1
            
        }
        TenonP2pLib.sharedInstance.use_smart_route = use_smart_route
        stopConnect()
//
//        SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route: use_smart_route)
//
//        let mode = "global";  // defaults.string(forKey: "ShadowsocksRunningMode")
//
//        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
//        notConnectProgress.isHidden = false
//        connectedProgress.isHidden = true
//        notConnectProgress.progress = 0;
//
//            configureProgressBasedView();
//
//        if isOn {
//
//            if mode == "auto" {
//                ProxyConfHelper.enablePACProxy()
//            } else if mode == "global" {
//                ProxyConfHelper.enableGlobalProxy()
//            } else if mode == "manual" {
//                ProxyConfHelper.disableProxy()
//            } else if mode == "externalPAC" {
//                ProxyConfHelper.enableExternalPACProxy()
//            }
//        } else {
//
//            ProxyConfHelper.disableProxy()
//        }
    }
    @IBAction func clickSmartRoute(_ sender: Any) {
        let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        if (!isOn) {
            return
        }
        
        var use_st: Int32 = 0
        if (mySwitch.on) {
            use_st = 1
        }
        TenonP2pLib.sharedInstance.use_smart_route = use_st
        stopConnect()
//
//        SyncSSLocal(choosed_country: self.choosed_country, local_country: self.local_country, smart_route:use_st)
//
//        let mode = "global";  // defaults.string(forKey: "ShadowsocksRunningMode")
//
//        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
//        notConnectProgress.isHidden = false
//        connectedProgress.isHidden = true
//        notConnectProgress.progress = 0;
//
//            configureProgressBasedView();
//
//        if isOn {
//
//            if mode == "auto" {
//                ProxyConfHelper.enablePACProxy()
//            } else if mode == "global" {
//                ProxyConfHelper.enableGlobalProxy()
//            } else if mode == "manual" {
//                ProxyConfHelper.disableProxy()
//            } else if mode == "externalPAC" {
//                ProxyConfHelper.enableExternalPACProxy()
//            }
//        } else {
//
//            ProxyConfHelper.disableProxy()
//        }
    }
    @IBAction func clickAccountSetting(_ sender: Any) {
        
        if accountSettingWndCtrl != nil {
            accountSettingWndCtrl.close()
        }
        accountSettingWndCtrl = AcountSettingWndController(windowNibName: .init(rawValue: "AcountSettingWndController"))
        accountSettingWndCtrl.showWindow(self)
        accountSettingWndCtrl.transcationList = transcationList
        accountSettingWndCtrl.refresh()
        NSApp.activate(ignoringOtherApps: true)
        accountSettingWndCtrl.window?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func clickChoseCountry(_ sender: Any) {
        isSelect = false
        if btnChoseCountry.state.rawValue == 0{
            self.popMenu.isHidden = true
            let isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
            if isOn {
                notConnectProgress.isHidden = true
                connectedProgress.isHidden = false
                
            } else {
                notConnectProgress.isHidden = false
                connectedProgress.isHidden = true
            }
        }else{
            self.popMenu.isHidden = false
  
                notConnectProgress.isHidden = true
                connectedProgress.isHidden = true
               
        }
    }
    
}
