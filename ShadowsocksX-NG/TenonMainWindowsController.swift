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
    var isSelect: Bool = false
    var accountSettingWndCtrl:AcountSettingWndController!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        updateUI()
        popMenuTableView.delegate = self
        popMenuTableView.dataSource = self
        popMenuTableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CountryChoseCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"))
        popMenuTableView.reloadData()
        
//        let tap:NSClickGestureRecognizer = NSClickGestureRecognizer.init()
//        tap.numberOfClicksRequired = 1 //轻点次数
//        tap.delegate = self
//        tap.action = #selector(tapAction)
//        popMenu.addGestureRecognizer(tap)
        
    }
//    @objc func tapAction() {
//        print("隐藏")
//    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView:CountryChoseCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CountryChoseCell"), owner: self) as! CountryChoseCell
        cellView.imgIcon.image = NSImage.init(imageLiteralResourceName:"us")
        cellView.lbCountryName.stringValue = "China"
        cellView.lbNodes.stringValue = String(row) + " nodes"
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
