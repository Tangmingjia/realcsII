import UIKit
import HandyJSON

struct PoisonData : HandyJSON {
    var center: String!    //毒圈中心
    var createTime: Int = 0
    var gameId: Int = 0
    var hurtIntervalTime: Int = 0
    var hurtNum: Int = 0   //毒圈伤害
    var poisonType: Int = 0
    var radius: Int = 0    //毒圈半径
    var safetyCenter: String!   //安全区中心
    var safetyRadius: Int = 0   //安全区半径
    var startTime: Int = 0      //开始倒计时
    var status: Int = 0         //毒圈状态  1:第一阶段 2:第二阶段 3:结束 4:暂停 5:重置
    var zoomDuration: Int = 0   //缩圈倒计时
    var zoomSpeed: Int = 0      //索圈、伤害间隔
    var countDown: Int = 0      //动态倒计时
}

class PoisonModel : HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var data: PoisonData?
    var type: Int = 0
    required init(){}
}
