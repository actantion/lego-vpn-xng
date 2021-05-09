//
//  EarnCoinWindow.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/2/20.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa
import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

class EarnCoinWindow: NSWindowController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var lbEarnCoin: NSTextField!
    @IBOutlet weak var lbNotice: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    var payforVpnWnd:PayForVpn!
    var dataArray = [UIBaseModel]()
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.backgroundColor = APP_BLACK_COLOR
        
        initView()
        initTableView()
    }
    func initDataArray(){
        dataArray.append(UIBaseModel(type: .UIPrivateKeyType, title: "Transfer to your account".localized, subTitle: TenonP2pLib.sharedInstance.account_id_, mark: "Copy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType1, title: "Way 1".localized, subTitle: "MONTHLY                    $5".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType2, title: "Way 2".localized, subTitle: "QUARTERLY                  $12 / -20%".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 4.0))
        dataArray.append(UIBaseModel(type: .UIMethodType3, title: "Way 3".localized, subTitle: "ANNUAL           $36 / -40%".localized, mark: "Buy".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType4, title: "Way 4".localized, subTitle: "Share to earn".localized, mark: "Share".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 10.0))
        dataArray.append(UIBaseModel(type: .UIMethodType5, title: "Way 5".localized, subTitle: "Mining".localized, mark: "GO".localized))
        dataArray.append(UIBaseModel(type: .UISpaceType, cellHeight: 20.0))
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
        tableView.tableColumns[0].width = 420
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
        lbEarnCoin.stringValue = "Earn".localized
        lbNotice.stringValue = "Tips: To ensure security, please keep your private key and don’t tell anyone to ensure your account is safe".localized
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
        }else if model.type == .UIMethodType1 {
            return 60
        }else if model.type == .UIMethodType2 {
            return 60
        }else if model.type == .UIMethodType3 {
            return 60
        }else if model.type == .UIMethodType4 {
            return 60
        }else if model.type == .UIMethodType5 {
            return 60
        }else if model.type == .UISpaceType {
            return model.cellHeight
        }else if model.type == .UITranscationHeaderType {
            return 45
        }else{
            return 40
        }
    }
    
    func copyStringToPasteboard(string: String) {
        let pboard = NSPasteboard.general
        pboard.declareTypes([.string], owner: nil)
        pboard.setString(string, forType: .string)
    }
   
    func showCopySuccessAlert() {
        let a: NSAlert = NSAlert()
        a.messageText = "success".localized
        a.informativeText = "copy success".localized
        a.addButton(withTitle: "OK".localized)
        a.alertStyle = NSAlert.Style.warning

        a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
            if(modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn){
                
            }
        })
    }
    
    func getHanbiAmountAndAliPay(local_amount: Int) {

            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let url = URL(string: "https://jhsx123456789.xyz:14431/new_buy_vip_by_ali_weixin_" + String(local_amount) + "/" + TenonP2pLib.sharedInstance.account_id_)
            var request : URLRequest = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField:"Accept")
            let dataTask = session.dataTask(with: url!) {
                data,response,error in
                guard let httpResponse = response as? HTTPURLResponse, let resData = data
                else {
                    print("error: not a valid http response")
                    return
                }

                DispatchQueue.main.async {
                    if (httpResponse.statusCode == 200) {
                        let returnData: String = String(data: resData, encoding: .utf8) ?? "0"
                        print("error: not a valid http response\(httpResponse), data:\(returnData)")
                        TenonP2pLib.sharedInstance.choosePayForAmount = local_amount;
                        TenonP2pLib.sharedInstance.choosePayForHanbiAmount = Int(returnData) ?? 0;
                        self.payforVpnWnd = PayForVpn(windowNibName: .init(rawValue: "PayForVpn"))
                        self.payforVpnWnd.showWindow(self)
                        NSApp.activate(ignoringOtherApps: true)
                        self.payforVpnWnd.window?.makeKeyAndOrderFront(nil)
                        self.window?.close()
                    } else {
                        
                    }
                }
            }
            
            dataTask.resume()

        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let model = dataArray[row]
        if model.type == .UIPrivateKeyType {
            let cellView:UIPrivateKeyCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIPrivateKeyCell"), owner: self) as! UIPrivateKeyCell
            cellView.setModel(model: dataArray[row])
            cellView.clickBlockCopy = {
                self.copyStringToPasteboard(string: TenonP2pLib.sharedInstance.account_id_)
                self.showCopySuccessAlert()
            }
            return cellView
        }else if model.type == .UIMethodType1 {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model, showAliPay: true)
            cellView.clickBlock = {
                let url = URL.init(string: "https://www.tenonvpn.net/pp_one_month/" + TenonP2pLib.sharedInstance.account_id_)
                NSWorkspace.shared.open(url!)
            }
            cellView.clickAli = {
                if self.payforVpnWnd != nil {
                    self.payforVpnWnd.close()
                }
                
                self.getHanbiAmountAndAliPay(local_amount: 35)
            }
            return cellView
        }else if model.type == .UIMethodType2 {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model, showAliPay: true)
            cellView.clickBlock = {
                let url = URL.init(string: "https://www.tenonvpn.net/pp_six_month/" + TenonP2pLib.sharedInstance.account_id_)
                NSWorkspace.shared.open(url!)
            }
            cellView.clickAli = {
                if self.payforVpnWnd != nil {
                    self.payforVpnWnd.close()
                }
                self.getHanbiAmountAndAliPay(local_amount: 84)
            }
            return cellView
        }else if model.type == .UIMethodType3 {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model, showAliPay: true)
            cellView.clickBlock = {
                let url = URL.init(string: "https://www.tenonvpn.net/pp_one_year/" + TenonP2pLib.sharedInstance.account_id_)
                NSWorkspace.shared.open(url!)
            }
            cellView.clickAli = {
                if self.payforVpnWnd != nil {
                    self.payforVpnWnd.close()
                }
                self.getHanbiAmountAndAliPay(local_amount: 252)
            }
            return cellView
        }else if model.type == .UIMethodType4 {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model, showAliPay: false)
            cellView.clickBlock = {
                self.copyStringToPasteboard(string: "https://www.tenonvpn.net?id=" + TenonP2pLib.sharedInstance.account_id_)
                self.showCopySuccessAlert()
            }
            return cellView
        }else if model.type == .UIMethodType5 {
            let cellView:UIMethodCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UIMethodCell"), owner: self) as! UIMethodCell
            cellView.setModel(model: model, showAliPay: false)
            cellView.clickBlock = {
                let url = URL.init(string: "https://github.com/tenondvpn/tenonvpn-join")
                NSWorkspace.shared.open(url!)
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
