//
//  EditableTableView.swift
//  ShadowsocksX-NG
//
//  Created by admin on 2021/3/4.
//  Copyright © 2021 qiuyuzhou. All rights reserved.
//

import Cocoa

class EditableTableView: NSTableView {

    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool{
        return true
    }
}
