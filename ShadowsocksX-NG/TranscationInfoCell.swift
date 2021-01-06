//
//  TranscationInfoCell.swift
//  TenonVPN-Mac
//
//  Created by friend on 2019/10/10.
//  Copyright © 2019 qiuyuzhou. All rights reserved.
//

import Cocoa

class TranscationInfoCell: NSTableCellView {
    @IBOutlet  var lbDatatime: NSTextField!
    @IBOutlet  var lbType: NSTextField!
    @IBOutlet  var lbAccount: NSTextField!
    @IBOutlet  var lbAmount: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
