import UIKit
import HandyJSON

class MyModel : HandyJSON{
    weak var delegate:MyModelDelegate?
    
    var MyBlood: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyDyingBlood: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyArmor: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyName: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyIcon: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyState: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyShield: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyPackageState: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    required init(){}
}
protocol MyModelDelegate : AnyObject {
    func didUpdate(Model:MyModel)
}
