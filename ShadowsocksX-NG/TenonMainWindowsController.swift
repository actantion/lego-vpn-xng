//
//  TenonMainWindowsController.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/8.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa
let APP_COLOR:NSColor = NSColor(red: 9/255, green: 222/255, blue: 202/255, alpha: 1)
class TenonMainWindowsController: NSWindowController {
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
    var accountSettingWndCtrl:AcountSettingWndController!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        updateUI()
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
        
        // MARK: tableview初始化
        
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
//        if btnChoseCountry.state.rawValue == 1{
//            self.popMenu.removeFromSuperview()
//        }else{
//            self.popMenu = FWPopMenu.init(frame:CGRect(x: self.btnChoseCountry.left, y: self.btnChoseCountry.bottom, width: self.btnChoseCountry.width, height: SCREEN_HEIGHT/2))
//            self.popMenu.loadCell("CountryTableViewCell", countryCode.count)
//            self.popMenu.callBackBlk = {(cell,indexPath) in
//                let tempCell:CountryTableViewCell = cell as! CountryTableViewCell
//                tempCell.backgroundColor = APP_COLOR
//                tempCell.lbNodeCount.text = self.countryNodes[indexPath.row]
//                tempCell.lbCountryName.text = self.countryCode[indexPath.row]
//                tempCell.imgIcon.image = UIImage(named:self.iCon[indexPath.row])
//                return tempCell
//            }
//            self.popMenu.clickBlck = {(idx) in
//                if idx != -1{
//                    self.btnChoseCountry.setTitle(self.countryCode[idx], for: UIControl.State.normal)
//                    self.imgCountryIcon.image = UIImage(named:self.iCon[idx])
//                    self.lbNodes.text = self.countryNodes[idx]
//                    self.choosed_country = super.getCountryShort(countryCode: self.countryCode[idx])
//                    if VpnManager.shared.vpnStatus == .on{
//                        self.clickConnect(self.btnConnect as Any)
//                    }
//                }
//
//                self.popMenu.removeFromSuperview()
//                self.isClick = !self.isClick
//            }
//            self.view.addSubview(self.popMenu)
//        }
    }
    
}
