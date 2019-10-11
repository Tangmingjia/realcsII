import UIKit
import Starscream
import CoreLocation
import Kingfisher
import Alamofire
import SVProgressHUD

class GameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource,WebSocketDelegate,ZFJVoiceBubbleDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,GCDAsyncSocketDelegate,BMKLocationManagerDelegate{

    var weatherMain : String?    //主要天气
    var weatherDescription : String?  //具体天气
    var weather : WHWeatherType?   //天气类型
    var syncTile = BMKLocalSyncTileLayer()   //瓦片
    var btn : ZFJVoiceBubble!            //语音工具
    var clientSocket : GCDAsyncSocket?   //socket连接mina服务器
    let gps = CLLocationManager()        //gps
    var websocket : WebSocket?           //websocket
    var gameRule : Int?
    var gunNO : String?
    var hatNO : String?
    var clothesNO : String?
    var ReportArray : Array = [String]()
    var beUsedArray : Array = [String]()
//    var Equip : Dictionary = [Int? : gpsEquipTypeListItem]()
    var Equip : Dictionary = [Int : RealcsGamePersonEquipListItem]()
    var centerLat: CLLocationDegrees?
    var centerLon: CLLocationDegrees?
    var center : CLLocationCoordinate2D?
    var i = 0
    var j = 0
    var airdrop : [AirdropEntityListItem]?
    var gameCountDown : Int = 0   //游戏倒计时
    var isConnect : Bool = true   //1秒之前是否有网
    var isSuccess : Bool = true   //接口是否走通
    var healNum : Int = 0
    var LastBlood : Int = 0
    var MyBlood : Int = 0
    var MyDyingBlood : Int = 0
    var MyArmor : Int = 0
    var MyIcon : String = ""
    var MyName : String = ""
    var MyLat: CLLocationDegrees?
    var MyLon: CLLocationDegrees?
    var MyState : Int = 1
    var MyKill : Int = 0
    var MyDamage : Int = 0
    var MyShield : Int = 0   //干扰
    var MyInvincible : Int = 0 //无敌
    var MyBanGun : Int = 0 //禁枪
    var MyPackageState : Int = 0
    var MyTeamName : Array = [String]()
    var MyTeamIcon : Array = [String]()
    var MyTeamBlood : Array = [Int]()
    var MyTeamDyingBlood : Array = [Int]()
    var MyTeamArmor : Array = [Int]()
    var MyTeamState : Array = [Int]()
    var MyTeamKill : Array = [Int]()
    var MyTeamDamage : Array = [Int]()
    var TeamName : Array = [String]()
    var TeamIcon : Array = [String]()
    var TeamDamage : Array = [Int]()
    var TeamKill : Array = [Int]()
    var TeamSurvival : Array = [Int]()
    var TeamDead : Array = [Int]()
    var TeamState : Array = [Int]()
    var TeamSurvival_h : Int?
    var TeamSurvival_m : Int?
    var TeamSurvival_s : Int?
    var TeamRank : Int?
    var results_stats : Int?
    var MyTeamPersonId : Array = [Int]()
    var savePersonId : Int?
    var annotationArray = [BMKPointAnnotation()]
    var airdropArray = [BMKPointAnnotation()]
    var airdropCenter : Array = [String]()
    var LonArray : Array = [CLLocationDegrees]()
    var LatArray : Array = [CLLocationDegrees]()
    var IconArray : Array = [String]()
    var sendBagArray : [sendModel] = []
    var bagItemArray : Array = [EquipCategory]()
    var bagItemString : String = ""
    var bagItemTotal : Int = 0
    var bagItemNo : Array = [[String]]()
    var nearItemNum : Array = [Int]()
    var nearItemNo : Array = [[String]]()
    var nearItemNo_2 : Array = [String]()
    var nearItemId : Array = [Int]()
    var nearItemDropId : Array = [Int]()
    var ItemRow : Int?
    var bloodTimer : Timer?
    var changebloodNum : Int = 0
    var num = 5
    var startgameTimer : Timer?
    var talkTimer : Timer?
    var talknum = 10
    var autoMode : Bool = false
    var lastString : String = "ccc"    //"aaa" 毒圈 "bbb" 轰炸 "ccc" 无、濒死掉血死
    var BombAnnotation = BMKPointAnnotation()
    var bombCenter : Array = [String]()
    var BombCircle : BMKCircle?
    var BombCenter : CLLocationCoordinate2D?
    var BombRadius : CLLocationDistance?
    var BombState : Int?
    var BCountDown_1 : Int = 0
    var BCountDown_2 : Int = 0
    var BhurtNum : Int = 0
    var BhurtTime : Int = 0
    var Btimer_1 : Timer?
    var Btimer_2 : Timer?
    var poisonList : Array = [RealcsGameCirclePoison]()   //自动缩毒毒圈集合
    var poisonNum : Int = 0   //当前毒圈是第几个
    var poisonInterval : Int = 0  //每个毒圈缩毒的间隔时间
    var PoisonAnnotation = BMKPointAnnotation()
    var bCenter : Array = [String]()
    var sCenter : Array = [String]()
    var PoisonCircle_B : BMKCircle?
    var PoisonCenter_B : CLLocationCoordinate2D?
    var PoisonRadius_B : CLLocationDistance?
    var PoisonCircle_S : BMKCircle?
    var PoisonCenter_S : CLLocationCoordinate2D?
    var PoisonRadius_S : CLLocationDistance?
    var currSec : Int = 0
    var zoomCount : Int = 0
    var currZoomLevel : Int = 0
    var zoomDuration : Int = 0
    var zoomSpeed : Int = 0
    var PoisonState : Int?
    var PCountDown : Int = 0
    var PCountDown_0 : Int = 0
    var PCountDown_1 : Int = 0
    var PCountDown_2 : Int = 0
    var PhurtNum : Int = 0
    var PNewLat : CLLocationDegrees?
    var PNewLon : CLLocationDegrees?
    var PNewRadius : CLLocationDistance?
    var PLevel : Double?
    var Ptimer_1 : Timer?
    var Ptimer_2 : Timer?
    var Ptimer_3 : Timer?
    var CircleBomb = RealcsGameCircleBomb()
    var CirclePoison = RealcsGameCirclePoison()
    var game : GameView?
    var gpsstr : String = ""
    var whoami : String = ""
    var phoneState : String = ""
    var equipjsonString : String = ""
    var heartTimer : Timer?
    var phoneStateTimer : Timer?
    var getDataTimer : Timer?
    var heartjsonData : Data?
    var phoneStatejsonData : Data?
    var equipjsonData : Data?
    var gpsjsonData : Data?
    var msgjsonData : Data?
    var url : URL?
    var cafstr : String = ""
    var caf : String?
    var teamorworld : String?
    var TeamVoiceName : Array = [String]()
    var TeamUrlArray : Array = [URL]()
    var WorldVoiceName : Array = [String]()
    var WorldUrlArray : Array = [URL]()
    var userLocation: BMKUserLocation = BMKUserLocation()  //定位
    var param: BMKLocationViewDisplayParam = BMKLocationViewDisplayParam()  //精度圈
    var TeamdataSources: [TeamModel] = []      //队伍模型
    var MydataSources = MyModel()   //我的模型
    var MybagdataSources = MyBagModel() //我的背包模型
    var CategoryDic: Dictionary = [Int:CategoryData]()   //存放物品信息
    var DyingTimer : Timer?   //濒死计时器
    var rebornTimer : Timer?   //复活计时器
    var rebornNum : Int = 4
    var gpsTimer : Timer?
    var disconnectTimer : Timer?   //断网计时器
//    lazy var onecode : Void = {
//        gpsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendgps), userInfo: nil, repeats: true)
//        gpsTimer?.fire()
//    }()
    
    //MARK:Lazy loading
    lazy var locationManager: BMKLocationManager = {
        //初始化BMKLocationManager的实例
        let manager = BMKLocationManager()
        //设置定位管理类实例的代理
        manager.delegate = self
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
        //设定定位精度，默认为 kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        manager.activityType = CLActivityType.automotiveNavigation
        //指定定位是否会被系统自动暂停，默认为NO
        manager.pausesLocationUpdatesAutomatically = false
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        manager.allowsBackgroundLocationUpdates = false
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        manager.locationTimeout = 10
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(noti(n:)), name: NSNotification.Name(rawValue: "noti"), object: nil)
        
        //获取物品信息
        getCategoryData()
        
        //gps
        gps.delegate = self
        gps.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        gps.distanceFilter = 1
        gps.requestAlwaysAuthorization()
        gps.requestWhenInUseAuthorization()
        gps.startUpdatingLocation()
        
        //webscoket
        websocket = WebSocket(url: URL(string: "http://\(Host!):8998/websocket/\(gameId!)/0/\(teamId!)/\(personId!)")!)
        websocket!.delegate = self
        websocket!.connect()

        //scoket
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
        do {
            try clientSocket?.connect(toHost: Host!, onPort: 25409)
        }
        catch {
        }
        
        //心跳包
        whoami = "{\"ACTION\":\"phone-whoami\",\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\",\"DATA\":{\"GAME_ID\":\(gameId!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(teamId!)}}\r\n"
        heartjsonData = whoami.data(using: String.Encoding.utf8, allowLossyConversion: false)

        //发送心跳包
        heartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(heart), userInfo: nil, repeats: true)
        
        game = GameView()
        game?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.view.addSubview(game!)

        game?.map?.mapView?.delegate = self
        //开启定位服务
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        game?.talkbtn?.Button1?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.talkbtn?.Button2?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.talkbtn?.Button3?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.TeamButton?.addTarget(self, action: #selector(openTeam), for: .touchUpInside)
        game?.talk?.TableView1?.delegate = self
        game?.talk?.TableView1?.dataSource = self
        game?.talk?.TableView2?.delegate = self
        game?.talk?.TableView2?.dataSource = self
        game?.talk?.TableView3?.delegate = self
        game?.talk?.TableView3?.dataSource = self
        game?.TeamCollectionView?.delegate = self
        game?.TeamCollectionView?.dataSource = self
        game?.TeamTableView?.delegate = self
        game?.TeamTableView?.dataSource = self
        game?.my?.model = MydataSources
        game?.bag?.model = MybagdataSources
        game?.bag?.bagTableView?.delegate = self
        game?.bag?.bagTableView?.dataSource = self
        game?.bag?.nearTableView?.delegate = self
        game?.bag?.nearTableView?.dataSource = self
        game?.bag?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap_2(sender:))))
        game?.results?.teamResultsTableView?.delegate = self
        game?.results?.teamResultsTableView?.dataSource = self
        if isAllowed == true {
            game?.Speech?.sendURLAction = {(_ voiceUrl: URL) -> Void in
                self.url = URL(fileURLWithPath: voiceUrl.absoluteString)
            }
        }
        game?.BagButton?.addTarget(self, action: #selector(openbag), for: .touchUpInside)
        game?.operation?.useButton?.addTarget(self, action: #selector(useItem), for: .touchUpInside)
        game?.operation?.dropButton?.addTarget(self, action: #selector(dropItem), for: .touchUpInside)
        game?.operation?.cancelButton?.addTarget(self, action: #selector(hiddenOperation), for: .touchUpInside)
        game?.SaveView?.okbtn?.addTarget(self, action: #selector(save), for: .touchUpInside)
        game?.results?.logoutButton?.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        //打开个性化地图
        BMKMapView.enableCustomMapStyle(true)
        //隐藏精度圈
        param.isAccuracyCircleShow = false
        //更新定位图层个性化样式
        param.locationViewImage = UIImage(named: "locationImage.png")
        game?.map?.mapView?.updateLocationView(with: param)
        game?.map?.mapView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:))))
        
//        currentNetReachability()
    }
    
    //MARK:Initialization method
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //获取个性化地图模板文件路径
        let path = Bundle.main.path(forResource: "custom_map_config", ofType: "json")!
        //设置个性化地图样式
        BMKMapView.customMapStyle(path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false  //防止右滑返回
        game?.map?.mapView?.viewWillAppear()
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        game?.map?.mapView?.viewWillDisappear()
        timerStop()
        websocket?.disconnect()
        clientSocket?.disconnect()
        websocket?.delegate = nil
        clientSocket?.delegate = nil
        websocket = nil
        clientSocket = nil
        game?.dyingImage?.animationImages = nil
        game?.shieldImage?.animationImages = nil
        game?.my?.Blood?.animationImages = nil
        game?.my?.DyingBlood?.animationImages = nil
        game?.my?.Armor?.animationImages = nil
        GameCollectionViewCell().TeamBlood?.animationImages = nil
        GameCollectionViewCell().TeamDyingBlood?.animationImages = nil
        GameCollectionViewCell().TeamArmor?.animationImages = nil
        TeamTableViewCell().TeamBlood?.animationImages = nil
        TeamTableViewCell().TeamDyingBlood?.animationImages = nil
        TeamTableViewCell().TeamArmor?.animationImages = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        websocket?.disconnect(forceTimeout: 0)
        websocket?.delegate = nil
    }
    //登出
    @objc func logout(){
        isContinue = false
        self.navigationController?.popViewController(animated: true)
    }
    //游戏初始化
    func gameInit(){
        ReportArray.removeAll()
        WorldUrlArray.removeAll()
        WorldVoiceName.removeAll()
        TeamUrlArray.removeAll()
        TeamVoiceName.removeAll()
        game?.talk?.TableView1?.reloadData()
        game?.talk?.TableView2?.reloadData()
        game?.talk?.TableView3?.reloadData()
        game?.talkbtn?.NewTip1?.isHidden = true
        game?.talkbtn?.NewTip2?.isHidden = true
        game?.talkbtn?.NewTip3?.isHidden = true
        gunNO = nil
        hatNO = nil
        clothesNO = nil
        MyBlood = 100
        MyDyingBlood = 100
        MyArmor = 0
        game?.map?.mapView?.removeAnnotation(PoisonAnnotation)
        game?.map?.mapView?.removeAnnotation(BombAnnotation)
        game?.map?.mapView?.remove(PoisonCircle_B)
        game?.map?.mapView?.remove(PoisonCircle_S)
        game?.map?.mapView?.remove(BombCircle)
        MyTeamBlood.removeAll()
        MyTeamDyingBlood.removeAll()
        MyTeamArmor.removeAll()
        MyTeamState.removeAll()
        Equip.removeAll()
        bagItemTotal = 0
        bagItemArray.removeAll()
        bagItemNo.removeAll()
        nearItemId.removeAll()
        nearItemNo.removeAll()
        nearItemNum.removeAll()
        nearItemNo_2.removeAll()
        nearItemDropId.removeAll()
        game?.bag?.bagTableView?.reloadData()
        game?.bag?.nearTableView?.reloadData()
        game?.bag?.isHidden = true
        game?.TeamView?.isHidden = true
        game?.operation?.isHidden = true
        game?.SaveView?.isHidden = true
        game?.dyingImage?.isHidden = true
        game?.TotalNum?.isHidden = true
        game?.gameKillNum?.isHidden = true
        game?.gameCountDown?.isHidden = true
        changeMystate()
        freshMydata()
        timerStop()
    }
    //所有计时器停止
    func timerStop(){
        if getDataTimer != nil{
            getDataTimer?.invalidate()  //销毁定时器
            getDataTimer = nil
        }
        if Ptimer_1 != nil {
            Ptimer_1?.invalidate()
            Ptimer_1 = nil
        }
        if Ptimer_2 != nil {
            Ptimer_2?.invalidate()
            Ptimer_2 = nil
        }
        if Ptimer_3 != nil {
            Ptimer_3?.invalidate()
            Ptimer_3 = nil
        }
        if Btimer_1 != nil {
            Btimer_1?.invalidate()
            Btimer_1 = nil
        }
        if Btimer_2 != nil {
            Btimer_2?.invalidate()
            Btimer_2 = nil
        }
        if bloodTimer != nil {
            bloodTimer?.invalidate()
            bloodTimer = nil
        }
        if DyingTimer != nil {
            DyingTimer?.invalidate()
            DyingTimer = nil
        }
        if phoneStateTimer != nil {
            phoneStateTimer?.invalidate()
            phoneStateTimer = nil
        }
        if rebornTimer != nil {
            rebornTimer?.invalidate()
            rebornTimer = nil
        }
        if startgameTimer != nil {
            startgameTimer?.invalidate()
            startgameTimer = nil
        }
        if talkTimer != nil {
            talkTimer?.invalidate()
            talkTimer = nil
        }
        if disconnectTimer != nil {
            disconnectTimer?.invalidate()
            disconnectTimer = nil
        }
    }
    //时间格式转换
    func changeTimeType(countdown: inout Int) -> String {
        let hh = Int(floor(Double(countdown/3600)))
        let mm = Int(floor(Double((countdown%3600)/60)))
        let ss = (countdown%3600)%60
        let countdownString =  String(format:"%02d",hh)+":"+String(format:"%02d",mm)+":"+String(format:"%02d",ss)
        return countdownString
    }
    //游戏倒计时
    func changeGameCountDown(){
        let attributeString = NSMutableAttributedString(string: "结束倒计时:"+self.changeTimeType(countdown: &self.gameCountDown))
        let range: NSRange = (attributeString.string as NSString).range(of:self.changeTimeType(countdown: &self.gameCountDown))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
        self.game?.gameCountDown?.attributedText = attributeString
    }
    //断网时需要用到的方法
    @objc func disconnectAction(){
        if self.gameCountDown > 0 {
            self.gameCountDown -= 1
            self.changeGameCountDown()
        }
    }
    //创建轰炸区
    func createBomb(){
        self.game?.map?.mapView?.remove(self.BombCircle)  //移除旧数据
        self.BombCenter = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bombCenter[1]))!, longitude: (CLLocationDegrees(self.bombCenter[0]))!)
        self.BombCircle = BMKCircle(center: self.BombCenter!, radius: self.BombRadius!)
        self.game?.map?.mapView?.add(self.BombCircle)
        if Btimer_1 == nil {   //添加倒计时
            Btimer_1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bombCountDown), userInfo: nil, repeats: true)
            Btimer_1?.fire()
        }
    }
    //轰炸倒计时
    @objc func bombCountDown(){
        self.game?.Bombtitle?.removeFromSuperview()
        self.game?.map?.mapView?.removeAnnotation(self.BombAnnotation)
        if self.BombState == 0{  //轰炸第一阶段 不掉血 只有倒计时
            //添加倒计时
            self.BombAnnotation.coordinate = self.BombCenter!
            self.BombAnnotation.title = changeTimeType(countdown: &self.BCountDown_1)
            self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
            if self.isSuccess {  //如果轮询接口走通了
                self.isConnect = true
            }else{   //如果轮询接口没走通
                self.isConnect = false
                if self.BCountDown_1 > 0 {
                    self.BCountDown_1 -= 1
                }else{
                    self.BombState = 2
                }
            }
        }else if self.BombState == 2 {  //轰炸第二阶段 掉血
            if Btimer_2 == nil {   //添加轰炸掉血方法
                Btimer_2 = Timer.scheduledTimer(timeInterval: TimeInterval(self.BhurtTime), target: self, selector: #selector(bombHurt), userInfo: nil, repeats: true)
                Btimer_2?.fire()
            }
            if self.isSuccess {  //如果轮询接口走通了
                //添加倒计时
                self.BombAnnotation.coordinate = self.BombCenter!
                self.BombAnnotation.title = changeTimeType(countdown: &self.BCountDown_1)
                self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
            }else{   //如果轮询接口没走通
                if isConnect {  //如果第二阶段开始时轮询接口一直是走通状态
                    self.BombAnnotation.coordinate = self.BombCenter!
                    self.BombAnnotation.title = changeTimeType(countdown: &self.BCountDown_1)
                    self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
                    if self.BCountDown_1 > 0 {
                        self.BCountDown_1 -= 1
                    }else{
                        self.BombState = 1
                    }
                }else{   //如果第二阶段开始时轮询接口一直是未走通状态
                    self.BombAnnotation.coordinate = self.BombCenter!
                    self.BombAnnotation.title = changeTimeType(countdown: &self.BCountDown_2)
                    self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
                    if self.BCountDown_2 > 0 {
                        self.BCountDown_2 -= 1
                    }else{
                        self.BombState = 1
                    }
                }
            }
        }else if self.BombState == 1 {  //轰炸结束
            self.game?.map?.mapView?.remove(self.BombCircle) //移除轰炸区
            if Btimer_1 != nil{   //移除轰炸倒计时
                Btimer_1?.invalidate()
                Btimer_1 = nil
            }
            if Btimer_2 != nil{  //移除轰炸掉血
                Btimer_2?.invalidate()
                Btimer_2 = nil
            }
        }
    }
    //轰炸扣血
    @objc func bombHurt() {
        if isInside(Lat_1: self.MyLat!, Lon_1: self.MyLon!, Lat_2: Double(self.bombCenter[1])!, Lon_2: Double(self.bombCenter[0])!, radius: self.BombRadius!) == true && self.MyInvincible == 0{  //在轰炸区内，并且非无敌状态
            self.lastString = "bbb"
            if self.MyBlood > 0 {
                if (self.MyBlood - self.BhurtNum) > 0 {
                    self.MyBlood -= self.BhurtNum
                }else{
                    self.MyBlood = 0
                }
            }else{
                if (self.MyDyingBlood - self.BhurtNum) > 0 {
                    self.MyDyingBlood -= self.BhurtNum
                }else{
                    self.MyDyingBlood = 0
                }
            }
            self.changeMystate()
            self.freshMydata()
        }
    }
    //移除毒圈
    func removePoison(){
        if Ptimer_1 != nil{  //移除画圈方法
            Ptimer_1?.invalidate()
            Ptimer_1 = nil
        }
        if Ptimer_2 != nil{  //移除缩圈方法
            Ptimer_2?.invalidate()
            Ptimer_2 = nil
        }
        if Ptimer_3 != nil{  //移除掉血方法
            Ptimer_3?.invalidate()
            Ptimer_3 = nil
        }
        self.game?.map?.mapView?.remove(self.PoisonCircle_B)
        self.game?.map?.mapView?.remove(self.PoisonCircle_S)
        self.game?.Poisontitle?.removeFromSuperview()
        self.game?.map?.mapView?.removeAnnotation(self.PoisonAnnotation)
    }
    //创建毒圈
    func createPoison(){
        if Ptimer_1 == nil {
            Ptimer_1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(poisonCountDown), userInfo: nil, repeats: true)
            Ptimer_1?.fire()
        }
    }
    //毒圈倒计时
    @objc func poisonCountDown(){
        self.game?.Poisontitle?.removeFromSuperview()
        self.game?.map?.mapView?.removeAnnotation(self.PoisonAnnotation)
        if self.PoisonState == 1 {   //毒圈第一阶段只读秒 不缩圈 不扣血
            if Ptimer_2 != nil {  //移除缩圈方法,自动缩毒时会用到这个
                Ptimer_2?.invalidate()
                Ptimer_2 = nil
            }
            if self.isSuccess {  //如果轮询接口走通了
                drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                drawPoisonCircle(lat: (CLLocationDegrees(self.bCenter[1]))!, lon: (CLLocationDegrees(self.bCenter[0]))!, radius: self.PoisonRadius_B!)
                //添加倒计时
                self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown_1)
                self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                self.isConnect = true
            }else{   //如果轮询接口没走通
                if self.poisonList.count > 0 && self.poisonNum < self.poisonList.count {   //自动缩毒
                    self.sCenter = self.poisonList[poisonNum].safetyCenter.components(separatedBy: ",")
                    self.bCenter = self.poisonList[poisonNum].center.components(separatedBy: ",")
                    self.PoisonRadius_S = CLLocationDistance(self.poisonList[poisonNum].safetyRadius)
                    self.PoisonRadius_B = CLLocationDistance(self.poisonList[poisonNum].radius)
                    self.zoomDuration = self.poisonList[poisonNum].zoomDuration
                    self.poisonInterval = self.poisonList[poisonNum].startTime
                    if self.isConnect {
                        self.PCountDown = self.PCountDown_1
                    }else{
                        if self.poisonList[poisonNum].countDown > 0 {
                            self.PCountDown = self.poisonList[poisonNum].countDown
                        }else{
                            self.PCountDown = self.poisonList[poisonNum].startTime
                        }
                    }
                    drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                    drawPoisonCircle(lat: (CLLocationDegrees(self.bCenter[1]))!, lon: (CLLocationDegrees(self.bCenter[0]))!, radius: self.PoisonRadius_B!)
                    //添加倒计时
                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                    self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown)
                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                    self.PCountDown -= 1
                    self.poisonList[poisonNum].countDown = self.PCountDown
                    if self.PCountDown == 0 {
                        self.PoisonState = 2
                    }
                }else{  //非自动缩毒
                    drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                    drawPoisonCircle(lat: (CLLocationDegrees(self.bCenter[1]))!, lon: (CLLocationDegrees(self.bCenter[0]))!, radius: self.PoisonRadius_B!)
                    //添加倒计时
                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                    self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown_1)
                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                    if self.PCountDown_1 > 0 {
                        self.PCountDown_1 -= 1
                    }else{
                        self.PoisonState = 2
                    }
                }
                self.isConnect = false
            }
        }else if self.PoisonState == 2 {  //毒圈第二阶段 读秒 缩圈 掉血
            if self.isSuccess {  //如果轮询接口走通了
                if Ptimer_2 != nil {  //移除缩圈方法
                    Ptimer_2?.invalidate()
                    Ptimer_2 = nil
                }
                self.PNewLat = CLLocationDegrees(self.bCenter[1])
                self.PNewLon = CLLocationDegrees(self.bCenter[0])
                self.PNewRadius = self.PoisonRadius_B
                drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                drawPoisonCircle(lat: (CLLocationDegrees(self.bCenter[1]))!, lon: (CLLocationDegrees(self.bCenter[0]))!, radius: self.PoisonRadius_B!)
                //添加倒计时
                self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown_1)
                self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                self.isConnect = true
            }else{   //如果轮询接口没走通
                if self.poisonList.count > 0 && self.poisonNum < self.poisonList.count{   //自动缩毒
                    self.sCenter = self.poisonList[poisonNum].safetyCenter.components(separatedBy: ",")
                    self.bCenter = self.poisonList[poisonNum].center.components(separatedBy: ",")
                    self.PoisonRadius_S = CLLocationDistance(self.poisonList[poisonNum].safetyRadius)
                    self.PoisonRadius_B = CLLocationDistance(self.poisonList[poisonNum].radius)
                    self.zoomDuration = self.poisonList[poisonNum].zoomDuration
                    self.poisonInterval = self.poisonList[poisonNum].startTime
                    if self.isConnect {
                        self.PCountDown = self.PCountDown_1
                    }else{
                        if self.poisonList[poisonNum].countDown > 0 {
                            self.PCountDown = self.poisonList[poisonNum].countDown
                        }else{
                            self.PCountDown = self.poisonList[poisonNum].zoomDuration
                        }
                    }
                    drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                    if Ptimer_2 == nil {  //添加缩圈方法
                        Ptimer_2 = Timer.scheduledTimer(timeInterval: TimeInterval(self.zoomSpeed), target: self, selector: #selector(changePoisonCircle), userInfo: nil, repeats: true)
                        Ptimer_2?.fire()
                    }
                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                    self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown)
                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                    self.PCountDown -= 1
                    self.poisonList[poisonNum].countDown = self.PCountDown
                    if self.PCountDown == 0 {
                        if self.poisonNum < self.poisonList.count-1 { //非最后一次
                            self.poisonNum += 1
                            self.PoisonState = 1
                        }else{  //最后一次
                            self.PoisonState = 3
                        }
                    }
                }else{   //非自动缩毒
                    drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
                    if Ptimer_2 == nil {  //添加缩圈方法
                        Ptimer_2 = Timer.scheduledTimer(timeInterval: TimeInterval(self.zoomSpeed), target: self, selector: #selector(changePoisonCircle), userInfo: nil, repeats: true)
                        Ptimer_2?.fire()
                    }
                    if isConnect {  //如果第二阶段开始时轮询接口一直是走通状态
                        self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                        self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown_1)
                        self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                        if self.PCountDown_1 > 0 {
                            self.PCountDown_1 -= 1
                        }else{
                            self.PoisonState = 3
                        }
                    }else{   //如果第二阶段开始时轮询接口一直是未走通状态
                        self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                        self.PoisonAnnotation.title = changeTimeType(countdown: &self.PCountDown_2)
                        self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                        if self.PCountDown_2 > 0 {
                            self.PCountDown_2 -= 1
                        }else{
                            self.PoisonState = 3
                        }
                    }
                }
                self.isConnect = false
            }
            if Ptimer_3 == nil {  //添加毒圈掉血方法
                Ptimer_3 = Timer.scheduledTimer(timeInterval: TimeInterval(self.zoomSpeed), target: self, selector: #selector(poisonHurt), userInfo: nil, repeats: true)
                Ptimer_3?.fire()
            }
        }else if self.PoisonState == 3 { //毒圈第三阶段 不读秒 不缩圈 掉血
            self.game?.map?.mapView?.remove(self.PoisonCircle_B)
            self.PNewLat = CLLocationDegrees(self.sCenter[1])
            self.PNewLon = CLLocationDegrees(self.sCenter[0])
            self.PNewRadius = self.PoisonRadius_S
            drawSafetyCircle(lat: (CLLocationDegrees(self.sCenter[1]))!, lon: (CLLocationDegrees(self.sCenter[0]))!, radius: self.PoisonRadius_S!)
            if Ptimer_3 == nil {  //添加毒圈掉血方法
                Ptimer_3 = Timer.scheduledTimer(timeInterval: TimeInterval(self.zoomSpeed), target: self, selector: #selector(poisonHurt), userInfo: nil, repeats: true)
                Ptimer_3?.fire()
            }
            if Ptimer_2 != nil{  //移除缩圈方法
                Ptimer_2?.invalidate()
                Ptimer_2 = nil
            }
        }else if self.PoisonState == 5 { //重置毒圈
            removePoison()
        }
    }
    //添加安全区
    func drawSafetyCircle(lat: CLLocationDegrees, lon: CLLocationDegrees, radius: CLLocationDistance){
        self.game?.map?.mapView?.remove(self.PoisonCircle_S)
        self.PoisonCenter_S = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.PoisonCircle_S = BMKCircle(center: self.PoisonCenter_S!, radius: radius)
        self.game?.map?.mapView?.add(self.PoisonCircle_S)
    }
    //添加毒圈
    func drawPoisonCircle(lat: CLLocationDegrees, lon: CLLocationDegrees, radius: CLLocationDistance){
        self.game?.map?.mapView?.remove(self.PoisonCircle_B)
        self.PoisonCenter_B = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.PoisonCircle_B = BMKCircle(center: self.PoisonCenter_B!, radius: radius)
        self.game?.map?.mapView?.add(self.PoisonCircle_B)
    }
    //缩毒圈
    @objc func changePoisonCircle(){
        if self.poisonList.count > 0 && self.poisonNum <= self.poisonList.count{   //自动缩毒
            self.currSec = self.zoomDuration - self.PCountDown
        }else{   //非自动缩毒
            if isConnect {
                self.currSec = self.zoomDuration - self.PCountDown_1
            }else{
                self.currSec = self.zoomDuration - self.PCountDown_2
            }
        }
        self.zoomCount = Int(ceil(Double(self.zoomDuration/self.zoomSpeed)))
        for i in 0..<self.zoomCount {
            if (self.currSec < self.zoomSpeed * (i + 1)) {
                self.currZoomLevel = i + 1
                break
            }
        }
        self.PLevel = Double(self.currZoomLevel)/Double(self.zoomCount)
        self.PNewLat = (Double(self.sCenter[1])! - Double(self.bCenter[1])!)*self.PLevel! + Double(self.bCenter[1])!
        self.PNewLon = (Double(self.sCenter[0])! - Double(self.bCenter[0])!)*self.PLevel! + Double(self.bCenter[0])!
        self.PNewRadius = PoisonRadius_B! - (PoisonRadius_B! - PoisonRadius_S!)*self.PLevel!
        drawPoisonCircle(lat: self.PNewLat!, lon: self.PNewLon!, radius: self.PNewRadius!)
    }
    
    //毒圈扣血
    @objc func poisonHurt(){
        if isInside(Lat_1: self.MyLat ?? 0, Lon_1: self.MyLon ?? 0, Lat_2: self.PNewLat!, Lon_2: self.PNewLon!, radius: self.PNewRadius!) == false && self.MyInvincible == 0{  //在安全区外，并且非无敌状态
            self.lastString = "aaa"
            if self.MyBlood > 0 {
                if (self.MyBlood - self.PhurtNum) > 0 {
                    self.MyBlood -= self.PhurtNum
                }else{
                    self.MyBlood = 0
                }
            }else{
                if (self.MyDyingBlood - self.PhurtNum) > 0 {
                    self.MyDyingBlood -= self.PhurtNum
                }else{
                    self.MyDyingBlood = 0
                }
            }
            self.changeMystate()
            self.freshMydata()
        }
    }
    //计算是否在圈内
    func isInside(Lat_1: Double,Lon_1:Double,Lat_2: Double,Lon_2: Double,radius: CLLocationDistance) -> Bool{
        let location1 = CLLocation(latitude: Lat_1, longitude: Lon_1)
        let location2 = CLLocation(latitude: Lat_2, longitude: Lon_2)
        let distance = location1.distance(from: location2)
        var bool : Bool?
        if distance <= radius {
            bool = true
        }else{
            bool = false
        }
        return bool!
    }
    
    //获取物品表单
    @objc func getCategoryData(){
        Alamofire.request("http://\(Host!):8080/apps/getByCategory", method: .get, parameters: ["gameId": gameId!, "teamId": teamId!, "personId": personId!]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = CategoryModel.deserialize(from: jsonString) {
                        responseModel.data.forEach({ (model) in
                            self.CategoryDic[model.categoryId] = model
                        })
                    }
                }
            }
        }
    }
    
    //救援
    @objc func save(){
        if MyState == 1 {
            Alamofire.request("http://\(Host!):8080/apps/ResurrectionPerson", method: .get, parameters: ["gameId": gameId!, "personId": savePersonId!, "randang": Int(SaveNum)!]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        if let responseModel = MsgModel.deserialize(from: jsonString) {
                            if responseModel.respCode == "200" {
                                SVProgressHUD.showSuccess(withStatus: "\(String(describing: responseModel.msg))")
                            }else{
                                SVProgressHUD.showError(withStatus: "\(String(describing: responseModel.msg))")
                            }
                        }
                    }
                }
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "救援失败")
        }
    }
    //打开救援界面
    @objc func openSave(sender: UIButton){
        game?.SaveView?.cancel()
        savePersonId = MyTeamPersonId[sender.tag]
        if game?.SaveView?.isHidden == true{
            game?.SaveView?.isHidden = false
        }else{
            game?.SaveView?.isHidden = true
        }
    }
    //打开队伍界面
    @objc func openTeam(){
        if game?.TeamView?.isHidden == true{
            game?.TeamView?.isHidden = false
        }else{
            game?.TeamView?.isHidden = true
        }
    }
    //后台直接在背包内添加物品
    func addItem(send: String) {
        if let responseModel = ItemModel.deserialize(from: send) {
            responseModel.data?.list.forEach({(model) in
                if bagItemTotal < 10 {
                    if bagItemTotal + model.realcsEquipCategory!.img <= 10 {
                        if bagItemArray.count > 0 {
                            var flag = true
                            for i in 0..<bagItemArray.count {
                                if bagItemArray[i].categoryId == model.realcsEquipCategory?.categoryId {
                                    bagItemArray[i].img += model.realcsEquipCategory!.img
                                    bagItemTotal += model.realcsEquipCategory!.img
                                    flag = false
                                }
                            }
                            if flag == true {
                                bagItemArray.append(model.realcsEquipCategory!)
                                bagItemTotal += model.realcsEquipCategory!.img
                            }
                        }else{
                            bagItemArray.append(model.realcsEquipCategory!)
                            bagItemTotal += model.realcsEquipCategory!.img
                        }
                    }else if bagItemTotal + model.realcsEquipCategory!.img > 10 && bagItemTotal + model.realcsEquipCategory!.img < 13 {
                        for i in 0..<bagItemArray.count {
                            if bagItemArray[i].categoryId == model.realcsEquipCategory?.categoryId {
                                bagItemArray[i].img += 10 - bagItemTotal
                                bagItemTotal = 10
                                break
                            }else{
                                bagItemArray.append(model.realcsEquipCategory!)
                                bagItemArray[bagItemArray.count - 1].img = 10 - bagItemTotal
                                bagItemTotal = 10
                                break
                            }
                        }
                    }
                }
            })
            game?.bag?.bagTableView?.reloadData()
        }
    }
    //穿戴虚拟装备
    func wearVirtualEquip(equipId: Int,rowNo: Int,equipNo: String){
        Alamofire.request("http://\(Host!):8080/apps/addEquip", method: .get, parameters: ["gameId": gameId!, "personId": personId!, "airdropId": nearItemDropId[rowNo], "equipNos": equipNo]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = MsgModel.deserialize(from: jsonString) {
                        if responseModel.respCode == "200" {
                            self.Equip[equipId]?.catagoryId = self.CategoryDic[self.nearItemId[rowNo]]!.categoryId//记录装备id 通过id去查询具体是什么装备
                            self.Equip[equipId]?.realcsEquip?.equipNo = equipNo  //记录装备编号
                            self.changeEquip()
                            self.sendEquipData(send: (self.Equip[equipId]?.realcsEquip?.equipNo)!)
                        }else{
                            SVProgressHUD.showError(withStatus: "\(responseModel.msg!)")
                        }
                    }
                }
            }
        }
    }
    
    //更换装备
    func changeEquip(){
        if self.Equip.keys.contains(2) {   //主武器
            if let url = URL(string: (CategoryDic[self.Equip[2]!.catagoryId]?.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                self.game?.GunView?.kf.setImage(with: url)
            }
            if self.Equip[2]?.realcsEquip?.equipNo != self.gunNO{
//                playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                if self.gunNO != nil {
                    stringSpeak(voiceString: "更换武器")
                }
                self.gunNO = self.Equip[2]?.realcsEquip?.equipNo
            }
        } else {
            self.game?.GunView?.image = UIImage(named: "gun.png")
        }
        if self.Equip.keys.contains(9) {   //头盔
            if let url = URL(string: (CategoryDic[self.Equip[9]!.catagoryId]?.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                self.game?.HatView?.kf.setImage(with: url)
            }
            if self.Equip[9]?.realcsEquip?.equipNo != self.hatNO{
//                playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                if self.hatNO != nil {
                    stringSpeak(voiceString: "更换头盔")
                }
                self.hatNO = self.Equip[9]?.realcsEquip?.equipNo
            }
        } else {
            self.game?.HatView?.image = UIImage(named: "hat.png")
        }
        if self.Equip.keys.contains(8) {   //背心
            if let url = URL(string: (CategoryDic[self.Equip[8]!.catagoryId]?.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                self.game?.ClothesView?.kf.setImage(with: url)
            }
            if self.Equip[8]?.realcsEquip?.equipNo != self.clothesNO{
//                playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                if self.clothesNO != nil {
                    stringSpeak(voiceString: "更换背心")
                }
                self.clothesNO = self.Equip[8]?.realcsEquip?.equipNo
            }
        } else {
            self.game?.ClothesView?.image = UIImage(named: "clothes.png")
        }
    }
    
    //获得虚拟道具
    func getItem(send: Int){
        //1秒只能操作1次
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.isUserInteractionEnabled = true
        }
        if nearItemId.count > send {
            if CategoryDic[nearItemId[send]]?.equipType == 8{   //如果是背心
                let NoStr = nearItemNo[send].joined(separator: ",")
                if Equip.keys.contains(8) {   //如果已装备背心
                    self.wearVirtualEquip(equipId: 8, rowNo: send, equipNo: NoStr)
                }else{
                    SVProgressHUD.showError(withStatus: "未装备背心")
                }
            }else if CategoryDic[nearItemId[send]]?.equipType == 9{   //如果是头盔
                let NoStr = nearItemNo[send].joined(separator: ",")
                if Equip.keys.contains(9) {   //如果已装备头盔
                    self.wearVirtualEquip(equipId: 9, rowNo: send, equipNo: NoStr)
                }else{
                    SVProgressHUD.showError(withStatus: "未装备头盔")
                }
            }else if CategoryDic[nearItemId[send]]?.equipType == 2{   //如果是武器
                let NoStr = nearItemNo[send].joined(separator: ",")
                if Equip.keys.contains(2) {   //如果已装备武器
                    self.wearVirtualEquip(equipId: 2, rowNo: send, equipNo: NoStr)
                }else{
                    SVProgressHUD.showError(withStatus: "未装备武器")
                }
            }else{   //如果是其他道具
                if self.bagItemTotal < 10 {  //背包内道具数量小于10
                    if (self.bagItemTotal + self.nearItemNum[send]) <= 10 { //背包内道具数量加上拾取的道具数量小于等于10
                        let NoStr = nearItemNo[send].joined(separator: ",")
                        Alamofire.request("http://\(Host!):8080/apps/addEquip", method: .get, parameters: ["gameId": gameId!, "personId": personId!, "airdropId": nearItemDropId[send], "equipNos": NoStr]).responseString { (response) in
                            if let jsonString = response.result.value {
                                if let responseModel = MsgModel.deserialize(from: jsonString) {
                                    if responseModel.respCode == "200" {
                                        if self.bagItemArray.count > 0 {
                                            var flag = true
                                            for i in 0..<self.bagItemArray.count {
                                                if self.bagItemArray[i].categoryId == self.nearItemId[send] {
                                                    self.bagItemArray[i].img += self.nearItemNum[send]
                                                    self.bagItemTotal += self.nearItemNum[send]
                                                    flag = false
                                                }
                                            }
                                            if flag  == true {
                                                self.bagItemArray.append(EquipCategory())
                                                self.bagItemArray[self.bagItemArray.count-1].categoryId = self.nearItemId[send]
                                                self.bagItemArray[self.bagItemArray.count-1].img = self.nearItemNum[send]
                                                self.bagItemTotal += self.nearItemNum[send]
                                            }
                                        }else{
                                            self.bagItemArray.append(EquipCategory())
                                            self.bagItemArray[self.bagItemArray.count-1].categoryId = self.nearItemId[send]
                                            self.bagItemArray[self.bagItemArray.count-1].img = self.nearItemNum[send]
                                            self.bagItemTotal += self.nearItemNum[send]
                                        }
                                    }else{
                                        SVProgressHUD.showError(withStatus: "\(responseModel.msg!)")
                                    }
                                }
                            }
                        }
                    }else if (self.bagItemTotal + self.nearItemNum[send]) < 13 && (self.bagItemTotal + self.nearItemNum[send]) > 10{ //背包内道具数量加上拾取的道具数量大于10小于13
                        self.nearItemNo_2.removeAll()
                        for i in 0..<(10 - self.bagItemTotal) {
                            self.nearItemNo_2.append(self.nearItemNo[send][i])
                        }
                        let NoStr = nearItemNo_2.joined(separator: ",")
                        Alamofire.request("http://\(Host!):8080/apps/addEquip", method: .get, parameters: ["gameId": gameId!, "personId": personId!, "airdropId": nearItemDropId[send], "equipNos": NoStr]).responseString { (response) in
                            if response.result.isSuccess {
                                if let jsonString = response.result.value {
                                    if let responseModel = MsgModel.deserialize(from: jsonString) {
                                        if responseModel.respCode == "200" {
                                            if self.bagItemArray.count > 0 {
                                                var flag = true
                                                for i in 0..<self.bagItemArray.count {
                                                    if self.bagItemArray[i].categoryId == self.nearItemId[send] {
                                                        self.bagItemArray[i].img += (10 - self.bagItemTotal)
                                                        self.bagItemTotal = 10
                                                        flag = false
                                                    }
                                                }
                                                if flag  == true {
                                                    self.bagItemArray.append(EquipCategory())
                                                    self.bagItemArray[self.bagItemArray.count-1].categoryId = self.nearItemId[send]
                                                    self.bagItemArray[self.bagItemArray.count-1].img = (10 - self.bagItemTotal)
                                                    self.bagItemTotal = 10
                                                }
                                            }else{
                                                self.bagItemArray.append(EquipCategory())
                                                self.bagItemArray[self.bagItemArray.count-1].categoryId = self.nearItemId[send]
                                                self.bagItemArray[self.bagItemArray.count-1].img = (10 - self.bagItemTotal)
                                                self.bagItemTotal = 10
                                            }
                                        }else{
                                            SVProgressHUD.showError(withStatus: "\(responseModel.msg!)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "背包已满")
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "操作失败")
        }
    }
    //丢弃道具
    @objc func dropItem(){
        //操作太快会导致selectRow > numberOfRows-1 报错
        if (game?.bag?.bagTableView?.numberOfRows(inSection: 0))!-1 >= ItemRow! && bagItemArray.count > 0 {
            bagItemTotal -= bagItemArray[ItemRow!].img
            bagItemArray.remove(at: ItemRow!)
            game?.bag?.bagTableView?.reloadData()
            hiddenOperation()
        } else {
            SVProgressHUD.showError(withStatus: "操作失败")
        }
    }
    //使用道具
    @objc func useItem(){
        if (game?.bag?.bagTableView?.numberOfRows(inSection: 0))!-1 >= ItemRow! && bagItemArray.count > 0 {
            if isChangeblood() == true {
                changeBlood()
                if (bagItemArray[ItemRow!].img - 1) > 0 {
                    bagItemArray[ItemRow!].img -= 1
                }else{
                    bagItemArray.remove(at: ItemRow!)
                }
                bagItemTotal -= 1
                game?.bag?.bagTableView?.reloadData()
                hiddenOperation()
            }else{
                SVProgressHUD.showError(withStatus: "人物血量大于75")
            }
        } else {
            SVProgressHUD.showError(withStatus: "操作失败")
        }
    }
    //治疗道具加血判断
    func isChangeblood() -> Bool{
        var bool : Bool?
        if CategoryDic[bagItemArray[ItemRow!].categoryId]?.persistenceTreat == 2 {  //非持续治疗
            if MyBlood > 0 && MyBlood < 75 {
                bool = true
            }else{
                bool = false
            }
        }else{
            bool = true
        }
        return bool!
    }
    
    //治疗道具加血方法
    func changeBlood(){
        if CategoryDic[bagItemArray[ItemRow!].categoryId]?.persistenceTreat == 1 {  //持续治疗
            changebloodNum += CategoryDic[bagItemArray[ItemRow!].categoryId]!.treatBlood
            if bloodTimer == nil {
                bloodTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(continuedChangeBlood), userInfo: nil, repeats: true)
                bloodTimer?.fire()
            }
        }else{
            if (MyBlood + CategoryDic[bagItemArray[ItemRow!].categoryId]!.treatBlood) > 75 {  //非持续治疗上限75
                healNum += (75 - MyBlood)
                MyBlood = 75
            }else{
                MyBlood += CategoryDic[bagItemArray[ItemRow!].categoryId]!.treatBlood
                healNum += CategoryDic[bagItemArray[ItemRow!].categoryId]!.treatBlood
            }
        }
    }
    //持续加血方法
    @objc func continuedChangeBlood(){
        if changebloodNum > 0 && MyBlood > 0{
            if MyBlood < 100 {
                MyBlood += 1
                healNum += 1
            }
            changebloodNum -= 1
        }else{
            changebloodNum = 0
            if bloodTimer != nil {
                bloodTimer?.invalidate()
                bloodTimer = nil
            }
        }
    }
    
    //关闭物品操作提示界面
    @objc func hiddenOperation(){
        game?.operation?.isHidden = true
    }
    //加减血量与护甲
    func bloodAnddefance(send: String){
        if let responseModel = MsgModel.deserialize(from: send) {
            switch responseModel.flag {
            case "复活":
                MyBlood = 100
                MyDyingBlood = 100
                changeMystate()
            case "加血":
                if MyBlood < 0 {
                    MyDyingBlood = 100
                }
                MyBlood = MyBlood + responseModel.data!.blood < 100 ? MyBlood + responseModel.data!.blood : 100
                changeMystate()
            case "掉血":
                if MyInvincible == 0 {  //非无敌状态
                    if MyBlood > 0 {
                        MyBlood = MyBlood - responseModel.data!.blood > 0 ? MyBlood - responseModel.data!.blood : 0
                    }else{
                        MyDyingBlood = MyDyingBlood - responseModel.data!.blood > 0 ? MyDyingBlood - responseModel.data!.blood : 0
                    }
                    changeMystate()
                }
            case "加头盔护甲":
                if self.Equip.keys.contains(9) {
                    MyArmor = MyArmor + responseModel.data!.defence < 100 ? MyArmor + responseModel.data!.defence : 100
                }
            case "减头盔护甲":
                if self.Equip.keys.contains(9) {
                    MyArmor = MyArmor - responseModel.data!.defence > 0 ? MyArmor - responseModel.data!.defence : 0
                }
            case "加背心护甲":
                if self.Equip.keys.contains(8) {
                    MyArmor = MyArmor + responseModel.data!.defence < 100 ? MyArmor + responseModel.data!.defence : 100
                }
            case "减背心护甲":
                if self.Equip.keys.contains(8) {
                    MyArmor = MyArmor - responseModel.data!.defence > 0 ? MyArmor - responseModel.data!.defence : 0
                }
            default:
                break
            }
        }
    }
    //创建聊天屏道自动隐藏定时器
    func talkcloseOpen(){
        if talkTimer == nil{
            talkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(talkclose), userInfo: nil, repeats: true)
            talkTimer?.fire()
        }
    }
    //聊天屏道自动隐藏方法
    @objc func talkclose(){
        if talknum > 0{
            game?.talk?.isHidden = false
            talknum -= 1
        }else{
            talkTimer?.invalidate()
            talkTimer = nil
            talknum = 10
            game?.talk?.isHidden = true
        }
    }
    //打开背包
    @objc func openbag() {
        if game?.bag?.isHidden == true{
            game?.bag?.isHidden = false
        }else{
            game?.bag?.isHidden = true
        }
    }
    //创建getData定时器
    func startgetData(){
        if getDataTimer == nil {
            //每秒获取数据
            getDataTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
            getDataTimer?.fire()
        }
    }
    
    //轮询获取数据
    @objc func getData(){
        Alamofire.request("http://\(Host!):8080/apps/getAppData", method: .get, parameters: ["gameId": gameId!, "teamId": teamId!, "personId": personId!]).responseString { (response) in
            if response.result.isSuccess {
                self.isSuccess = true
                if self.disconnectTimer != nil {
                    self.disconnectTimer?.invalidate()
                    self.disconnectTimer = nil
                }
                self.game?.InternetLabel?.isHidden = true
                self.game?.GameStatus?.isHidden = false
                if let jsonString = response.result.value {
//                    print(jsonString)
                    self.MyTeamName.removeAll()
                    self.MyTeamIcon.removeAll()
                    self.MyTeamBlood.removeAll()
                    self.MyTeamDyingBlood.removeAll()
                    self.MyTeamArmor.removeAll()
                    self.MyTeamState.removeAll()
                    self.MyTeamKill.removeAll()
                    self.MyTeamDamage.removeAll()
                    self.TeamState.removeAll()
                    self.TeamDamage.removeAll()
                    self.TeamKill.removeAll()
                    self.TeamSurvival.removeAll()
                    self.TeamDead.removeAll()
                    self.Equip.removeAll()
                    self.IconArray.removeAll()
                    self.LatArray.removeAll()
                    self.LonArray.removeAll()
                    self.game?.map?.mapView?.removeAnnotations(self.annotationArray)
                    self.annotationArray.removeAll()
                    self.game?.map?.mapView?.removeAnnotations(self.airdropArray)
                    self.airdropArray.removeAll()
                    self.nearItemNum.removeAll()
                    self.nearItemNo.removeAll()
                    self.nearItemId.removeAll()
                    self.nearItemDropId.removeAll()
                    if let responseModel = GpsModel.deserialize(from: jsonString) {
                        if jsonString != "{}" {
                            if responseModel.data?.status == 6 {
                                self.game?.GameStatus?.text = "游戏准备中"
                            }
                            else if responseModel.data?.status == 3 {
                                self.gameRule = responseModel.data?.gameRule
                                if self.gameRule == 1 {
                                    self.game?.GameStatus?.text = "绝地求生"
                                    let attributeString = NSMutableAttributedString(string: "剩余人数:"+"\(responseModel.data!.total)"+"/\(responseModel.data!.totalNum)")
                                    let range: NSRange = (attributeString.string as NSString).range(of:"\(responseModel.data!.total)")
                                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                                    self.game?.TotalNum?.attributedText = attributeString
                                    self.game?.TotalNum?.isHidden = false
                                    self.game?.gameKillNum?.isHidden = true
                                    self.game?.gameCountDown?.isHidden = true
                                }else if self.gameRule == 2 {
                                    self.game?.GameStatus?.text = "王者吃鸡"
                                    self.game?.TotalNum?.isHidden = true
                                    if responseModel.data!.gameKillNum != 0 {
                                        let attributeString = NSMutableAttributedString(string: "最高击杀数:"+"\(responseModel.data!.killNum)"+"/\(responseModel.data!.gameKillNum)")
                                        let range: NSRange = (attributeString.string as NSString).range(of:"\(responseModel.data!.killNum)")
                                        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                                        self.game?.gameKillNum?.attributedText = attributeString
                                        self.game?.gameKillNum?.isHidden = false
                                    }else{
                                        self.game?.gameKillNum?.isHidden = true
                                    }
                                    if responseModel.data!.gameDuration != 0 {
                                        self.gameCountDown = responseModel.data!.duration
                                        self.changeGameCountDown()
                                        self.game?.gameCountDown?.isHidden = false
                                        self.game?.gameKillNum?.frame.origin.y = 30
                                    }else{
                                        self.game?.gameCountDown?.isHidden = true
                                        self.game?.gameKillNum?.frame.origin.y = 10
                                    }
                                }
                            }
                            else if responseModel.data?.status == 2 {
                                self.game?.GameStatus?.text = "游戏已结束"
                            }
                            else if responseModel.data?.status == 5 {
                                self.game?.GameStatus?.text = "游戏未开始"
                            }
                            if responseModel.data?.airdropEntityList != nil && responseModel.data?.airdropEntityList.count != 0{  //空投和物资
                                self.airdrop = responseModel.data?.airdropEntityList
                                for j in 0..<self.airdrop!.count {
                                    self.j = j
                                    self.airdropArray.append(BMKPointAnnotation())
                                    self.airdropCenter = (self.airdrop![j].center.components(separatedBy: ","))
                                    self.airdropArray[j].coordinate = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.airdropCenter[1]))!, longitude: (CLLocationDegrees(self.airdropCenter[0]))!)
                                    self.game?.map?.mapView?.addAnnotation(self.airdropArray[j])
                                }
                            }
                            if responseModel.data?.realcsGameCircleBomb != nil {   //轰炸区
                                self.BombState = responseModel.data!.realcsGameCircleBomb!.status
                                self.BCountDown_1 = responseModel.data!.realcsGameCircleBomb!.countDown
                                self.BCountDown_2 = responseModel.data!.realcsGameCircleBomb!.durationTime
                                self.BhurtTime = responseModel.data!.realcsGameCircleBomb!.hurtTime
                                self.BhurtNum = responseModel.data!.realcsGameCircleBomb!.hurtNum
                                self.bombCenter = (responseModel.data?.realcsGameCircleBomb!.center.components(separatedBy: ","))!
                                self.BombRadius = CLLocationDistance(responseModel.data!.realcsGameCircleBomb!.radius)
                                self.createBomb()
                            }
                            if responseModel.data?.realcsGameCirclePoison != nil{  //毒区
                                self.PCountDown_1 = responseModel.data!.realcsGameCirclePoison!.countDown
                                self.PCountDown_2 = responseModel.data!.realcsGameCirclePoison!.zoomDuration
                                self.zoomDuration = responseModel.data!.realcsGameCirclePoison!.zoomDuration
                                self.zoomSpeed = responseModel.data!.realcsGameCirclePoison!.zoomSpeed
                                self.PhurtNum = responseModel.data!.realcsGameCirclePoison!.hurtNum
                                self.bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                                self.sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                                self.PoisonRadius_B = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.radius)
                                self.PoisonRadius_S = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.safetyRadius)
                                self.PoisonState = responseModel.data!.realcsGameCirclePoison!.status
                                if responseModel.data?.autoMode == true {  //判断如果是自动缩毒，当前毒圈是第几个毒圈
                                    for i in 0..<self.poisonList.count {
                                        if self.poisonList[i].safetyRadius == Int(self.PoisonRadius_S!) {
                                            self.poisonNum = i
                                        }
                                    }
                                }else{
                                    self.removePoison()   //移除毒圈
                                    self.poisonList.removeAll()  //清空毒圈集合
                                }
                                self.createPoison()
                            }else{
                                self.game?.map?.mapView?.remove(self.PoisonCircle_B)
                                self.game?.map?.mapView?.remove(self.PoisonCircle_S)
                                self.game?.Poisontitle?.removeFromSuperview()
                                self.game?.map?.mapView?.removeAnnotation(self.PoisonAnnotation)
                                if self.Ptimer_1 != nil{
                                    self.Ptimer_1?.invalidate()  //销毁定时器
                                    self.Ptimer_1 = nil
                                }
                                if self.Ptimer_2 != nil{
                                    self.Ptimer_2?.invalidate()  //销毁定时器
                                    self.Ptimer_2 = nil
                                }
                                if self.Ptimer_3 != nil{
                                    self.Ptimer_3?.invalidate()  //销毁定时器
                                    self.Ptimer_3 = nil
                                }
                            }
                            if responseModel.data?.gpsEntityList != nil && responseModel.data!.gpsEntityList.count != 0{
                                responseModel.data?.gpsEntityList.forEach({ (model_1) in
                                    if model_1.personId != personId{  //队友gps
                                        self.MyTeamName.append(model_1.personName)
                                        self.MyTeamIcon.append(model_1.realcsUpload!.accesslocation)
                                        self.MyTeamBlood.append(model_1.blood)
                                        self.MyTeamDyingBlood.append(model_1.dyingBlood)
                                        self.MyTeamArmor.append(model_1.defence)
                                        self.MyTeamState.append(model_1.status)
                                        self.MyTeamKill.append(model_1.killNum)
                                        self.MyTeamDamage.append(model_1.damage)
                                        if model_1.phoneStatus == 1{
                                            self.IconArray.append(model_1.realcsUpload!.accesslocation)
                                            self.LatArray.append(model_1.lat)
                                            self.LonArray.append(model_1.lon)
                                        }
                                    }
                                    if model_1.personId == personId{  //自己
                                        if model_1.airdropEntityList != nil && model_1.airdropEntityList.count != 0 {  //附近物品
                                            model_1.airdropEntityList.forEach({(model_2) in
                                                model_2.airdropEquipList.forEach({(model_3) in
                                                    self.nearItemNum.append(model_3.equipNo.count)
                                                    self.nearItemDropId.append(model_2.airdropId)
                                                    self.nearItemNo.append(model_3.equipNo)
                                                    self.nearItemId.append(Int(model_3.equipName)!)
                                                })
                                            })
                                        }
                                        self.MyIcon = model_1.realcsUpload!.accesslocation
                                        self.MyName = model_1.personName
                                        self.game?.dyingLabel?.text = "\(model_1.randang)"   //救援密钥
                                        self.MyPackageState = model_1.connectStatus
                                        self.MyShield = model_1.shieldFlag
                                        self.MyInvincible = model_1.invincible
                                        self.MyBanGun = model_1.banGun
                                        self.freshMydata()
                                    }
                                    self.TeamState.append(model_1.status)
                                })
                                self.freshTeamData()
                                self.game?.bag?.nearTableView?.reloadData()
                                self.game?.bag?.bagTableView?.reloadData()
                                if self.gameRule == 1 {
                                    if !self.TeamState.contains(1) && !self.TeamState.contains(3) && responseModel.data?.status == 3 { //只包含2（死亡）
                                        self.game?.results?.isHidden = false
                                        if self.game?.results?.battleResultsView?.isHidden == true {
                                            self.game?.results?.ResultsView?.isHidden = false
                                        }else{
                                            self.game?.results?.ResultsView?.isHidden = true
                                        }
                                        self.results_stats = 1
                                        self.getResults()
                                    }else{
                                        self.game?.results?.isHidden = true
                                    }
                                }
                            }
                            //添加暴露人员
                            if responseModel.data?.exposePersonList != nil && responseModel.data?.exposePersonList.count != 0{
                                responseModel.data?.exposePersonList.forEach({(model_2) in
                                    if model_2.phoneStatus == 1{
                                        self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                        self.LatArray.append(model_2.lat)
                                        self.LonArray.append(model_2.lon)
                                    }
                                })
                            }
                            //添加队友及暴露人员定位
                            for i in 0..<self.IconArray.count {
                                self.i = i
                                self.annotationArray.append(BMKPointAnnotation())
                                self.annotationArray[i].coordinate = CLLocationCoordinate2DMake(self.LatArray[i],self.LonArray[i])
                                self.game?.map?.mapView?.addAnnotation(self.annotationArray[i])
                            }
                        }
                    }
                }
            }else{
                self.isSuccess = false
                self.game?.InternetLabel?.isHidden = false
                self.game?.GameStatus?.isHidden = true
                if self.disconnectTimer == nil {
                    self.disconnectTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.disconnectAction), userInfo: nil, repeats: true)
                }
            }
        }
    }
    //更新team数据
    func freshTeamData(){
        if TeamdataSources.count > 0 {
            for i in 0..<TeamdataSources.count {
                TeamdataSources[i].TeamName = MyTeamName[i]
                TeamdataSources[i].TeamIcon = MyTeamIcon[i]
                TeamdataSources[i].TeamBlood = MyTeamBlood[i]
                TeamdataSources[i].TeamDyingBlood = MyTeamDyingBlood[i]
                TeamdataSources[i].TeamArmor = MyTeamArmor[i]
                TeamdataSources[i].TeamState = MyTeamState[i]
                TeamdataSources[i].TeamKill = MyTeamKill[i]
                TeamdataSources[i].TeamDamage = MyTeamDamage[i]
                TeamdataSources[i].myState = MyState
            }
        }
    }
    //更新我的数据
    func freshMydata(){
        if isContinue == true {
            if !websocket!.isConnected {
                websocket?.connect()
            }
        }
        if MyBlood < LastBlood {  //掉血动画
            game?.dyingImage?.isHidden = false
        }else{
            game?.dyingImage?.isHidden = true
        }
        LastBlood = MyBlood
        MydataSources.MyName = MyName
        MydataSources.MyBlood = MyBlood
        MydataSources.MyDyingBlood = MyDyingBlood
        MydataSources.MyArmor = MyArmor
        MydataSources.MyIcon = MyIcon
        MydataSources.MyState = MyState
        MydataSources.MyPackageState = MyPackageState
        MydataSources.MyShield = MyShield
        MybagdataSources.MyName = MyName
        MybagdataSources.MyBlood = MyBlood
        MybagdataSources.MyArmor = MyArmor
        MybagdataSources.MyKill = MyKill
        MybagdataSources.MyDamage = MyDamage
        MybagdataSources.MyIcon = MyIcon
        myState(sender: MyState)
        packageState(sender: MyPackageState)
        isshield(sender: MyShield)
        sendBagArray.removeAll()
        if bagItemArray.count > 0 {
            bagItemArray.forEach({(model) in
                sendBagArray.append(sendModel())
                sendBagArray[sendBagArray.count-1].realcsEquipCategory.categoryId = model.categoryId
                sendBagArray[sendBagArray.count-1].realcsEquipCategory.img = model.img
            })
        }
        //我的状态
        phoneState = "{\"ACTION\":\"phone-state\",\"DATA\":{\"GAME_ID\":\(gameId!),\"PERSON_ID\":\(personId!),\"blood\":\(MyBlood),\"tkDefence\":\(Equip[9]?.defence ?? 0),\"bxDefence\":\(Equip[8]?.defence ?? 0),\"dyingBlood\":\(MyDyingBlood),\"knapsack\":\(sendBagArray.toJSONString()!),\"status\":\(MyState),\"last\":\"\(lastString)\",\"heal\":\"\(healNum)\"},\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\"}\r\n"
        phoneStatejsonData = phoneState.data(using: String.Encoding.utf8, allowLossyConversion: false)
        //发送我的状态
        if phoneStateTimer == nil {
            phoneStateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendphoneState), userInfo: nil, repeats: true)
            phoneStateTimer?.fire()
        }
    }
    //获取结算
    func getResults(){
        Alamofire.request("http://\(Host!):8080/apps/getPersonByRecord", method: .get, parameters: ["gameId": gameId!, "teamId": teamId!, "stats": results_stats!]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
//                    print(jsonString)
                    if let responseModel = ResultsModel.deserialize(from: jsonString) {
                        if responseModel.data != nil {
                            self.TeamDamage.removeAll()
                            self.TeamKill.removeAll()
                            self.TeamSurvival.removeAll()
                            self.TeamDead.removeAll()
                            responseModel.data?.recordList?.forEach({(model) in
                                self.TeamDamage.append(model.damage)
                                self.TeamKill.append(model.killNum)
                                self.TeamSurvival.append(model.survivalTime)
                                self.TeamDead.append(model.dieNum)
                                if model.personId == personId {
                                    self.TeamRank = model.ranking
                                }
                            })
                            self.game?.results?.rank?.text = "第\(self.TeamRank!)名"
                            if self.TeamRank == 1 {
                                self.game?.results?.battleResultsView?.image = UIImage(named: "zhanbao_2.png")
                            }else{
                                self.game?.results?.battleResultsView?.image = UIImage(named: "zhanbao_1.png")
                            }
                            self.game?.results?.ResultsView?.isHidden = true
                            if self.gameRule == 1 {
                                self.game?.results?.survival?.isHidden = false
                                self.game?.results?.dead?.isHidden = true
                            }else if self.gameRule == 2 {
                                self.game?.results?.survival?.isHidden = true
                                self.game?.results?.dead?.isHidden = false
                            }
                            self.game?.results?.teamResultsTableView?.reloadData()
                            self.game?.results?.battleResultsView?.isHidden = false
                            self.game?.results?.ResultsView?.isHidden = true
                        } else {
                            if let responseModel = MsgModel.deserialize(from: jsonString) {
                                if responseModel.respCode == "100001" {
                                    SVProgressHUD.showError(withStatus: "\(String(describing: responseModel.msg))")
                                }
                            }
                        }
                    }
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @objc func heart(){
        clientSocket?.write(heartjsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendphoneState(){
        clientSocket?.write(phoneStatejsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendgps(){
        clientSocket?.write(gpsjsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendmsg(){
        clientSocket?.write(msgjsonData!, withTimeout: -1, tag: 0)
    }
    
    func sendEquipData(send: String) {
        self.equipjsonString = "{\"ACTION\":\"phone-pickupEquip\",\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\",\"DATA\":{\"GAME_ID\":\(gameId!),\"PERSON_ID\":\"\(personId!)\",\"DEVICE_ID\":\(send)}}\r\n"
        self.equipjsonData = self.equipjsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        clientSocket?.write(equipjsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func noti(n: Notification) {
        if game?.talkbtn?.SelectBtn?.tag == 0 || game?.talkbtn?.SelectBtn?.tag == 2{
            teamorworld = "team"
        }else if game?.talkbtn?.SelectBtn?.tag == 1{
            teamorworld = "world"
        }
        let name = n.object as! String
        if url != nil {  //判断是否有语音的路径
            if endState == 1 {  //判断是否需要发送
                Alamofire.upload(multipartFormData: {(Formdata) in
                    Formdata.append(self.url!, withName: "file", fileName: name, mimeType: "caf")
                }, to: "http://\(Host!):8998/voice/uploadVoice", encodingCompletion: {(encodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            let str = String(data:response.data!, encoding: String.Encoding.utf8)!
                            if let responseModel = flagModel.deserialize(from: str){
                                self.caf = responseModel.data
                                self.cafstr = "{\"ACTION\":\"phone-send-msg\",\"DATA\":{\"PERSON_NAME\":\"\(self.MyName)\",\"MSG_TYPE\":\"MSG_VOICE\",\"MSG_VOICE\":\"\(self.caf!)\",\"GAME_ID\":\(gameId!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(teamId!),\"MSG_CHANNEL\":\"\(self.teamorworld!)\"},\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\"}\r\n"
                                self.msgjsonData = self.cafstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
                                self.sendmsg()
                            }
                        })
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }else{
            SVProgressHUD.showError(withStatus: "发送失败")
        }
    }

    func startTime(){
        game?.StartLabel?.isHidden = false
        startgameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startgameTimer?.fire()
    }
    
    @objc func updateTime(){
        if num >= 1{
            game?.StartLabel?.text = "游戏将在\(num)秒后开始"
            num -= 1
        }else{
            if startgameTimer != nil {
                startgameTimer!.invalidate()
                startgameTimer = nil
            }
            game?.StartLabel?.isHidden = true
            num = 5
        }
    }
    
    @objc func msgchange(sender: UIButton){
        if  game?.talkbtn?.SelectBtn?.isSelected == true{
            game?.talkbtn?.SelectBtn?.isSelected = false
        }
        sender.isSelected = true
        game?.talkbtn?.SelectBtn = sender
        game?.talk?.ScrollView?.contentOffset.x = CGFloat(sender.tag) * 150
        if sender.tag == 0{
            game?.talkbtn?.NewTip1?.isHidden = true
        }else if sender.tag == 1{
            game?.talkbtn?.NewTip2?.isHidden = true
        }else if sender.tag == 2{
            game?.talkbtn?.NewTip3?.isHidden = true
        }
        talknum = 10
        talkcloseOpen()
    }
    
    func msgchange2(sender: Int){
        if sender == 0{
            game?.talkbtn?.Button1?.isSelected = true
            game?.talkbtn?.Button2?.isSelected = false
            game?.talkbtn?.Button3?.isSelected = false
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button1
        }else if sender == 1{
            game?.talkbtn?.Button1?.isSelected = false
            game?.talkbtn?.Button2?.isSelected = true
            game?.talkbtn?.Button3?.isSelected = false
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button2
        }else if sender == 2{
            game?.talkbtn?.Button1?.isSelected = false
            game?.talkbtn?.Button2?.isSelected = false
            game?.talkbtn?.Button3?.isSelected = true
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button3
        }
        game?.talk?.ScrollView?.contentOffset.x = CGFloat(sender * 150)
    }
    //干扰状态
    func isshield(sender: Int){
        if sender != 1{
            game?.shieldView?.isHidden = true
        } else {
            game?.shieldView?.isHidden = false
        }
    }
    //改变我的状态
    func changeMystate(){
        if MyBlood > 0 {
            MyState = 1
        }else if MyBlood == 0 && MyDyingBlood > 0 {
            MyState = 3
        }else if MyBlood == 0 && MyDyingBlood == 0 {
            MyState = 2
        }
        myState(sender: MyState)
    }
    
    //我的状态
    func myState(sender: Int){
        if sender == 1 {  //正常
            game?.deadImage?.isHidden = true
            game?.my?.Blood?.isHidden = false
            game?.my?.Blood_2?.isHidden = false
            game?.my?.DyingBlood?.isHidden = true
            game?.my?.DyingBlood_2?.isHidden = true
            game?.dyingView?.isHidden = true
            if DyingTimer != nil {
                DyingTimer?.invalidate()
                DyingTimer = nil
            }
            MyDyingBlood = 100
        }else if sender == 2 {  //死亡
            game?.deadImage?.isHidden = false
            game?.dyingView?.isHidden = true
            game?.dyingImage?.isHidden = true
            if DyingTimer != nil {
                DyingTimer?.invalidate()
                DyingTimer = nil
            }
            if gameRule == 2 {  //如果是王者吃鸡模式，3秒后自动复活
                if rebornTimer == nil {
                    rebornTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Reborn), userInfo: nil, repeats: true)
                    rebornTimer?.fire()
                }
            }
        }else if sender == 3 {  //濒死
            game?.deadImage?.isHidden = true
            game?.my?.Blood?.isHidden = true
            game?.my?.Blood_2?.isHidden = true
            game?.my?.DyingBlood?.isHidden = false
            game?.my?.DyingBlood_2?.isHidden = false
            game?.dyingView?.isHidden = false
            game?.dyingImage?.isHidden = false
            if DyingTimer == nil {
                DyingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Dyinghurt), userInfo: nil, repeats: true)
                DyingTimer?.fire()
            }
        }
    }
    //复活
    @objc func Reborn(){
        rebornNum -= 1
        if rebornNum == 0 {
            rebornNum = 4
            MyBlood = 100
            self.changeMystate()
            self.freshMydata()
            if rebornTimer != nil {
                rebornTimer?.invalidate()
                rebornTimer = nil
            }
        }
    }
    
    //濒死掉血
    @objc func Dyinghurt(){
        if (MyDyingBlood - 5) > 0 {
            MyDyingBlood -= 5
        }else{
            MyDyingBlood = 0
        }
        changeMystate()
    }
    
    //腰包状态
    func packageState(sender: Int){
        if sender == 1{
            game?.PackageView?.isHidden = true
        } else {
            game?.PackageView?.isHidden = false
        }
    }
    //webscoket相关协议
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket连接成功")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = true
            self.game?.GameStatus?.isHidden = false
        }
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("连接失败:\(String(describing: error))")
        print("websocket连接失败")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = false
            self.game?.GameStatus?.isHidden = true
        }
        if isContinue == true {
            if !websocket!.isConnected {
                websocket?.connect()
            }
        }
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("接收消息:\(text)")
        if let responseModel = flagModel.deserialize(from: text) {
            if responseModel.flag == nil {
                startgetData()
                MyTeamName.removeAll()
                MyTeamIcon.removeAll()
                MyTeamBlood.removeAll()
                MyTeamDyingBlood.removeAll()
                MyTeamArmor.removeAll()
                MyTeamState.removeAll()
                MyTeamPersonId.removeAll()
                TeamName.removeAll()
                TeamIcon.removeAll()
                Equip.removeAll()
                bagItemArray.removeAll()
                TeamdataSources.removeAll()
                if let responseModel = firstModel.deserialize(from: text) {
                    if responseModel.data?.status == 6 {
                        game?.GameStatus?.text = "游戏准备中"
                    }
                    else if responseModel.data?.status == 3 {
                        game?.GameStatus?.text = "游戏进行中"
                    }
                    else if responseModel.data?.status == 2 {
                        game?.GameStatus?.text = "游戏已结束"
                    }
                    else if responseModel.data?.status == 5 {
                        game?.GameStatus?.text = "游戏未开始"
                    }
                    self.poisonList = responseModel.data!.realcsGameCirclePoisonList
                    if responseModel.data?.realcsGameMap?.mapPath != nil {
                        mapPath = responseModel.data?.realcsGameMap?.mapPath
                        //瓦片
//                        syncTile.maxZoom = 21
//                        syncTile.minZoom = 16
                        game?.map?.mapView?.add(syncTile)
                    }
                    if responseModel.data?.realcsGameMap?.centerLat != nil && responseModel.data?.realcsGameMap?.centerLon != nil {
                        centerLat = responseModel.data?.realcsGameMap?.centerLat
                        centerLon = responseModel.data?.realcsGameMap?.centerLon
                        center = CLLocationCoordinate2D(latitude: centerLat!, longitude: centerLon!)
                        //设置地图的显示范围（越小越精确）
                        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        //设置地图最终显示区域
                        let region = BMKCoordinateRegion(center: center!, span: span)
                        game?.map?.mapView?.region = region
                        //设置显示天气状况
                        getWeather()
                    }
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            if model_1.teamId == teamId{
                                model_1.realcsGamePersonList.forEach({ (model_2) in
                                    self.TeamIcon.append(model_2.realcsUpload!.accesslocation)
                                    self.TeamName.append(model_2.personName)
                                    if model_2.personId != personId{  //队友
                                        self.MyTeamName.append(model_2.personName)
                                        self.MyTeamIcon.append(model_2.realcsUpload!.accesslocation)
                                        self.MyTeamPersonId.append(model_2.personId)
                                        self.MyTeamBlood.append(model_2.blood)
                                        self.MyTeamDyingBlood.append(model_2.dyingBlood)
                                        self.MyTeamArmor.append(model_2.defence)
                                        self.MyTeamState.append(model_2.status)
                                    }
                                    if model_2.personId == personId{  //自己
                                        self.MyName = model_2.personName
                                        self.healNum = model_2.heal
                                        self.MyBlood = model_2.blood
                                        self.LastBlood = self.MyBlood
                                        self.MyDyingBlood = model_2.dyingBlood
                                        self.MyArmor = model_2.defence
                                        self.MyIcon = model_2.realcsUpload!.accesslocation
                                        self.MyKill = model_2.killNum
                                        self.MyDamage = model_2.damage
                                        self.MyState = model_2.status
                                        self.MyShield = model_2.shieldFlag
                                        self.MyPackageState = model_2.connectStatus
                                        if model_2.knapsack != nil {
                                            self.bagItemString = model_2.knapsack.trimmingCharacters(in: CharacterSet(charactersIn: "\\")) //去除反斜杠"\"
                                            if let responseModel = [Itemlist].deserialize(from: self.bagItemString) {
                                                responseModel.forEach({(model) in
                                                    self.bagItemArray.append(model!.realcsEquipCategory!)
                                                })
                                                self.bagItemArray.forEach({(model) in
                                                    self.bagItemTotal += model.img
                                                })
                                            }
                                        }
                                        if model_2.realcsGamePersonEquipList != nil {
                                            model_2.realcsGamePersonEquipList.forEach({ (model_3) in
                                                self.Equip[model_3.catagoryId] = model_3
                                            })
                                            self.changeEquip()
                                        }
                                        self.freshMydata()
                                    }
                                })
                            }
                            MyTeamName.forEach({_ in
                                let model = TeamModel.init()
                                TeamdataSources.append(model)
                            })
                            if MyTeamName.count > 3 {
                                self.game?.TeamTableView?.isHidden = true
                                self.game?.TeamButton?.isHidden = false
                                self.game?.TeamCollectionView?.reloadData()
                            }else{
                                self.game?.TeamTableView?.reloadData()
                            }
                        })
                    }
                }
            }
            else if responseModel.flag == "开始游戏"{
                SVProgressHUD.dismiss()
                startgetData()
                startTime()
                game?.GameStatus?.text = "游戏进行中"
                //重新上传头像
                Alamofire.request("http://\(Host!):8080/apps/getHeadimgurl", method: .get, parameters: ["gameId": gameId!, "personId": personId!, "headimgurl": headImgUrl, "nickname": nickName])
                self.freshMydata()
            }
            else if responseModel.flag == "战报" {
                if self.game?.talkbtn?.SelectBtn?.tag != 2{
                    self.game?.talkbtn?.NewTip3?.isHidden = false
                }
                ReportArray.append(responseModel.data)
                game?.talk?.TableView3?.reloadData()
                msgchange2(sender: 2)
                talknum = 10
                talkcloseOpen()
            }
            else if responseModel.flag == "重载游戏" {
                game?.GameStatus?.text = "游戏未开始"
                gameInit()
                self.game?.results?.isHidden = true
            }
            else if responseModel.flag == "准备游戏" {
                startgetData()
                game?.GameStatus?.text = "游戏准备中"
            }
            else if responseModel.flag == "游戏结束" {
                game?.GameStatus?.text = "游戏已结束"
                SVProgressHUD.showInfo(withStatus: "游戏结束")
                self.game?.results?.isHidden = false
                self.game?.results?.battleResultsView?.isHidden = true
                self.game?.results?.ResultsView?.isHidden = false
                self.results_stats = 2
                self.getResults()
            }
//            else if responseModel.flag == "创建毒圈" {
//                self.createPoison(send: text)
//            }
//            else if responseModel.flag == "创建轰炸区" {
//                self.createBomb(send: text)
//            }
            else if responseModel.flag == "物资" {
                if bagItemTotal < 10 {
                    self.addItem(send: text)
                }
            }
            else if responseModel.flag == "复活" || responseModel.flag == "加血" || responseModel.flag == "掉血" || responseModel.flag == "加头盔护甲" || responseModel.flag == "掉头盔护甲" || responseModel.flag == "加背心护甲" || responseModel.flag == "掉背心护甲"{
                self.bloodAnddefance(send: text)
            }
//            else if responseModel.flag == "雪花屏" {
//                self.MyShield = 1
//                self.isshield(sender: MyShield)
//            }
            else if responseModel.flag == "自动毒圈" {
                if let responseModel = poisonFlagModel.deserialize(from: text) {
                    self.poisonList = responseModel.data
                }
            }
        }
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("接收数据:\(data)")
    }
    
    //socket相关协议
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = true
            self.game?.GameStatus?.isHidden = false
        }
        print("socket连接成功")
        heartTimer!.fire()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        //        print("connect error: \(String(describing: err!))")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = false
            self.game?.GameStatus?.isHidden = true
        }
        print("socket连接失败")
        if isContinue == true {
            do{
                try sock.connect(toHost: Host!, onPort: 25409)
            }
            catch{
            }
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        // 1、获取服务端发来的数据，把 NSData 转 NSString
        //        let readClientDataString: NSString? = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //服务端数据GBK编码，转String
        let readClientDataString: String? = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))))
        //        print(readClientDataString!)
        if let responseModel = SocketModel.deserialize(from: readClientDataString) {
            if responseModel.ACTION == "phone-receive-msg" { //判断是心跳还是其他回复
                if responseModel.DATA?.MSG_TYPE == "MSG_VOICE" { //判断是否是语音
                    if responseModel.DATA?.MSG_CHANNEL == "team"{ //队伍语音
                        TeamVoiceName.append(responseModel.DATA!.PERSON_NAME)
                        TeamUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                        //主线程异步刷新tableview以及显示小红点
                        DispatchQueue.main.async {
                            if self.game?.talkbtn?.SelectBtn?.tag != 0{
                                self.game?.talkbtn?.NewTip1?.isHidden = false
                            }
                            self.game?.talk?.TableView1?.reloadData()
                            self.talknum = 10
                            self.talkcloseOpen()
                            self.msgchange2(sender: 0)
                        }
                    }else if responseModel.DATA?.MSG_CHANNEL == "world"{ //世界语音
                        WorldVoiceName.append(responseModel.DATA!.PERSON_NAME)
                        WorldUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                        DispatchQueue.main.async {
                            if self.game?.talkbtn?.SelectBtn?.tag != 1{
                                self.game?.talkbtn?.NewTip2?.isHidden = false
                            }
                            self.game?.talk?.TableView2?.reloadData()
                            self.talknum = 10
                            self.talkcloseOpen()
                            self.msgchange2(sender: 1)
                        }
                    }
                }
                else if responseModel.DATA?.MSG_TYPE == "MSG_TXT" { //判断是否是干预信息
                    SVProgressHUD.showInfo(withStatus: "\((responseModel.DATA?.MSG_TXT)!)")
                }
            }
        }
        
        // 2、每次读完数据后，都要调用一次监听数据的方法
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(game?.TeamTableView){
            return MyTeamName.count
        }
        else if tableView.isEqual(game?.talk?.TableView1) {
            return TeamVoiceName.count
        }
        else if tableView.isEqual(game?.talk?.TableView2) {
            return WorldVoiceName.count
        }
        else if tableView.isEqual(game?.talk?.TableView3) {
            return ReportArray.count
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
//            return bagItemDic.count
            return bagItemArray.count
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            return nearItemId.count
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            return TeamName.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(game?.TeamTableView){
            return 50
        }
        else if tableView.isEqual(game?.talk?.TableView1) {
            return 30
        }
        else if tableView.isEqual(game?.talk?.TableView2) {
            return 30
        }
        else if tableView.isEqual(game?.talk?.TableView3) {
            return 30
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
            return 60
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            return 60
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if tableView.isEqual(game?.TeamTableView){
            var cell : TeamTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell") as? TeamTableViewCell
            if cell == nil {
                cell = TeamTableViewCell(style: .default, reuseIdentifier: "TeamTableViewCell")
            }
            if let cell = cell {
                cell.model = TeamdataSources[indexPath.row]
            }
            cell.saveButton?.tag = indexPath.row
            cell.saveButton?.addTarget(self, action: #selector(openSave(sender:)), for: .touchUpInside)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView1){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = TeamVoiceName[indexPath.row].removingPercentEncoding
            cell.SpeechView?.delegate = self
            btn = cell.SpeechView

            weak var weakSelf = self
            weakSelf?.btn.contentURL = TeamUrlArray[indexPath.row]
            weakSelf?.btn.isUserInteractionEnabled = true

            cell.SpeechView = btn
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView2){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = WorldVoiceName[indexPath.row].removingPercentEncoding
            cell.SpeechView?.delegate = self
            btn = cell.SpeechView

            weak var weakSelf = self
            weakSelf?.btn.contentURL = WorldUrlArray[indexPath.row]
            weakSelf?.btn.isUserInteractionEnabled = true

            cell.SpeechView = btn
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView3){
            var cell : GameTableViewCell2! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell2") as? GameTableViewCell2
            if cell == nil {
                cell = GameTableViewCell2(style: .default, reuseIdentifier: "GameTableViewCell2")
            }
            cell.ReportLabel?.text = ReportArray[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
            var cell : BagTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "BagTableViewCell") as? BagTableViewCell
            if cell == nil {
                cell = BagTableViewCell(style: .default, reuseIdentifier: "BagTableViewCell")
            }
            cell.itemImage?.kf.setImage(with: URL(string: CategoryDic[bagItemArray[indexPath.row].categoryId]!.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.itemName?.text = CategoryDic[bagItemArray[indexPath.row].categoryId]!.categoryName
            cell.itemNum?.text = "X\(bagItemArray[indexPath.row].img)"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            var cell : NearTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NearTableViewCell") as? NearTableViewCell
            if cell == nil {
                cell = NearTableViewCell(style: .default, reuseIdentifier: "NearTableViewCell")
            }
            cell.itemImage?.kf.setImage(with: URL(string: CategoryDic[nearItemId[indexPath.row]]!.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.itemName?.text = CategoryDic[nearItemId[indexPath.row]]!.categoryName
            cell.itemNum?.text = "X\(nearItemNum[indexPath.row])"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            var cell : battleResultsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "battleResultsTableViewCell") as? battleResultsTableViewCell
            if cell == nil {
                cell = battleResultsTableViewCell(style: .default, reuseIdentifier: "battleResultsTableViewCell")
            }
            cell.Icon?.kf.setImage(with: URL(string: TeamIcon[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.Name?.text = TeamName[indexPath.row]
            cell.Damage?.text = "\(TeamDamage[indexPath.row])"
            cell.Kill?.text = "\(TeamKill[indexPath.row])"
            if gameRule == 1 {
                cell.Survival?.isHidden = false
                cell.dead?.isHidden = true
            } else if gameRule == 2 {
                cell.Survival?.isHidden = true
                cell.dead?.isHidden = false
            }
            self.TeamSurvival_h = Int(floor(Double(self.TeamSurvival[indexPath.row]/3600000)))
            self.TeamSurvival_m = Int(floor(Double((self.TeamSurvival[indexPath.row]%3600000)/60000)))
            self.TeamSurvival_s = ((self.TeamSurvival[indexPath.row]%3600000)%60000)/1000
            cell.Survival?.text = String(format:"%02d",self.TeamSurvival_h!)+":"+String(format:"%02d",self.TeamSurvival_m!)+":"+String(format:"%02d",self.TeamSurvival_s!)
            cell.dead?.text = "\(TeamDead[indexPath.row])"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(game?.bag?.bagTableView){
            game?.operation?.isHidden = false
            ItemRow = indexPath.row
        }
        else if tableView.isEqual(game?.bag?.nearTableView){
            getItem(send: indexPath.row)
        }
        else if tableView.isEqual(game?.TeamTableView) {
            let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
            if cell?.TeamIconView?.isHidden == true {
                cell?.TeamIconView?.isHidden = false
                cell?.TeamView?.frame.origin.x = 34
                cell?.saveButton?.frame.origin.x = 209
                cell?.TeamKillView?.isHidden = false
                cell?.TeamDamageView?.isHidden = false
            }else{
                cell?.TeamIconView?.isHidden = true
                cell?.TeamView?.frame.origin.x = 0
                cell?.saveButton?.frame.origin.x = 175
                cell?.TeamKillView?.isHidden = true
                cell?.TeamDamageView?.isHidden = true
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyTeamName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! GameCollectionViewCell
        cell.model = TeamdataSources[indexPath.item]
        cell.saveButton?.tag = indexPath.item
        cell.saveButton?.addTarget(self, action: #selector(openSave(sender:)), for: .touchUpInside)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //语音工具必须实现的协议
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool) {
        //        NSLog("voiceBubbleStratOrStop")
    }
    
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble) {
        //        NSLog("voiceBubbleDidStartPlaying")
    }
    
    //gps
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        MyLon = currLocation.coordinate.longitude
        MyLat = currLocation.coordinate.latitude
        //坐标转换
        let coodinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(MyLat!, MyLon!)
        let srctype = BMKLocationCoordinateType.WGS84    //原始坐标系
//        let srctype = BMKLocationCoordinateType.GCJ02    //火星坐标系
        let destype = BMKLocationCoordinateType.BMK09LL  //百度坐标系
        let cood: CLLocationCoordinate2D = BMKLocationManager.bmkLocationCoordinateConvert(coodinate, srcType: srctype, desType: destype)
        MyLon = cood.longitude
        MyLat = cood.latitude
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        gpsstr = "{\"lon\":\(MyLon!),\"gpsType\":\"phone\",\"time\":\(timeStamp),\"hdop\":\(currLocation.horizontalAccuracy),\"devid\":\"\(packageNo!)\",\"lat_type\":\"N\",\"height\":\(currLocation.altitude),\"state\":1,\"stars\":0,\"lon_type\":\"E\",\"locationTime\":0,\"direction\":\(currLocation.course),\"appType\":0,\"gameid\":\(gameId!),\"height_unit\":\"M\",\"lat\":\(MyLat!)}\r\n"
        gpsjsonData = gpsstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if gpsTimer == nil {
            gpsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendgps), userInfo: nil, repeats: true)
            gpsTimer?.fire()
        }
//        _ = onecode
//        //获取经度
//        print("经度：\(currLocation.coordinate.longitude)")
//        //获取纬度
//        print("纬度：\(currLocation.coordinate.latitude)")
//        //获取海拔
//        print("海拔：\(currLocation.altitude)")
//        //获取水平精度
//        print("水平精度：\(currLocation.horizontalAccuracy)")
//        //获取垂直精度
//        print("垂直精度：\(currLocation.verticalAccuracy)")
//        //获取方向
//        print("方向：\(currLocation.course)")
//        //获取速度
//        print("速度：\(currLocation.speed)")
    }
    
    func mapView(_ mapView: BMKMapView, viewFor annotation: BMKAnnotation) -> BMKAnnotationView? {
        if (annotation is BMKPointAnnotation) {
            if annotationArray.count > 0 {
                if annotation.isEqual(annotationArray[i]){
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationArray")
                    if annotationView == nil {
                        annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "annotationArray")
                    }
                    if ImageCache.default.isCached(forKey: IconArray[i]) == false {
                        var image : UIImage? = nil
                        do{
                            image = UIImage(data: try Data(contentsOf: URL(string: IconArray[i])!))
                            ImageCache.default.store(image!, forKey: IconArray[i])
                            annotationView?.image = ImageCache.default.retrieveImageInDiskCache(forKey: IconArray[i])
                        }catch{
                        }
                    }else{
                        annotationView?.image = ImageCache.default.retrieveImageInDiskCache(forKey: IconArray[i])
                    }
                    annotationView?.frame.size = CGSize(width: 20, height: 20)
                    annotationView?.layer.cornerRadius = (annotationView?.frame.width)!/2
                    annotationView?.layer.masksToBounds = true
                    return annotationView
                }
            }
            if airdropArray.count > 0{
                if annotation.isEqual(airdropArray[j]){
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "airdropArray")
                    if annotationView == nil {
                        annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "airdropArray")
                    }
                    if airdrop![j].status == 1{
                       annotationView?.image = UIImage(named: "kongtou.png")
                    }else if airdrop![j].status == 2{
                        annotationView?.image = UIImage(named: "wuzi.png")
                    }
                    return annotationView
                }
            }
            if annotation.isEqual(PoisonAnnotation){
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PoisonAnnotation")
                if annotationView == nil {
                    annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "PoisonAnnotation")
                }
                annotationView?.image = UIImage(named: "none.png")
                game?.Poisontitle?.text = annotation.title?()
                annotationView?.addSubview((game?.Poisontitle)!)
                return annotationView
            }else if annotation.isEqual(BombAnnotation){
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BombAnnotation")
                if annotationView == nil {
                    annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "BombAnnotation")
                }
                annotationView?.image = UIImage(named: "none.png")
                game?.Bombtitle?.text = annotation.title?()
                annotationView?.addSubview((game?.Bombtitle)!)
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if (overlay is BMKCircle) {
            let circleView = BMKCircleView(overlay: overlay)
            if overlay.isEqual(BombCircle){
                circleView?.strokeColor = UIColor.red
                circleView?.fillColor = UIColor.red.withAlphaComponent(0.5)
            }
            else if overlay.isEqual(PoisonCircle_B){
                circleView?.strokeColor = UIColor.red
                circleView?.lineWidth = 1
            }
            else if overlay.isEqual(PoisonCircle_S){
                circleView?.strokeColor = UIColor.green
                circleView?.lineWidth = 1
            }
            return circleView
        }
        if (overlay is BMKTileLayer) {
            let view = BMKTileLayerView(tileLayer: overlay as? BMKTileLayer)
            return view
        }
        return nil
    }
    
    
    //MARK:BMKLocationManagerDelegate
    /**
     @brief 该方法为BMKLocationManager提供设备朝向的回调方法
     @param manager 提供该定位结果的BMKLocationManager类的实例
     @param heading 设备的朝向结果
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        //        NSLog("用户方向更新")
        userLocation.heading = heading
        game?.map?.mapView?.updateLocationData(userLocation)
    }
    
    /**
     @brief 连续定位回调函数
     @param manager 定位 BMKLocationManager 类
     @param location 定位结果，参考BMKLocation
     @param error 错误信息。
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let _ = error?.localizedDescription {
            NSLog("locError:%@;", (error?.localizedDescription)!)
        }
        userLocation.location = location?.location
        //实现该方法，否则定位图标不出现
        game?.map?.mapView?.updateLocationData(userLocation)
    }
    
    /**
     @brief 当定位发生错误时，会调用代理的此方法
     @param manager 定位 BMKLocationManager 类
     @param error 返回的错误，参考 CLError
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        NSLog("定位失败")
    }
    
    //image旋转任意角度
//    func getRotationImage(_ image: UIImage?, rotation: CGFloat, point: CGPoint) -> UIImage? {
//        let num = Int(floor(rotation))
//        if CGFloat(num) == rotation && num % 360 == 0 {
//            return image
//        }
//        let radius = Double(rotation * .pi / 180)
//
//        let rotatedSize: CGSize? = image?.size
//        // Create the bitmap context
//        UIGraphicsBeginImageContext(rotatedSize!)
//        let bitmap = UIGraphicsGetCurrentContext()
//
//        // rotated image view
//        bitmap?.scaleBy(x: 1.0, y: -1.0)
//
//        // move to the rotation relative point
//        bitmap?.translateBy(x: point.x, y: -point.y)
//
//        // Rotate the image context
//        bitmap?.rotate(by: CGFloat(radius))
//
//        // Now, draw the rotated/scaled image into the context
//        bitmap?.draw((image?.cgImage)!, in: CGRect(x: -point.x, y: -(image?.size.height)! + point.y, width: (image?.size.width)!, height: (image?.size.height)!))
//
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    //MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [Int : Int]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Int : Int] {
            return dict
        }
        return nil
    }
    
    //点击空白隐藏
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if game?.TeamView?.isHidden == false{
//            game?.TeamView?.isHidden = true
//        }
//        if game?.BagView?.isHidden == false{
//            game?.BagView?.isHidden = true
//        }
//        if game?.saveBg?.isHidden == false{
//            game?.saveBg?.isHidden = true
//        }
//    }
    //点击地图隐藏
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            game?.TeamView?.isHidden = true
            game?.bag?.isHidden = true
            game?.SaveView?.isHidden = true
            hiddenOperation()
            SVProgressHUD.dismiss()
        }
        sender.cancelsTouchesInView = false
    }
    //点击背包隐藏
    @objc func handleTap_2(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            hiddenOperation()
            SVProgressHUD.dismiss()
        }
        sender.cancelsTouchesInView = false
    }
    //获取天气
    func getWeather(){
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather", method: .get, parameters: ["lat": "\(centerLat!)", "lon": "\(centerLon!)", "appid": "12b2817fbec86915a6e9b4dbbd3d9036"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = weatherModel.deserialize(from: jsonString) {
                        if responseModel.cod == 200 {
                            self.weatherMain = responseModel.weather[0].main
                            self.weatherDescription = responseModel.weather[0].description
                            self.chooseWeather()
                        }
                    }
                }
            }
        }
    }
    //选择天气类型
    func chooseWeather(){
        if weatherMain == "Clear" {
            weather = WHWeatherType.sun
        }else if weatherMain == "Clouds" {
            weather = WHWeatherType.clound
        }else if weatherMain == "Rain" {
            if weatherDescription == "light rain" || weatherDescription == "light intensity shower rain"{
                weather = WHWeatherType.rainLighting
            }else{
                weather = WHWeatherType.rain
            }
        }else if weatherMain == "Snow" {
            weather = WHWeatherType.snow
        }else{
            weather = WHWeatherType.other
        }
        game?.weatherView?.showWeatherAnimation(with: weather!)
    }
    //检测网络状况
//    func currentNetReachability() {
//        let manager = NetworkReachabilityManager()
//        manager?.listener = { status in
//            var statusStr: String?
//            switch status {
//            case .unknown:
//                statusStr = "未识别的网络"
//                break
//            case .notReachable:
//                statusStr = "网络未连接"
//                SVProgressHUD.showInfo(withStatus: statusStr)
//                break
//            case .reachable:
//                if (manager?.isReachableOnWWAN)! {
//                    statusStr = "移动的网络"
//                } else if (manager?.isReachableOnEthernetOrWiFi)! {
//                    statusStr = "wifi的网络";
//                }
//                break
//            }
//        }
//        manager?.startListening()
//    }

}
