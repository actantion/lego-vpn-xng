//
//  PrivateKeyWindow.swift
//  ShadowsocksX-NG
//
//  Created by actantion on 2021/3/26.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class PrivateKeyWindow: NSWindowController {
    @IBOutlet weak var privateKeyLable: NSTextField!
    @IBOutlet weak var OkButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.backgroundColor = APP_BLACK_COLOR
        privateKeyLable.stringValue = "Input new private key".localized
        OkButton.stringValue = "OK".localized
        cancelButton.stringValue = "Cancel".localized
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBOutlet weak var privateKey: NSTextField!
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK".localized)
        alert.addButton(withTitle: "Cancel".localized)
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }
    
    @IBAction func ChangePrivateKey(_ sender: Any) {
        let ss: String = privateKey.stringValue;
        if ss == TenonP2pLib.sharedInstance.private_key_ {
            _ = dialogOKCancel(question: "", text: "invalid private key.".localized)
            return
        }
        
        if ss.count != 64 {
            _ = dialogOKCancel(question: "", text: "invalid private key.".localized)
            return
        }
        
        if !TenonP2pLib.sharedInstance.SavePrivateKey(prikey_in: ss) {
            _ = dialogOKCancel(question: "", text: "Set up to 3 private keys.".localized)
            return
        }
        
        if !TenonP2pLib.sharedInstance.ResetPrivateKey(prikey: ss) {
            _ = dialogOKCancel(question: "", text: "invalid private key.".localized)
            return
        }
        
        _ = dialogOKCancel(question: "", text: "after success reset private key, must restart program.".localized)
        UserDefaults.standard.set(false, forKey: "ShadowsocksOn")
        let use_st: Int32 = 1
        SyncSSLocal(choosed_country: TenonP2pLib.sharedInstance.choosed_country, local_country: TenonP2pLib.sharedInstance.local_country, smart_route:use_st)
        ProxyConfHelper.disableProxy()
         _exit(0)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.close()
    }
}
