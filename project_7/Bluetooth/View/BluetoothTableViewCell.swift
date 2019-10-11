import UIKit

class BluetoothTableViewCell : UITableViewCell,BluetoothModelDelegate{
    
    var model: BluetoothModel? {
        didSet{
            BluetoothName?.text = model!.BluetoothName
            BluetoothUUID?.text = model!.BluetoothUUID
            BluetoothState?.text = model!.BluetoothState
            BluetoothRSSI?.text = model!.BluetoothRSSI
            model?.delegate = self
        }
    }
    
    var BluetoothName : UILabel?
    
    var BluetoothUUID : UILabel?
    
    var BluetoothState : UILabel?
    
    var BluetoothRSSI : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.BluetoothName = UILabel()
        self.addSubview(BluetoothName!)
        
        self.BluetoothUUID = UILabel()
        self.addSubview(BluetoothUUID!)
        
        self.BluetoothState = UILabel()
        self.addSubview(BluetoothState!)
        
        self.BluetoothRSSI = UILabel()
        self.addSubview(BluetoothRSSI!)
        
        setUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        model?.delegate = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){

//        self.BluetoothName?.frame = CGRect(x: 20, y: 10, width: ScreenSize.width, height: 20)
        self.BluetoothName?.frame = CGRect(x: 20, y: 10, width: ScreenSize.width-200, height: 20)
        self.BluetoothName?.font = UIFont.systemFont(ofSize: 14)
        self.BluetoothName?.textColor = UIColor.black
        
//        self.BluetoothUUID?.frame = CGRect(x: 20, y: 30, width: ScreenSize.width, height: 20)
        self.BluetoothUUID?.frame = CGRect(x: 20, y: 30, width: ScreenSize.width-200, height: 20)
        self.BluetoothUUID?.font = UIFont.systemFont(ofSize: 14)
        self.BluetoothUUID?.textColor = UIColor.black
        
//        self.BluetoothState?.frame = CGRect(x: ScreenSize.width-70, y: 20, width: 50, height: 20)
        self.BluetoothState?.frame = CGRect(x: ScreenSize.width-270, y: 20, width: 50, height: 20)
        self.BluetoothState?.font = UIFont.systemFont(ofSize: 14)
        self.BluetoothState?.textColor = UIColor.black
        self.BluetoothState?.textAlignment = .right
        
//        self.BluetoothRSSI?.frame = CGRect(x: ScreenSize.width-150, y: 20, width: 50, height: 20)
        self.BluetoothRSSI?.frame = CGRect(x: ScreenSize.width-350, y: 20, width: 50, height: 20)
        self.BluetoothRSSI?.font = UIFont.systemFont(ofSize: 14)
        self.BluetoothRSSI?.textColor = UIColor.black
        self.BluetoothRSSI?.textAlignment = .right
    }
    
    func didUpdate(Model: BluetoothModel) {
        BluetoothName?.text = Model.BluetoothName
        BluetoothUUID?.text = Model.BluetoothUUID
        BluetoothState?.text = Model.BluetoothState
        BluetoothRSSI?.text = Model.BluetoothRSSI
    }
}
