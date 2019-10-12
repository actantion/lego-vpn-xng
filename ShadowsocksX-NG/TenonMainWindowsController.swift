//
//  TenonMainWindowsController.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/8.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa
let APP_COLOR:NSColor = NSColor(red: 9/255, green: 222/255, blue: 202/255, alpha: 1)
class TenonMainWindowsController: NSWindowController,NSTableViewDelegate,NSTableViewDataSource,NSGestureRecognizerDelegate {
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
    @IBOutlet weak var topView: NSView!
    @IBOutlet weak var btnSelectSmartRoute: NSButton!
    @IBOutlet weak var lbCountryName: NSTextField!
    @IBOutlet weak var lbNodeCount: NSTextField!
    @IBOutlet weak var imgCountry: NSImageView!
    @IBOutlet weak var vwLine: NSView!
    var choosed_country:String!
    var transcationList = [TranscationModel]()
    let appDelegate = (NSApplication.shared.delegate) as! AppDelegate
    
    var countryCode:[String] = ["America", "Singapore", "Brazil","Germany","France","Korea", "Japan", "Canada","Australia","Hong Kong", "India", "England","China"]
    var countryNodes:[String] = []
    var iCon:[String] = ["us", "sg", "br","de","fr","kr", "jp", "ca","au","hk", "in", "gb","cn"]
    var isSelect: Bool = false
    var accountSettingWndCtrl:AcountSettingWndController!
    
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
    
    override func windowDidLoad() {
        super.windowDidLoad()
//        [((AppDelegate *)([UIApplication sharedApplication].delegate)) showMainViewController];
//        local_country = res.local_country as String
//        local_private_key = res.prikey as String
//        local_account_id = res.account_id as String
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        updateUI()
        requestData()
        for _ in countryCode {
            countryNodes.append((String)(Int(arc4random_uniform((UInt32)(900))) + 100) + " nodes")
        }
        self.lbCountryName.stringValue = countryCode[0]
        self.imgCountry.image = NSImage.init(imageLiteralResourceName:iCon[0])
        self.lbNodeCount.stringValue = countryNodes[0]
        self.choosed_country = getCountryShort(countryCode: countryNodes[0])
        
        lbAccountAddress.stringValue = String(appDelegate.local_account_id.prefix(10)) + "..." + String(appDelegate.local_account_id.suffix(10))
        popMenuTableView.delegate = self
        popMenuTableView.dataSource = self
        popMenuTableView.tableColumns[0].width = popMenuTableView.frame.size.width
        popMenuTableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CountryChoseCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"))
        popMenuTableView.reloadData()
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
            
            self.lbCountryName.stringValue = countryCode[row]
            self.imgCountry.image = NSImage.init(imageLiteralResourceName:iCon[row])
            self.lbNodeCount.stringValue = countryNodes[row]
            self.choosed_country = getCountryShort(countryCode: countryNodes[row])
            return true
        }else{
            return false
        }
    }
    func updateUI() {
        // MARK: 主页面背景色
        window?.backgroundColor = NSColor.white
        
        // MARK: 顶部黑色视图
        topView.wantsLayer = true
        topView.layer?.backgroundColor = NSColor.black.cgColor
        topView.needsDisplay = true
        
        // MARK: 国家选择按钮
        btnChoseCountry.wantsLayer = true
        btnChoseCountry.layer?.backgroundColor = APP_COLOR.cgColor
        btnChoseCountry.layer?.cornerRadius = 4
        btnChoseCountry.layer?.masksToBounds = true
        lbCountryName.font = NSFont.systemFont(ofSize: 17)
        lbNodeCount.font = NSFont.systemFont(ofSize: 12)
        
        // MARK: connect按钮
        btnConnect.wantsLayer = true
        btnConnect.layer?.cornerRadius = 100
        btnConnect.layer?.masksToBounds = true
        btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        
        // MARK:connect label
        lbConnect.font = NSFont.systemFont(ofSize: 17)
        vwLine.wantsLayer = true
        vwLine.layer?.backgroundColor = NSColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1).cgColor
        
    }
    
    @IBAction func clickConnect(_ sender: Any) {
        
        if self.btnConnect.state.rawValue == 0 {
            print("connect")
            imgConnect.image = NSImage.init(imageLiteralResourceName:"connect")
            lbConnect.stringValue = "Connect"
            btnConnect.layer?.backgroundColor = NSColor(red: 218/255, green: 216/255, blue: 217/255, alpha: 1).cgColor
        }else{
            print("connected")
            imgConnect.image = NSImage.init(imageLiteralResourceName:"connected")
            lbConnect.stringValue = "Connected"
            btnConnect.layer?.backgroundColor = APP_COLOR.cgColor
        }
    }
    @IBAction func clickSmartRoute(_ sender: Any) {
        if btnSelectSmartRoute.state.rawValue == 1{
            print("selected")
        }else{
            print("unselect")
        }
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
        }else{
            self.popMenu.isHidden = false
        }
    }
    
}
