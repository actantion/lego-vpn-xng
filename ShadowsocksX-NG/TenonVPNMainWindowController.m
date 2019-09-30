//
//  TenonVPNMainWindowController.m
//  ShadowsocksX-NG
//
//  Created by friend on 2019/9/30.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

#import "TenonVPNMainWindowController.h"

@interface TenonVPNMainWindowController ()

@end

@implementation TenonVPNMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)clickConnect:(id)sender {
    var route_node = self.getOneRouteNode(country: self.choosed_country)
    if (route_node.ip.isEmpty) {
        route_node = self.getOneRouteNode(country: self.local_country)
        if (route_node.ip.isEmpty) {
            for country in self.iCon {
                route_node = self.getOneRouteNode(country: country)
                if (!route_node.ip.isEmpty) {
                    break
                }
            }
        }
        VpnManager.shared.disconnect()
    }
    
    var vpn_node = self.getOneVpnNode(country: self.choosed_country)
    if (vpn_node.ip.isEmpty) {
        for country in self.iCon {
            vpn_node = self.getOneVpnNode(country: country)
            if (!vpn_node.ip.isEmpty) {
                break
            }
        }
    }
    
    VpnManager.shared.ip_address = vpn_node.ip
    VpnManager.shared.port = Int(vpn_node.port)!
    
    print("rotue: \(route_node.ip):\(route_node.port)")
    print("vpn: \(vpn_node.ip):\(vpn_node.port),\(vpn_node.passwd)")
    
    let vpn_ip_int = LibP2P.changeStrIp(vpn_node.ip)
    VpnManager.shared.public_key = LibP2P.getPublicKey() as String
    
    VpnManager.shared.enc_method = ("aes-128-cfb," + String(vpn_ip_int) + "," + vpn_node.port + "," + String(self.smartRoute.isEnabled))
    VpnManager.shared.password = vpn_node.passwd
    VpnManager.shared.algorithm = "aes-128-cfb"
    VpnManager.shared.connect()
}
func getOneRouteNode(country: String) -> (ip: String, port: String) {
    let res_str = LibP2P.getVpnNodes(country, true) as String
    if (res_str.isEmpty) {
        return ("", "")
    }
    
    let node_arr: Array = res_str.components(separatedBy: ",")
    if (node_arr.count <= 0) {
        return ("", "")
    }
    
    let rand_pos = randomCustom(min: 0, max: node_arr.count)
    let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
    if (node_info_arr.count < 5) {
        return ("", "")
    }
    
    return (node_info_arr[0], node_info_arr[2])
}

func getOneVpnNode(country: String) -> (ip: String, port: String, passwd: String) {
    let res_str = LibP2P.getVpnNodes(country, false) as String
    if (res_str.isEmpty) {
        return ("", "", "")
    }
    
    let node_arr: Array = res_str.components(separatedBy: ",")
    if (node_arr.count <= 0) {
        return ("", "", "")
    }
    
    let rand_pos = randomCustom(min: 0, max: node_arr.count)
    let node_info_arr = node_arr[rand_pos].components(separatedBy: ":")
    if (node_info_arr.count < 5) {
        return ("", "", "")
    }
    
    return (node_info_arr[0], node_info_arr[1], node_info_arr[3])
}

@end
