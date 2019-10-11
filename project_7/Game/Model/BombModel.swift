import UIKit
import HandyJSON

struct BombData : HandyJSON {
    var center: String!         //中心坐标
    var countDown: Int = 0      //动态倒计时
    var radius: Int = 0         //半径
    var status: Int = 0         //状态 0:第一阶段 2:第二阶段 1:结束
    var createTime: Int = 0     //创建时间
    var durationTime: Int = 0   //持续倒计时
    var gameId: Int = 0
    var hurtNum: Int = 0        //伤害值
    var hurtTime: Int = 0       //伤害间隔
    var startTime: Int = 0      //开始倒计时
}

class BombModel : HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var data: BombData?
    var type: Int = 0
    required init(){}
}
