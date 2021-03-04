//
//  WithdrawCoinWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/3/4.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class WithdrawCoinWindow: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {
    @IBOutlet weak var tableView: EditableTableView!
    var dataArray = [UIBaseModel]()
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        
        initTableView()
    }
    func initDataArray(){
        dataArray.append(UIBaseModel(type: .UIWithdrawType))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        loadTranscation()
    }
    func loadTranscation() {
        let transcation = TenonP2pLib.sharedInstance.GetTransactions()
        if transcation.count != 0 {
            dataArray.append(UIBaseModel(type: .UITipsType, title: "History".localized))
            dataArray.append(UIBaseModel(type: .UITranscationHeaderType))
            let array = transcation.components(separatedBy: ";")
            var idx = 0
            for oneTransca in array {
                let transDataArray = oneTransca.components(separatedBy: ",")
                if transDataArray.count < 4 {
                    continue
                }
                let type = transDataArray[1]
                var typeValue = ""
                if Int(type) == 1 {
                    typeValue = "To VPN".localized
                }else if Int(type) == 2 {
                    typeValue = "Trans Out".localized
                }else if Int(type) == 3 {
                    typeValue = "recharge".localized
                }else if Int(type) == 4 {
                    typeValue = "Tran In".localized
                }else if Int(type) == 5 {
                    typeValue = "Share Reward".localized
                }else if Int(type) == 6 {
                    typeValue = "Ad Reward".localized
                }else if Int(type) == 7 {
                    typeValue = "Mining".localized
                }
                dataArray.append(UIBaseModel(type: .UITranscationType, color: (idx%2 == 0 ? APP_BLACK_COLOR2 : APP_BLACK_COLOR1), dataArray:[transDataArray[0],typeValue,transDataArray[2],transDataArray[3]]))
                idx += 1
            }
        }
    }
    func initTableView() {
        initDataArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableColumns[0].width = 310
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UIWithdrawCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIWithdrawCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UISpaceCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UISpaceCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITipsCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITranscationHeaderCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationHeaderCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITranscationCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationCell"))
        tableView.reloadData()
    }
    
    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return false
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let model = dataArray[row]
        if model.type == .UIWithdrawType {
            return 270
        }else if model.type == .UISpaceType {
            return model.cellHeight
        }else if model.type == .UITranscationHeaderType {
            return 45
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let model = dataArray[row]
        if model.type == .UIWithdrawType{
            let cellView:UIWithdrawCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIWithdrawCell"), owner: self) as! UIWithdrawCell
            cellView.setModel(model: model)
            cellView.clickTX = { (pk,tenon) in
                print("发起提现 私钥 = \(pk) tenon币数量 = \(tenon)")
            }
            return cellView
        }else if model.type == .UITipsType {
            let cellView:UITipsCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"), owner: self) as! UITipsCell
            cellView.setModel(model: model)
            return cellView
        }else if model.type == .UITranscationHeaderType {
            let cellView:UITranscationHeaderCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationHeaderCell"), owner: self) as! UITranscationHeaderCell
            cellView.setModel(model: model)
            return cellView
        }else if model.type == .UITranscationType {
            let cellView:UITranscationCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationCell"), owner: self) as! UITranscationCell
            cellView.setModel(model: model)
            return cellView
        }else{
            let cellView:UISpaceCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UISpaceCell"), owner: self) as! UISpaceCell
            return cellView
        }
    }
}
