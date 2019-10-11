import UIKit

class BluetoothView : UIView {
    
    var topBar : UIView?
    var backButton : UIButton?
    var reloadButton : UIButton?
    var BluetoothTableView : UITableView?
    
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.topBar = UIView()
        self.addSubview(topBar!)
        
        self.backButton = UIButton()
        self.topBar?.addSubview(backButton!)
        
        self.reloadButton = UIButton()
        self.topBar?.addSubview(reloadButton!)
        
        self.BluetoothTableView = UITableView()
        self.addSubview(BluetoothTableView!)
        
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.topBar?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 40)
        self.topBar?.backgroundColor = UIColor.lightGray
        
        self.backButton?.frame = CGRect(x: 20, y: 10, width: 40, height: 20)
        self.backButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.backButton?.setTitle("返回", for: .normal)
        self.backButton?.setTitleColor(UIColor.black, for: .normal)
        
        self.reloadButton?.frame = CGRect(x: ScreenSize.width-60, y: 10, width: 40, height: 20)
        self.reloadButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.reloadButton?.setTitle("刷新", for: .normal)
        self.reloadButton?.setTitleColor(UIColor.black, for: .normal)
        
        self.BluetoothTableView?.frame = CGRect(x: 0, y: 40, width: ScreenSize.width, height: ScreenSize.height-40)
        self.BluetoothTableView?.backgroundColor = UIColor.white
        self.BluetoothTableView?.separatorInset = UIEdgeInsets.zero   //分割线左边顶格
//        self.BluetoothTableView?.separatorStyle = .none
    }
}
