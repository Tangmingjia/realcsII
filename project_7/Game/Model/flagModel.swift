import UIKit
import HandyJSON

class flagModel: HandyJSON {
    var flag: String!
    var data: String!
    required init(){}
}

class poisonFlagModel: HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var data: [RealcsGameCirclePoison]!
    var type: Int = 0
    required init(){}
}
