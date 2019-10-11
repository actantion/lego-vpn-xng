//
//  AcountSettingWndController.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/9.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa

class AcountSettingWndController: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {
    @IBOutlet weak var lbPrivateKey: NSTextField!
    @IBOutlet weak var lbAccountAddress: NSTextField!
    @IBOutlet weak var lbBanlanceTenon: NSTextField!
    @IBOutlet weak var lbBanlanceDorlar: NSTextField!
    @IBOutlet weak var vwTranscationInfo: NSView!
    @IBOutlet weak var scrollview: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    
    
    var dataSource = Array<String>()
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.backgroundColor = NSColor.white
        // MARK:Transcation下的方块view
        vwTranscationInfo.wantsLayer = true
        vwTranscationInfo.layer?.backgroundColor = APP_COLOR.cgColor
        vwTranscationInfo.layer?.masksToBounds = true
        vwTranscationInfo.layer?.cornerRadius = 4
        
        lbPrivateKey.stringValue = "38cb8893459d7f02e06574074dadae46ad2af7a3ac0f2496a113722321fb4cd5"
        lbAccountAddress.stringValue = "647063a6da181dc0b0645add8dd74c1ee018a47f8533db50fd4bc6bdb98852be"
        tableView.delegate = self
        tableView.dataSource = self
        
        dataSource.append("wuyoupeng")
        dataSource.append("wuyoupeng1")
        dataSource.append("wuyoupeng2")
        dataSource.append("wuyoupeng3")
        dataSource.append("wuyoupeng45")
        dataSource.append("wuyoupeng5")
        dataSource.append("wuyoupeng6")
        dataSource.append("wuyoupeng7")
        dataSource.append("wuyoupeng8")
        dataSource.append("wuyoupeng9")
        dataSource.append("wuyoupeng0")
        dataSource.append("wuyoupeng10")
        self.tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "TranscationInfoCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TranscationInfoCell"))
        tableView.reloadData()
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView:TranscationInfoCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TranscationInfoCell"), owner: self) as! TranscationInfoCell
        cellView.lbDatatime.stringValue = dataSource[row]
        return cellView
    }
    
}
