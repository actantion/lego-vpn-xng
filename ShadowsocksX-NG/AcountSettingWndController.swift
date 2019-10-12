//
//  AcountSettingWndController.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/9.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa

class AcountSettingWndController: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var prikeyEdit: NSTextField!
    @IBOutlet weak var accountEdit: NSTextField!
    @IBOutlet weak var lbBanlanceTenon: NSTextField!
    @IBOutlet weak var lbBanlanceDorlar: NSTextField!
    @IBOutlet weak var vwTranscationInfo: NSView!
    @IBOutlet weak var scrollview: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    let appDelegate = (NSApplication.shared.delegate) as! AppDelegate
    var transcationList = [TranscationModel]()
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.backgroundColor = NSColor.white
        // MARK:Transcation下的方块view
        vwTranscationInfo.wantsLayer = true
        vwTranscationInfo.layer?.backgroundColor = APP_COLOR.cgColor
        vwTranscationInfo.layer?.masksToBounds = true
        vwTranscationInfo.layer?.cornerRadius = 4
        
        
        var balance = TenonP2pLib.sharedInstance.GetBalance()
        
        if balance == UInt64.max {
            balance = 0
        }
        lbBanlanceTenon.stringValue = String(balance) + " Tenon"
        lbBanlanceDorlar.stringValue = String(format:"%.2f $",Double(balance)*0.002)
        prikeyEdit.stringValue = appDelegate.local_private_key
        accountEdit.stringValue = appDelegate.local_account_id
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "TranscationInfoCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TranscationInfoCell"))
        tableView.reloadData()
    }
    func refresh() {
        tableView.reloadData()
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return transcationList.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView:TranscationInfoCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TranscationInfoCell"), owner: self) as! TranscationInfoCell
//        cellView.lbDatatime.stringValue = dataSource[row]
        let model:TranscationModel = self.transcationList[row]
//        tempCell.lbDateTime.text = model.dateTime
//        tempCell.lbType.text = model.type
//        tempCell.lbAccount.text = model.acount
//        tempCell.lbAmount.text = model.amount
        cellView.lbDatatime.stringValue = model.dateTime
        cellView.lbType.stringValue = model.type
        cellView.lbAccount.stringValue = model.acount
        cellView.lbAmount.stringValue = model.amount
        return cellView
    }
    
}
