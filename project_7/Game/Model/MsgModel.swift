import UIKit
import HandyJSON

class MsgModel: HandyJSON {
    var respCode: String!
    var msg: String!
    var flag: String!
    var data: MsgData?
    required init(){}
}

struct MsgData: HandyJSON {
    var personId: Int = 0
    var blood: Int = 0
    var defence: Int = 0
}
