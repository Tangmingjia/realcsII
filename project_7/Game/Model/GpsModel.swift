import UIKit
import HandyJSON

class GpsModel : HandyJSON {
    var flag: String!
    var data: GpsData?
    required init(){}
}

class GpsData : HandyJSON {
    var gpsEntityList: [gpsEntityList]!
    var total: Int = 0
    var totalNum: Int = 0
    var realcsGameCircleBomb : RealcsGameCircleBomb?
    var realcsGameCirclePoison : RealcsGameCirclePoison?
    var exposePersonList: [ExposePersonListItem]!
    var status: Int = 0
    var airdropEntityList: [AirdropEntityListItem]!
    var gameRule: Int = 0
    var duration: Int = 0
    var gameDuration: Int = 0
    var killNum: Int = 0
    var gameKillNum: Int = 0
    var use: [String]!
    var autoMode: Bool = false
    var autoBoom: Bool = false
    required init(){}
}

class gpsEntityList : HandyJSON {
    var connectStatus: Int = 0
    var direction: Int = 0
    var exposeFlag: Int = 0
    var lat: CLLocationDegrees = 0.0
    var lon: CLLocationDegrees = 0.0
    var personId: Int = 0
    var phoneStatus: Int = 0
    var shieldFlag: Int = 0  //干扰 1:是 0:否
    var banGun: Int = 0      //禁枪 1:是 0:否
    var invincible: Int = 0  //无敌 1:是 0:否
    var teamId: Int = 0
    var blood: Int = 0
    var dyingBlood: Int = 0
    var status: Int = 0
    var defence: Int = 0
    var randang: Int = 0
    var damage: Int = 0
    var killNum: Int = 0
    var ranking: Int = 0
    var personName: String!
    var realcsUpload: RealcsUpload?
    var gpsEquipTypeList: [gpsEquipTypeListItem]!     //身上装备
    var airdropEntityList: [AirdropEntityListItem]!  //附近空投
    var equipEntityList: [EquipEntityListItem]!   //背包内物品
    required init(){}
}

struct gpsEquipTypeListItem : HandyJSON {
    var equipTypeId: Int = 0      //大类id  2:武器 8：背心 9:头盔
    var accesslocation: String!   //图片
    var equipNo: String!          //装备编号,例如83-01010001
    var defence: Int = 0      //装备护甲值
}

class AirdropEntityListItem : HandyJSON {
    var center: String!
    var status: Int = 0
    var airdropId: Int = 0
    var radius: CGFloat = 0.0
    var airdropEquipList: [AirdropEquipListItem]!
    required init(){}
}
class AirdropEquipListItem : HandyJSON {
    var number: Int = 0
    var equipName: String!   //装备id
    var equipNo: [String]!
    var realcsUpload: RealcsUpload?
    required init(){}
}
class EquipEntityListItem : HandyJSON {
    var number: Int = 0
    var equipName: String!
    var equipNo: [String]!
    var realcsUpload: RealcsUpload?
    required init(){}
}

