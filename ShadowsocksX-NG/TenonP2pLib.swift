//
//  TenonP2pLib.swift
//  TenonVPN
//
//  Created by actantion on 2019/9/12.
//  Copyright © 2019 zly. All rights reserved.
//

import Foundation
import libp2p

extension Date {
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
}

class TenonP2pLib {
    static let sharedInstance = TenonP2pLib()
    
    public let kCurrentVersion = "5.0.5"
    public var choosed_country_idx = 0
    public var choosed_country: String = "AA"
    public var local_country: String = "CN"
    public var use_smart_route: Int32 = 1
    private let bootstrap: String = "id:42.51.33.89:9001,id:42.51.41.173:9001, id:113.17.169.103:9001,id:113.17.169.105:9001,id:113.17.169.106:9001,id:113.17.169.93:9001,id:113.17.169.94:9001,id:113.17.169.95:9001,id:216.108.227.52:9001,id:216.108.231.102:9001,id:216.108.231.103:9001,id:216.108.231.105:9001,id:216.108.231.19:9001,id:3.12.73.217:9001,id:3.137.186.226:9001,id:3.22.68.200:9001,id:3.138.121.98:9001,id:18.188.190.127:9001,"
    
    public var payfor_timestamp: Int64 = 0
    public var payfor_amount: Int64 = 0
    private var payfor_gid: String = ""
    public var vip_left_days: Int32 = -1
    public var now_balance: Int64 = -1
    public let min_payfor_vpn_tenon: Int64 = 66
    public var share_ip: String = "https://www.tenonvpn.net"
    public var buy_tenon_ip: String = "https://www.tenonvpn.net"
    private var today_used_bandwidth: Int64 = 0
    private var used_bandwidth_tm: Int64 = 0
    private var prev_write_bandwidth_tm: Int64 = 0
    
    public var choosePayForAmount = 35;
    public var choosePayForHanbiAmount = 0;
    
    var payfor_vpn_accounts_arr:[String] = [
        "dc161d9ab9cd5a031d6c5de29c26247b6fde6eb36ed3963c446c1a993a088262",
        "5595b040cdd20984a3ad3805e07bad73d7bf2c31e4dc4b0a34bc781f53c3dff7",
        "25530e0f5a561f759a8eb8c2aeba957303a8bb53a54da913ca25e6aa00d4c365",
        "9eb2f3bd5a78a1e7275142d2eaef31e90eae47908de356781c98771ef1a90cd2",
        "c110df93b305ce23057590229b5dd2f966620acd50ad155d213b4c9db83c1f36",
        "f64e0d4feebb5283e79a1dfee640a276420a08ce6a8fbef5572e616e24c2cf18",
        "7ff017f63dc70770fcfe7b336c979c7fc6164e9653f32879e55fcead90ddf13f",
        "6dce73798afdbaac6b94b79014b15dcc6806cb693cf403098d8819ac362fa237",
        "b5be6f0090e4f5d40458258ed9adf843324c0327145c48b55091f33673d2d5a4"]
    
    public var private_key_ = ""
    public var public_key_ = ""
    public var account_id_ = ""
    var keeped_private_kyes: [String] = []
    
    
    private init() {
        let res = GetPrivateKey();
        let res_split = res.split(separator: ",")
        for item in res_split {
            let tmp_item = item.trimmingCharacters(in: [" ", "\n", "\t"])
            if tmp_item.count != 64 {
                continue
            }
            
            if private_key_.isEmpty {
                private_key_ = tmp_item
            }
            
            keeped_private_kyes.append(tmp_item)
        }
    }
    
    func CreateAccount() {
        LibP2P.createAccoun();
    }
    
    func InitP2pNetwork (
            _ local_ip: String,
            _ local_port: Int) -> (local_country: String, prikey: String, account_id: String, def_route: String) {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file!
        let res = LibP2P.initP2pNetwork(
                local_ip,
                1,
                bootstrap,
                path,
                kCurrentVersion,
                private_key_) as String

        let array : Array = res.components(separatedBy: ",")
        if (array.count < 4) {
            return ("", "", "", "")
        }
        
        GetBandwidthInfo()
        private_key_ = array[2]
        account_id_ = array[1]
        now_balance = Int64(GetBalance())
        return (array[0], array[2], array[1], array[3])
    }
    
    func GetSocketId() -> Int {
        return LibP2P.getSocketId()
    }
    
    func GetVpnNodes(_ country: String, _ route: Bool) -> String {
        let res = LibP2P.getVpnNodes(country, route, vip_left_days > 0) as String
        return res
    }
    
    func GetTransactions() -> String {
        let res = LibP2P.getTransactions() as String
        return res
    }
    
    func GetBalance() -> UInt64 {
        var res = LibP2P.getBalance() as UInt64
        if res == 18446744073709551615 {
            res = 0
        }
        return res
    }
    
    func ResetTransport(_ local_ip: String, _ local_port: Int) {
        LibP2P.resetTransport(local_ip, local_port)
    }
    
    func GetPublicKey() -> String {
        let res = LibP2P.getPublicKey()as String
        public_key_ = res
        return res
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }
        print("Local IP \(addresses)")
        return addresses
    }
    
    func CheckVersion() -> String {
        let res = LibP2P.checkVersion() as String
        return res
    }
    
    func CheckVip() -> Int64 {
        let res: String = LibP2P.checkVip()
        let res_split = res.split(separator: ",")
        if (res_split.count != 2) {
            return Int64.max
        }
        
        payfor_amount = (Int64)(res_split[1]) ?? 0
        payfor_timestamp = (Int64)(res_split[0]) ?? Int64.max
        return payfor_timestamp
    }
    
    func ResetPrivateKey(prikey: String) -> Bool {
        let res: String = LibP2P.resetPrivateKey(prikey)
        let res_split = res.split(separator: ",")
        if res_split.count != 2 {
            return false
        }
        
        private_key_ = prikey
        public_key_ = String(res_split[0])
        account_id_ = String(res_split[1])
        return true
    }
    
    func PayforVpn() {
        now_balance = Int64(GetBalance())
        if now_balance == -1 {
            CreateAccount()
        }
        
        let day_msec: Int64 = 3600 * 1000 * 24;
        let days_timestamp = payfor_timestamp / day_msec;
        let cur_timestamp = Date().milliStamp
        let days_cur = cur_timestamp / day_msec;
        let vip_days = payfor_amount / min_payfor_vpn_tenon
        if (payfor_timestamp != Int64.max && days_timestamp + vip_days > days_cur) {
            payfor_gid = "";
            vip_left_days = Int32((days_timestamp + vip_days - days_cur)) + (Int32)(now_balance / min_payfor_vpn_tenon);
            return;
        } else {
            if (now_balance >= min_payfor_vpn_tenon) {
                PayforVipTrans();
            }
        }
        
        if (now_balance >= 0) {
            vip_left_days = (Int32)(now_balance / min_payfor_vpn_tenon)
        } else {
            vip_left_days = 0
            now_balance = 0
        }

        _ = CheckVip()
    }
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }

    func PayforVipTrans() {
        let rand_num = randomCustom(min: 0, max: payfor_vpn_accounts_arr.count)
        let acc: String = payfor_vpn_accounts_arr[rand_num];
        if (acc.isEmpty) {
            return;
        }
        
        var days = now_balance / min_payfor_vpn_tenon
        if days > 30 {
            days = 30
        }
          
        let amount = days * min_payfor_vpn_tenon
        if amount <= 0 || amount > now_balance {
            return
        }
        payfor_gid = LibP2P.payforVpn(acc, payfor_gid, Int(amount));
    }

    func createFile(name:String, fileBaseUrl:URL){
        let manager = FileManager.default
         
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            //在文件中随便写入一些内容
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
    }
    
    public func SavePrivateKey(prikey_in: String) -> Bool {
        let prikey = prikey_in.trimmingCharacters(in: [" "])
        if prikey.count != 64 {
            return false
        }

        if keeped_private_kyes.contains(prikey) {
            let idx = keeped_private_kyes.index(of: prikey)
            if idx ?? -1 >= 0 {
                keeped_private_kyes.remove(at: idx ?? -1)
            }
        }
        
        if keeped_private_kyes.count >= 3 {
            return false
        }
        
        var tmp_str: String = prikey
        for item in keeped_private_kyes {
            tmp_str += "," + item
        }
        
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/pridata"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        if exist {
            do {
                try manager.removeItem(atPath: path)
            } catch {
                return false
            }
        }
        
        do {
            try tmp_str.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            return false
        }
            
        return true
    }
    
    func GetPrivateKey() -> String {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/pridata"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        if !exist {
            return ""
        }
        
        do {
            let prikey = try String(contentsOfFile: path, encoding: .utf8)
            return prikey
        } catch {
            return ""
        }
    }
    
    func GetBackgroudStatus() -> String {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/pristatus"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        if !exist {
            return "ok"
        }
        
        do {
            let status = try String(contentsOfFile: path, encoding: .utf8)
            return status
        } catch {
            return "ok"
        }
    }
    
    func GetStatusFilepath() -> String {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/pristatus"
        return path
    }
    
    func ResetBackgroundStatus() {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/pristatus"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        if exist {
            do {
                try manager.removeItem(atPath: path)
            } catch {
                return
            }
        }
        
        do {
            let tmp_str = "ok"
            try tmp_str.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
        }
    }
    
    func GetBandwidthFilepath() -> String {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/bd"
        return path
    }
    
    func GetBandwidthInfo() {
        let file = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).first
        let path = file! + "/bd"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        let today_used_bandwidth_tm = Date().milliStamp / (3600 * 24 * 1000)
        if exist {
            do {
                let bandwidth_info = try String(contentsOfFile: path, encoding: .utf8)
                let res_split = bandwidth_info.split(separator: ",")
                if res_split.count == 2 {
                    used_bandwidth_tm = Int64(res_split[0]) ?? today_used_bandwidth_tm
                    today_used_bandwidth = Int64(res_split[1]) ?? 0
                    if today_used_bandwidth_tm != used_bandwidth_tm {
                        today_used_bandwidth = 0
                        used_bandwidth_tm = today_used_bandwidth_tm
                    }
                }
            } catch {
                return
            }
        }
    }
    
    func IsExceededBandwidth() -> Bool {
        if (vip_left_days > 0) {
            return false
        }
        
        return today_used_bandwidth >= 20 * 1024 * 1024;
    }
}
