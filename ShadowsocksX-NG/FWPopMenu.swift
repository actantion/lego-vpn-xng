//
//  FWPopMenu.swift
//  TenonVPN
//
//  Created by friend on 2019/9/10.
//  Copyright © 2019 zly. All rights reserved.
//

import Cocoa
let SCREEN_WIDTH = (NSScreen.main?.frame.size.width)!
let SCREEN_HEIGHT = (NSScreen.main?.frame.size.height)!
typealias callBackCellForRow = (NSTableCellView,IndexPath) -> (AnyObject)
typealias clickCellRow = (Int) -> (Void)
class FWPopMenu: NSView,NSTableViewDelegate,NSTableViewDataSource,NSGestureRecognizerDelegate {
    
    var callBackBlk : callBackCellForRow?
    var clickBlck: clickCellRow?
    var cellName:String!
    var tableView:NSTableView!
    var rowCount:Int!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame:CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.TapGestureRecognizer()
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.tableView = NSTableView(frame: frame)
        self.tableView.delegate = self
//        self.tableView.showsVerticalScrollIndicator = false
//        self.tableView.showsHorizontalScrollIndicator = false
//        self.tableView.separatorStyle = NSTableCellView.SeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.backgroundColor = NSColor.white
        self.addSubview(self.tableView)
        self.cellName = ""
    }
    func TapGestureRecognizer() -> Void {
        let tap:NSGestureRecognizer = NSGestureRecognizer.init()
//        tap.numberOfTapsRequired = 1 //轻点次数
//        tap.numberOfTouchesRequired = 1 //手指个数
//        tap.delegate = self
//        tap.addTarget(self, action: #selector(tapAction(action:)))
        self.addGestureRecognizer(tap)
    }
    /*轻点手势的方法*/
//    @objc func tapAction(action:UITapGestureRecognizer) -> Void {
//        self.clickBlck!(-1)
//    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldReceive touch: NSTouch) ->   Bool {
//        if String(describing: touch.view.classForCoder) == "UITableViewCellContentView" {
//            return false
//        } else {
//            return true
//        }
        return true
    }
    
    public func loadCell(_ cellName:String ,_ rowCount:Int){
        self.cellName = cellName
        self.rowCount = rowCount
//        self.tableView.register(NSNib(nibName: cellName, bundle: nil), forIdentifier: cellName)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
//    func tableView(_ tableView: NSTableView, cellForRowAt indexPath: IndexPath) -> NSTableCellView {
////        let cell:NSTableCellView = tableView.reUseCell(self.cellName)
////        return self.callBackBlk!(cell,indexPath) as! UITableViewCell
//        return NSTableCellView
//    }
    
    func tableView(_ tableView: NSTableView, didSelectRowAt indexPath: IndexPath) {
//        self.clickBlck!(indexPath.index)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
