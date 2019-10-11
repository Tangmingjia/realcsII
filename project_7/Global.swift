//
//  Global.swift
//  project_7
//
//  Created by JimTang on 2019/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

let ScreenSize = UIScreen.main.bounds.size
//百度地图用
let mapId = "8vOxkjPGbmRL6TciLGvvL2MGRqZYToYH"
//微信登陆用
let appId = "wxefa108f8e01af35b"
let secret = "55b9152ef2315e4ba4485cb9fb1f3188"
var accessToken: String = ""
var ticket: String = ""
var refreshToken: String = ""
var openId: String = ""
var unionId: String = ""
var nickName: String = ""
var headImgUrl: String = ""
var mapType : BMKUserTrackingMode = BMKUserTrackingModeFollowWithHeading //地图类型，默认罗盘模式
var mapPath : String?   //瓦片路径
var packageNo : String?  //腰包编号
var oId : String?       //组织id
var personId : Int?     //人员id
var gameId : Int?       //游戏id
var teamId : Int?       //队伍id
var Host : String?      //服务器ip
var isContinue : Bool = false   //是否需要重连的标示

let myCentralBlueTooth = MyCentralBlueTooth.share  //申明蓝牙单例
var BluetoothdataSources: [BluetoothModel] = []      //蓝牙模型
var BluetoothArray: [BluetoothModel_2] = []
