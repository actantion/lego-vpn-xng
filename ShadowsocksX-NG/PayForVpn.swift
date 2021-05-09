//
//  PayForVpn.swift
//  ShadowsocksX-NG
//
//  Created by actantion on 2021/4/4.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class PayForVpn: NSWindowController {

    @IBOutlet weak var UseAlipayOrWeChat: NSTextField!
    @IBOutlet weak var coinFirstText: NSTextField!
    @IBOutlet weak var hanbiText: NSTextField!
    @IBOutlet weak var middleText: NSTextField!
    @IBOutlet weak var renminbiText: NSTextField!
    @IBOutlet weak var supportText: NSTextField!
    @IBOutlet weak var niticeText: NSTextField!
    @IBOutlet weak var qrCodeImage: NSImageView!
    
    var hanbi_amount: Int = 0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.backgroundColor = APP_BLACK_COLOR
        UseAlipayOrWeChat.stringValue = "Open Alipay or WeChat scan code".localized
        coinFirstText.stringValue = "Enter Korean".localized
        niticeText.stringValue = "Enter specified amount in Korean Won".localized
        middleText.stringValue = "Won, Exchange US$".localized
        supportText.stringValue = "Get Telegram customer support".localized
        hanbiText.stringValue = String(TenonP2pLib.sharedInstance.choosePayForHanbiAmount)
        if (TenonP2pLib.sharedInstance.choosePayForAmount == 35) {
            renminbiText.stringValue = "$5".localized
        }
        
        if (TenonP2pLib.sharedInstance.choosePayForAmount == 84) {
            renminbiText.stringValue = "$12".localized
        }
        
        if (TenonP2pLib.sharedInstance.choosePayForAmount == 252) {
            renminbiText.stringValue = "$36".localized
        }
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timeRepeat(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func JoinTelegram(_ sender: Any) {
        let url = URL.init(string: "https://t.me/tenonvpn_vip")
        NSWorkspace.shared.open(url!)
    }
    
    @objc func timeRepeat(_ time:Timer) -> Void {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://jhsx123456789.xyz:14431/new_buy_vip_by_ali_weixin_check/" +
                        String(TenonP2pLib.sharedInstance.choosePayForHanbiAmount))
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
            
            let returnData: String = String(data: resData, encoding: .utf8) ?? "1"
            print("error: not a valid http response\(httpResponse), data:\(returnData)")
            if (Int(returnData) == 0) {
                DispatchQueue.main.async {
                    self.qrCodeImage.image = NSImage(named:NSImage.Name(rawValue: "pay_for_vpn_ok"))
                }
            } else {
                print("error: not a valid http response\(httpResponse)")
            }
        }
        
        dataTask.resume()
    }
}
