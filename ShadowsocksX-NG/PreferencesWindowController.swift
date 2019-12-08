
import Cocoa
import RxCocoa
import RxSwift

class PreferencesWindowController: NSWindowController
    , NSTableViewDataSource, NSTableViewDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()

    }
    
    @IBAction func clickBuy(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "http://39.105.125.37:7744/chongzhi/" + TenonP2pLib.sharedInstance.account_id_)!)
    }
}
