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
        dataArray.append(UIBaseModel(type: .UIPrivateKeyType, title: "保护好私钥", subTitle: "aaasdfasdfasdfasdfasdfasdfqwerqwefasdfasdfasfasdfasdf", mark: "复制"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "方式一", subTitle: "包月", desc: "5 美元", mark: "购买"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "方式二", subTitle: "包季", desc: "12 美元/8折", mark: "购买"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "方式三", subTitle: "包年", desc: "36 美元/6折", mark: "购买"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "方式四", subTitle: "观看广告获得Tenon", mark: "进入"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType, title: "方式五", subTitle: "分享获得Tenon", mark: "分享"))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 20.0))
    }
    func initTableView() {
        initDataArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableColumns[0].width = 310
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UIPrivateKeyCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIPrivateKeyCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UISpaceCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UISpaceCell"))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "UIMethodCell"), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"))
        
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
            return 44
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
        }else{
            let cellView:UISpaceCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UISpaceCell"), owner: self) as! UISpaceCell
            return cellView
        }
    }
}
