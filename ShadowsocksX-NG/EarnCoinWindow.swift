//
//  EarnCoinWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class EarnCoinWindow: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var lbEarnCoin: NSTextField!
    @IBOutlet weak var lbNotice: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    var dataArray = [UIBaseModel]()
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        
        initView()
        initTableView()
    }
    func initDataArray(){
        dataArray.append(UIBaseModel(type: .UIPrivateKeyType, title: "Method one".localized, subTitle: "aaasdfasdfasdfasdfasdfasdfqwerqwefasdfasdfasfasdfasdf", mark: "Copy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "Method two".localized, subTitle: "$9 per month".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "Method three".localized, subTitle: "$21 per quarter/20% off".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "Method four".localized, subTitle: "$62 per year /60% off".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "Method five".localized, subTitle: "Watch ads to earn Tenon".localized, mark: "Go".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "Method six".localized, subTitle: "Share to earn Tenon".localized, mark: "Share".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 20.0))
        loadTranscation()
    }
    func loadTranscation() {
        let transcation = "02-09 09:30,2,asdfasdfqwerasdfasdf,16,900,0,0;"
        if transcation.count != 0 {
            dataArray.append(UIBaseModel(type: .UITipsType, title: "OrderList".localized))
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
                    typeValue = "pay_for_vpn".localized
                }else if Int(type) == 2 {
                    typeValue = "transfer_out".localized
                }else if Int(type) == 3 {
                    typeValue = "recharge".localized
                }else if Int(type) == 4 {
                    typeValue = "transfer_in".localized
                }else if Int(type) == 5 {
                    typeValue = "share_reward".localized
                }else if Int(type) == 6 {
                    typeValue = "watch_ad_reward".localized
                }else if Int(type) == 7 {
                    typeValue = "mining".localized
                }
                dataArray.append(UIBaseModel(type: .UITranscationType, color: (idx%2 == 0 ? NSColor.white : APP_GREEN_COLOR), dataArray:[transDataArray[0],typeValue,transDataArray[3],transDataArray[4]]))
                idx += 1
            }
        }
    }
    func initTableView() {
        initDataArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableColumns[0].width = 310
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UIPrivateKeyCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIPrivateKeyCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UISpaceCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UISpaceCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UIMethodCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITipsCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITipsCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITranscationHeaderCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationHeaderCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UITranscationCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UITranscationCell"))
        tableView.reloadData()
    }
    func initView(){
        // 中英文转
    }
    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return false
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let model = dataArray[row]
        if model.type == .UIPrivateKeyType {
            return 130
        }else if model.type == .UIMethodType {
            return 60
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
        if model.type == .UIPrivateKeyType {
            let cellView:UIPrivateKeyCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIPrivateKeyCell"), owner: self) as! UIPrivateKeyCell
            cellView.setModel(model: dataArray[row])
            cellView.clickBlockCopy = {
                print("拷贝私钥")
            }
            return cellView
        }else if model.type == .UIMethodType {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model)
            cellView.clickBlock = {
                print("点击按钮")
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
