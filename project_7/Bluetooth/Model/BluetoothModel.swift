import UIKit
import HandyJSON

class BluetoothModel : HandyJSON{
    weak var delegate:BluetoothModelDelegate?

    var BluetoothName: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var BluetoothUUID: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var BluetoothState: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var BluetoothRSSI: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    required init(){}
}
protocol BluetoothModelDelegate : AnyObject {
    func didUpdate(Model:BluetoothModel)
}
