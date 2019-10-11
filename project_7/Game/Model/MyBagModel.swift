import UIKit
import HandyJSON

class MyBagModel : HandyJSON{
    weak var delegate:MyBagModelDelegate?
    
    var MyBlood: Int = 0 {
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
    var MyKill: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var MyDamage: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    required init(){}
}
protocol MyBagModelDelegate : AnyObject {
    func didUpdate(Model:MyBagModel)
}
