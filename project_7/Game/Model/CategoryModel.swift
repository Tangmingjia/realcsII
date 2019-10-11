import UIKit
import HandyJSON

class CategoryModel: HandyJSON {
    var respCode: String!
    var data: [CategoryData]!
    var msg: String!
    required init(){}
}
struct CategoryData: HandyJSON {
    var categoryId: Int = 0      //物品id
    var categoryName: String!    //物品名称
    var equipType: Int = 0       //物品类型 1、2、4:武器；8:背心；9:头盔；11:治疗道具;14:解毒剂
    var hurtBlood: Int = 0     //伤害量
    var defenceBlood: Int = 0  //护甲量
    var treatBlood: Int = 0    //治疗量
    var beHurtRate: Int = 0    //伤害倍数
    var persistenceTreat: Int = 0   //是否持续治疗。1.是；2.否
    var rule: String!       //物品id规则
    var imgUrl: String!     //物品图片
}
