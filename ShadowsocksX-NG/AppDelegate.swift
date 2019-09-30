//
//  AppDelegate.swift
//  ShadowsocksX-NG
//
//  Created by 邱宇舟 on 16/6/5.
//  Copyright © 2016年 qiuyuzhou. All rights reserved.
//

import Cocoa
import Carbon
import RxCocoa
import RxSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var tenonMainWndController:TenonVPNMainWindowController!

    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var runningStatusMenuItem: NSMenuItem!
    @IBOutlet weak var toggleRunningMenuItem: NSMenuItem!

    let kProfileMenuItemIndexBase = 100

    var statusItem: NSStatusItem!
    static let StatusItemIconWidth: CGFloat = NSStatusItem.variableLength
    var local_country: String = ""
    var local_private_key: String = ""
    var local_account_id: String = ""
    
    func ensureLaunchAgentsDirOwner () {
        let dirPath = NSHomeDirectory() + "/Library/LaunchAgents"
        let fileMgr = FileManager.default
        if fileMgr.fileExists(atPath: dirPath) {
            do {
                let attrs = try fileMgr.attributesOfItem(atPath: dirPath)
                if attrs[FileAttributeKey.ownerAccountName] as! String != NSUserName() {
                    //try fileMgr.setAttributes([FileAttributeKey.ownerAccountName: NSUserName()], ofItemAtPath: dirPath)
                    let bashFilePath = Bundle.main.path(forResource: "fix_dir_owner.sh", ofType: nil)!
                    let script = "do shell script \"bash \\\"\(bashFilePath)\\\" \(NSUserName()) \" with administrator privileges"
                    if let appleScript = NSAppleScript(source: script) {
                        var err: NSDictionary? = nil
                        appleScript.executeAndReturnError(&err)
                    }
                }
            }
            catch {
                NSLog("Error when ensure the owner of $HOME/Library/LaunchAgents, \(error.localizedDescription)")
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        _ = LaunchAtLoginController()// Ensure set when launch
        
        self.ensureLaunchAgentsDirOwner()
        
        let local_ip = TenonP2pLib.sharedInstance.getIFAddresses()[0]
        print("local ip:" + local_ip)
        let res = TenonP2pLib.sharedInstance.InitP2pNetwork(local_ip, 7981)
        
        local_country = res.local_country as String
        local_private_key = res.prikey as String
        local_account_id = res.account_id as String
              
        print("local country:" + res.local_country)
        print("private key:" + res.prikey)
        print("account id:" + res.account_id)
        
        InstallSSLocal()
        
        // Prepare defaults
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "ShadowsocksOn": true,
            "ShadowsocksRunningMode": "auto",
            "LocalSocks5.ListenPort": NSNumber(value: 1086 as UInt16),
            "LocalSocks5.ListenAddress": "127.0.0.1",
            "PacServer.ListenAddress":"127.0.0.1",
            "PacServer.ListenPort":NSNumber(value: 1089 as UInt16),
            "LocalSocks5.Timeout": NSNumber(value: 60 as UInt),
            "LocalSocks5.EnableUDPRelay": NSNumber(value: false as Bool),
            "LocalSocks5.EnableVerboseMode": NSNumber(value: false as Bool),
            "GFWListURL": "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt",
            "AutoConfigureNetworkServices": NSNumber(value: true as Bool),
            "LocalHTTP.ListenAddress": "127.0.0.1",
            "LocalHTTP.ListenPort": NSNumber(value: 1087 as UInt16),
            "LocalHTTPOn": true,
            "LocalHTTP.FollowGlobal": false,
            "ProxyExceptions": "127.0.0.1, localhost, 192.168.0.0/16, 10.0.0.0/8, FE80::/64, ::1, FD00::/8",
            "ExternalPACURL": "",
            ])
        
        statusItem = NSStatusBar.system.statusItem(withLength: AppDelegate.StatusItemIconWidth)
        let image : NSImage = NSImage(named: NSImage.Name(rawValue: "menu_icon"))!
        image.isTemplate = true
        statusItem.image = image
        statusItem.menu = statusMenu
<<<<<<< HEAD
=======
        
        let notifyCenter = NotificationCenter.default
        
        _ = notifyCenter.rx.notification(NOTIFY_CONF_CHANGED)
            .subscribe(onNext: { noti in
                self.applyConfig()
                self.updateRunningModeMenu()
                self.updateCopyHttpProxyExportMenu()
            })
        
        notifyCenter.addObserver(forName: NOTIFY_SERVER_PROFILES_CHANGED, object: nil, queue: nil
            , using: {
                (note) in
                let profileMgr = ServerProfileManager.instance
                if profileMgr.activeProfileId == nil &&
                    profileMgr.profiles.count > 0{
                    if profileMgr.profiles[0].isValid(){
                        profileMgr.setActiveProfiledId(profileMgr.profiles[0].uuid)
                    }
                }
                self.updateServersMenu()
                self.updateRunningModeMenu()
                SyncSSLocal()
            }
        )
        _ = notifyCenter.rx.notification(NOTIFY_TOGGLE_RUNNING_SHORTCUT)
            .subscribe(onNext: { noti in
                self.doToggleRunning(showToast: true)
            })
        _ = notifyCenter.rx.notification(NOTIFY_SWITCH_PROXY_MODE_SHORTCUT)
            .subscribe(onNext: { noti in
                let mode = defaults.string(forKey: "ShadowsocksRunningMode")!
                
                var toastMessage: String!;
                switch mode {
                case "auto":
                    defaults.setValue("global", forKey: "ShadowsocksRunningMode")
                    toastMessage = "Global Mode".localized
                case "global":
                    defaults.setValue("manual", forKey: "ShadowsocksRunningMode")
                    toastMessage = "Manual Mode".localized
                case "manual":
                    if self.externalPACModeMenuItem.isEnabled {
                        defaults.setValue("externalPAC", forKey: "ShadowsocksRunningMode")
                        toastMessage = "Auto Mode By External PAC".localized
                    } else {
                        defaults.setValue("auto", forKey: "ShadowsocksRunningMode")
                        toastMessage = "Auto Mode By PAC".localized
                    }
                case "externalPAC":
                    defaults.setValue("auto", forKey: "ShadowsocksRunningMode")
                    toastMessage = "Auto Mode By PAC".localized
                default:
                    defaults.setValue("auto", forKey: "ShadowsocksRunningMode")
                    toastMessage = "Auto Mode By PAC".localized
                }
                
                self.updateRunningModeMenu()
                self.applyConfig()
                
                self.makeToast(toastMessage)
            })
        
        _ = notifyCenter.rx.notification(NOTIFY_FOUND_SS_URL)
            .subscribe(onNext: { noti in
                self.handleFoundSSURL(noti)
            })
        
        // Handle ss url scheme
        NSAppleEventManager.shared().setEventHandler(self
            , andSelector: #selector(self.handleURLEvent)
            , forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        updateMainMenu()
        updateCopyHttpProxyExportMenu()
        updateServersMenu()
        updateRunningModeMenu()
        
        ProxyConfHelper.install()
        ProxyConfHelper.startMonitorPAC()
        applyConfig()

        // Register global hotkey
        ShortcutsController.bindShortcuts()
>>>>>>> parent of 3f9eea2... add ss local config with p2p node
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        StopSSLocal()
        StopPrivoxy()
        ProxyConfHelper.disableProxy()
    }

    func applyConfig() {
        SyncSSLocal()
        
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "ShadowsocksOn")
        let mode = defaults.string(forKey: "ShadowsocksRunningMode")
        
        if isOn {
            if mode == "auto" {
                ProxyConfHelper.enablePACProxy()
            } else if mode == "global" {
                ProxyConfHelper.enableGlobalProxy()
            } else if mode == "manual" {
                ProxyConfHelper.disableProxy()
            } else if mode == "externalPAC" {
                ProxyConfHelper.enableExternalPACProxy()
            }
        } else {
            ProxyConfHelper.disableProxy()
        }
    }

    // MARK: - UI Methods
    @IBAction func toggleRunning(_ sender: NSMenuItem) {
//        self.doToggleRunning(showToast: false)
        tenonMainWndController = TenonVPNMainWindowController(windowNibName: NSNib.Name(rawValue: "TenonVPNMainWindowController"))
        tenonMainWndController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        tenonMainWndController.window?.makeKeyAndOrderFront(nil)
    }
    
    // MARK：连接vpn
    func doToggleRunning(showToast: Bool) {
        let defaults = UserDefaults.standard
        var isOn = UserDefaults.standard.bool(forKey: "ShadowsocksOn")
        isOn = !isOn
        defaults.set(isOn, forKey: "ShadowsocksOn")
        
        self.updateMainMenu()
        self.applyConfig()
        
<<<<<<< HEAD
=======
        if showToast {
            if isOn {
                self.makeToast("Shadowsocks: On".localized)
            }
            else {
                self.makeToast("Shadowsocks: Off".localized)
            }
        }
    }
    
    @IBAction func updateGFWList(_ sender: NSMenuItem) {
        UpdatePACFromGFWList()
    }
    
    @IBAction func editUserRulesForPAC(_ sender: NSMenuItem) {
        if editUserRulesWinCtrl != nil {
            editUserRulesWinCtrl.close()
        }
        let ctrl = UserRulesController(windowNibName: NSNib.Name(rawValue: "UserRulesController"))
        editUserRulesWinCtrl = ctrl
        
        ctrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        ctrl.window?.makeKeyAndOrderFront(self)
    }
    
    @IBAction func showShareServerProfiles(_ sender: NSMenuItem) {
        if shareWinCtrl != nil {
            shareWinCtrl.close()
        }
        shareWinCtrl = ShareServerProfilesWindowController(windowNibName: NSNib.Name(rawValue: "ShareServerProfilesWindowController"))
        shareWinCtrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        shareWinCtrl.window?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func showImportWindow(_ sender: NSMenuItem) {
        if importWinCtrl != nil {
            importWinCtrl.close()
        }
        importWinCtrl = ImportWindowController(windowNibName: .init(rawValue: "ImportWindowController"))
        importWinCtrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        importWinCtrl.window?.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func scanQRCodeFromScreen(_ sender: NSMenuItem) {
        ScanQRCodeOnScreen()
    }
    
    @IBAction func importProfileURLFromPasteboard(_ sender: NSMenuItem) {
        let pb = NSPasteboard.general
        if #available(OSX 10.13, *) {
            if let text = pb.string(forType: NSPasteboard.PasteboardType.URL) {
                if let url = URL(string: text) {
                    NotificationCenter.default.post(
                        name: NOTIFY_FOUND_SS_URL, object: nil
                        , userInfo: [
                            "urls": [url],
                            "source": "pasteboard",
                            ])
                }
            }
        }
        if let text = pb.string(forType: NSPasteboard.PasteboardType.string) {
            var urls = text.split(separator: "\n")
                .map { String($0).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
                .map { URL(string: $0) }
                .filter { $0 != nil }
                .map { $0! }
            urls = urls.filter { $0.scheme == "ss" }
            
            NotificationCenter.default.post(
                name: NOTIFY_FOUND_SS_URL, object: nil
                , userInfo: [
                    "urls": urls,
                    "source": "pasteboard",
                    ])
        }
    }

    @IBAction func selectPACMode(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        defaults.setValue("auto", forKey: "ShadowsocksRunningMode")
        updateRunningModeMenu()
        applyConfig()
    }
    
    @IBAction func selectGlobalMode(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        defaults.setValue("global", forKey: "ShadowsocksRunningMode")
        updateRunningModeMenu()
        applyConfig()
    }
    
    @IBAction func selectManualMode(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        defaults.setValue("manual", forKey: "ShadowsocksRunningMode")
        updateRunningModeMenu()
        applyConfig()
    }
    
    @IBAction func selectExternalPACMode(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        defaults.setValue("externalPAC", forKey: "ShadowsocksRunningMode")
        updateRunningModeMenu()
        applyConfig()
    }
    
    @IBAction func editServerPreferences(_ sender: NSMenuItem) {
        if preferencesWinCtrl != nil {
            preferencesWinCtrl.close()
        }
        preferencesWinCtrl = PreferencesWindowController(windowNibName: NSNib.Name(rawValue: "PreferencesWindowController"))
        
        preferencesWinCtrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func showAllInOnePreferences(_ sender: NSMenuItem) {
        if allInOnePreferencesWinCtrl != nil {
            allInOnePreferencesWinCtrl.close()
        }
        
        allInOnePreferencesWinCtrl = PreferencesWinController(windowNibName: NSNib.Name(rawValue: "PreferencesWinController"))
        
        allInOnePreferencesWinCtrl.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        allInOnePreferencesWinCtrl.window?.makeKeyAndOrderFront(self)
    }
    
    @IBAction func selectServer(_ sender: NSMenuItem) {
        let index = sender.tag - kProfileMenuItemIndexBase
        let spMgr = ServerProfileManager.instance
        let newProfile = spMgr.profiles[index]
        if newProfile.uuid != spMgr.activeProfileId {
            spMgr.setActiveProfiledId(newProfile.uuid)
            updateServersMenu()
            SyncSSLocal()
            applyConfig()
        }
        updateRunningModeMenu()
    }
    
    @IBAction func copyExportCommand(_ sender: NSMenuItem) {
        // Get the Http proxy config.
        let defaults = UserDefaults.standard
        let address = defaults.string(forKey: "LocalHTTP.ListenAddress")!
        let port = defaults.integer(forKey: "LocalHTTP.ListenPort")
        
        // Format an export string.
        let command = "export http_proxy=http://\(address):\(port);export https_proxy=http://\(address):\(port);"
        
        // Copy to paste board.
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(command, forType: NSPasteboard.PasteboardType.string)
        
        // Show a toast notification.
        self.makeToast("Export Command Copied.".localized)
    }
    
    @IBAction func showLogs(_ sender: NSMenuItem) {
        let ws = NSWorkspace.shared
        if let appUrl = ws.urlForApplication(withBundleIdentifier: "com.apple.Console") {
            try! ws.launchApplication(at: appUrl
                ,options: NSWorkspace.LaunchOptions.default
                ,configuration: [NSWorkspace.LaunchConfigurationKey.arguments: "~/Library/Logs/ss-local.log"])
        }
    }
    
    @IBAction func feedback(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://github.com/qiuyuzhou/ShadowsocksX-NG/issues")!)
    }
    
    @IBAction func checkForUpdates(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://github.com/shadowsocks/ShadowsocksX-NG/releases")!)
    }
    
    @IBAction func exportDiagnosis(_ sender: NSMenuItem) {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Diagnosis to File".localized
        savePanel.canCreateDirectories = true
        savePanel.allowedFileTypes = ["txt"]
        savePanel.isExtensionHidden = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        savePanel.nameFieldStringValue = "ShadowsocksX-NG_diagnose_\(dateString)"
        
        savePanel.becomeKey()
        let result = savePanel.runModal()
        if (result.rawValue == NSFileHandlingPanelOKButton) {
            if let url = savePanel.url {
                let diagnosisText = diagnose()
                try! diagnosisText.write(to: url, atomically: false, encoding: String.Encoding.utf8)
            }
        }
    }
    
    @IBAction func showHelp(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://github.com/shadowsocks/ShadowsocksX-NG/wiki")!)
    }
    
    @IBAction func showAbout(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(sender);
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func updateRunningModeMenu() {
        let defaults = UserDefaults.standard
        
        if let pacURL = defaults.string(forKey: "ExternalPACURL") {
            if pacURL != "" {
                externalPACModeMenuItem.isEnabled = true
            } else {
                externalPACModeMenuItem.isEnabled = false
            }
        }

        // Update running mode state
        autoModeMenuItem.state = .off
        globalModeMenuItem.state = .off
        manualModeMenuItem.state = .off
        externalPACModeMenuItem.state = .off
        
        let mode = defaults.string(forKey: "ShadowsocksRunningMode")
        if mode == "auto" {
            autoModeMenuItem.state = .on
        } else if mode == "global" {
            globalModeMenuItem.state = .on
        } else if mode == "manual" {
            manualModeMenuItem.state = .on
        } else if mode == "externalPAC" {
            externalPACModeMenuItem.state = .on
        }
        updateStatusMenuImage()
        
        // Update selected server name
        var serverMenuText = "Servers - (No Selected)".localized
        
        let mgr = ServerProfileManager.instance
        for p in mgr.profiles {
            if mgr.activeProfileId == p.uuid {
                var profileName :String
                if !p.remark.isEmpty {
                    profileName = p.remark
                } else {
                    profileName = p.serverHost
                }
                serverMenuText = "Servers".localized + " - \(profileName)"
                break
            }
        }
        serversMenuItem.title = serverMenuText
>>>>>>> parent of 3f9eea2... add ss local config with p2p node
    }
    
    func updateStatusMenuImage() {
        let defaults = UserDefaults.standard
        let mode = defaults.string(forKey: "ShadowsocksRunningMode")
        let isOn = defaults.bool(forKey: "ShadowsocksOn")
        if isOn {
            if let m = mode {
                switch m {
                    case "auto":
                        statusItem.image = NSImage(named: NSImage.Name(rawValue: "menu_p_icon"))
                    case "global":
                        statusItem.image = NSImage(named: NSImage.Name(rawValue: "menu_g_icon"))
                    case "manual":
                        statusItem.image = NSImage(named: NSImage.Name(rawValue: "menu_m_icon"))
                    case "externalPAC":
                        statusItem.image = NSImage(named: NSImage.Name(rawValue: "menu_e_icon"))
                default: break
                }
                statusItem.image?.isTemplate = true
            }
        } else {
            statusItem.image = NSImage(named: NSImage.Name(rawValue: "menu_icon_disabled"))
            statusItem.image?.isTemplate = true
        }
    }
    
    func updateMainMenu() {
        let defaults = UserDefaults.standard
        let isOn = defaults.bool(forKey: "ShadowsocksOn")
        if isOn {
            runningStatusMenuItem.title = "Shadowsocks: On".localized
            runningStatusMenuItem.image = NSImage(named: NSImage.Name(rawValue: "NSStatusAvailable"))
            toggleRunningMenuItem.title = "Turn Shadowsocks Off".localized
            let image = NSImage(named: NSImage.Name(rawValue: "menu_icon"))
            statusItem.image = image
        } else {
            runningStatusMenuItem.title = "Shadowsocks: Off".localized
            toggleRunningMenuItem.title = "Turn Shadowsocks On".localized
            runningStatusMenuItem.image = NSImage(named: NSImage.Name(rawValue: "NSStatusNone"))
            let image = NSImage(named: NSImage.Name(rawValue: "menu_icon_disabled"))
            statusItem.image = image
        }
        statusItem.image?.isTemplate = true
        
        updateStatusMenuImage()
    }
    
    //------------------------------------------------------------
    // NSUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: NSUserNotificationCenter
        , shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
}

