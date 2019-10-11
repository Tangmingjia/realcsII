import UIKit
import HandyJSON

class ItemModel: HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var type: Int = 0
    var data: ItemData?
    required init(){}
}
class ItemData: HandyJSON {
    var personId: Int = 0
    var list: [Itemlist]!
    required init(){}
}
class Itemlist: HandyJSON {
    var inUse: Int = 0
    var realcsEquipCategory: EquipCategory?
    var surplusDefence: Int = 0
    var used: Int = 0
    required init(){}
}
struct EquipCategory: HandyJSON {
    var categoryId: Int = 0          //物品id
//    var categoryName: String!        //物品名称
    var img: Int = 0                 //物品数量
//    var multipleUse: Int = 0
//    var persistenceTreat: Int = 0
}
class sendModel: HandyJSON {
    var realcsEquipCategory = EquipCategory()
    required init(){}
}
