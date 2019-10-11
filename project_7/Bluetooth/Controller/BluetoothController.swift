import UIKit
import CoreBluetooth



class BluetoothController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let type:String = "temperature*"
    

//    var BluetoothName: Array = [String]()
//    var BluetoothUUID: Array = [String]()
//    var BluetoothRSSI: Array = [NSNumber]()
//    var BluetoothDictionary : Dictionary = [String : NSNumber]()
    var BluetoothDatastring: String?
    var Bluetooth : BluetoothView?
//    var timer: Timer?
//    private let Service_UUID: String = "CDD1"
//    private let Characteristic_UUID: String = "CDD2"
//    private var centralManager: CBCentralManager?
//    private var peripheral: CBPeripheral?
//    private var peripherals: [CBPeripheral] = []
//    private var characteristic: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCentralBlueTooth.bluetoothStart()

        NotificationCenter.default.addObserver(self, selector: #selector(getValue), name: NSNotification.Name.init(rawValue: type), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDevices), name: NSNotification.Name.init(rawValue: "DEVICES"), object: nil)
        
//        myCentralBlueTooth.sendMessage(message: type)
        
//        centralManager = CBCentralManager.init(delegate: self, queue: .main)

        self.view.backgroundColor = UIColor.white
        
        Bluetooth = BluetoothView()
        Bluetooth?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.view.addSubview(Bluetooth!)
        Bluetooth?.backButton?.addTarget(self, action: #selector(back), for: .touchUpInside)
        Bluetooth?.reloadButton?.addTarget(self, action: #selector(reload), for: .touchUpInside)
        Bluetooth?.BluetoothTableView?.delegate = self
        Bluetooth?.BluetoothTableView?.dataSource = self
        
        startTime()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func getDevices(noti:Notification){
        BluetoothArray.removeAll()
        let userInfo = noti.userInfo!as NSDictionary
        let value = userInfo["devices"]!
        var array = value as! Array<Any>
        if array.count > 0 {
            for i in 0..<array.count {
                var str = "\(array[i])"
                str = str.replacingOccurrences(of: "<", with: "{\"")
                str = str.replacingOccurrences(of: ">", with: "\"}")
                str = str.replacingOccurrences(of: " =", with: ":")
                str = str.replacingOccurrences(of: ": ", with: "\":\"")
                str = str.replacingOccurrences(of: ", ", with: "\", \"")
                array[i] = str
            }
        }
        let array_2 : [String] = array as! [String]
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array_2, options: []) as NSData!
        var JSONString = String(data:data as Data,encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        JSONString = JSONString?.trimmingCharacters(in: CharacterSet(charactersIn: "\\"))
        JSONString = JSONString?.replacingOccurrences(of: "\\\"", with: "\"")
        JSONString = JSONString?.replacingOccurrences(of: "\"{", with: "{")
        JSONString = JSONString?.replacingOccurrences(of: "}\"", with: "}")
        if let responseModel = [BluetoothModel_2].deserialize(from: JSONString) {
            responseModel.forEach({(model) in
                BluetoothArray.append(model!)
            })
        }
    }
    
    @objc func getValue(noti:Notification){
        let userInfo = noti.userInfo!as NSDictionary
        let value = userInfo.object(forKey: "value")as! String
        print("Health\(value)")
    }
    
    
//    //写数据方法如下，需要把它加到需要的位置
//    func writeValue(_ peripheral: CBPeripheral,didWriteValueFor characteristic: CBCharacteristic,value : Data ) -> () {
//
//        //只有 characteristic.properties 有write的权限才可以写入
//        if characteristic.properties.contains(CBCharacteristicProperties.write){
//            //设置为  写入有反馈
//            self.peripheral?.writeValue(value, for: characteristic, type: .withResponse)
//        }else{
//            print("写入不可用~")
//        }
//    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reload(){
        myCentralBlueTooth.discoveredPeripherals.removeAll()
        myCentralBlueTooth.centralManager.stopScan()
        myCentralBlueTooth.bluetoothStart()
        Bluetooth?.BluetoothTableView?.reloadData()
//        peripherals.removeAll()
//        centralManager?.stopScan()
//        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func startTime(){
        if myCentralBlueTooth.BluetoothTimer == nil {
            myCentralBlueTooth.BluetoothTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(freshData), userInfo: nil, repeats: true)
            myCentralBlueTooth.BluetoothTimer?.fire()
        }
    }
    
    //更新bluetooth数据
    @objc func freshData(){
        BluetoothdataSources.removeAll()
        myCentralBlueTooth.centralManager.stopScan()
        myCentralBlueTooth.bluetoothStart()
//        centralManager?.stopScan()
//        centralManager?.scanForPeripherals(withServices: nil, options: nil)
//        myCentralBlueTooth.discoveredPeripherals.forEach({_ in
//            let model = BluetoothModel.init()
//            BluetoothdataSources.append(model)
//        })
        
        BluetoothArray.forEach({_ in
            let model = BluetoothModel()
            BluetoothdataSources.append(model)
        })
        
        if BluetoothdataSources.count > 0 {
            for i in 0..<BluetoothdataSources.count {
//                if myCentralBlueTooth.discoveredPeripherals[i]?.name != nil {
//                    BluetoothdataSources[i].BluetoothName = myCentralBlueTooth.discoveredPeripherals[i]!.name!
//                }else{
//                    BluetoothdataSources[i].BluetoothName = "Null"
//                }
//                BluetoothdataSources[i].BluetoothUUID = myCentralBlueTooth.discoveredPeripherals[i]!.identifier.uuidString
//                if myCentralBlueTooth.discoveredPeripherals[i]!.state == .disconnected {
//                    BluetoothdataSources[i].BluetoothState = "未连接"
//                }else{
//                    BluetoothdataSources[i].BluetoothState = "已连接"
//                }
//                BluetoothdataSources[i].BluetoothRSSI = "\(myCentralBlueTooth.BluetoothDictionary[myCentralBlueTooth.discoveredPeripherals[i]!.identifier.uuidString]!)"
                BluetoothdataSources[i].BluetoothName = BluetoothArray[i].name
                BluetoothdataSources[i].BluetoothUUID = BluetoothArray[i].identifier
                if BluetoothArray[i].state == "disconnected" {
                    BluetoothdataSources[i].BluetoothState = "未连接"
                }else{
                    BluetoothdataSources[i].BluetoothState = "已连接"
                }
                BluetoothdataSources[i].BluetoothRSSI = "\(myCentralBlueTooth.BluetoothDictionary[BluetoothArray[i].identifier]!)"
            }
        }
        Bluetooth?.BluetoothTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return BluetoothdataSources.count
        return BluetoothArray.count
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : BluetoothTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "BluetoothTableViewCell") as? BluetoothTableViewCell
        if cell == nil {
            cell = BluetoothTableViewCell(style: .default, reuseIdentifier: "BluetoothTableViewCell")
        }
        if let cell = cell {
            cell.model = BluetoothdataSources[indexPath.row]
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myCentralBlueTooth.connect(peripheral: myCentralBlueTooth.discoveredPeripherals[indexPath.row]!)
        tableView.reloadData()
    }
    
    
//    @IBAction func didClickGet(_ sender: Any) {
//        self.peripheral?.readValue(for: self.characteristic!)
//    }
//
//    @IBAction func didClickPost(_ sender: Any) {
//        let data = (self.textField.text ?? "empty input")!.data(using: String.Encoding.utf8)
//        self.peripheral?.writeValue(data!, for: self.characteristic!, type: CBCharacteristicWriteType.withResponse)
//    }
    
}


//extension BluetoothController: CBCentralManagerDelegate, CBPeripheralDelegate {
//
//    // 判断手机蓝牙状态
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown:
//            print("未知的")
//        case .resetting:
//            print("重置中")
//        case .unsupported:
//            print("不支持")
//        case .unauthorized:
//            print("未验证")
//        case .poweredOff:
//            print("未启动")
//        case .poweredOn:
//            print("可用")
////            central.scanForPeripherals(withServices: [CBUUID.init(string: Service_UUID)], options: nil)
////            BluetoothRSSI.removeAll()
//            central.scanForPeripherals(withServices: nil, options: nil)
//        }
//    }
//
//    /** 发现符合要求的外设 */
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        self.peripheral = peripheral
//        if !peripherals.contains(peripheral) {
//            peripherals.append(peripheral)
//        }
//        BluetoothDictionary[peripheral.identifier.uuidString] = RSSI
////        print(BluetoothDictionary)
////        print("\(peripheral.identifier.uuidString)"+"\(RSSI)")
////        print("\(peripheral)"+"\(RSSI)"+"\(advertisementData)")
//        // 根据外设名称来过滤
//        //        if (peripheral.name?.hasPrefix("WH"))! {
//        //            central.connect(peripheral, options: nil)
//        //        }
////        central.connect(peripheral, options: nil)
//    }
//
//    /** 连接成功 */
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        if timer != nil {  //连接成功后销毁定时器
//            timer?.invalidate()
//            timer = nil
//        }
//        self.centralManager?.stopScan()
//        peripheral.delegate = self
//        //外设寻找service
////        peripheral.discoverServices(nil)
//        peripheral.discoverServices([CBUUID.init(string: Service_UUID)])
//        print("连接成功")
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("连接失败")
//    }
//
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("断开连接")
//        // 重新连接
//        central.connect(peripheral, options: nil)
//    }
//
//    /** 发现服务 */
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        for service: CBService in peripheral.services! {
//            print("外设中的服务有：\(service)")
//        }
//        //本例的外设中只有一个服务
//        let service = peripheral.services?.last
//        // 根据UUID寻找服务中的特征
//        peripheral.discoverCharacteristics([CBUUID.init(string: Characteristic_UUID)], for: service!)
//    }
//
//    /** 发现特征 */
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        for characteristic: CBCharacteristic in service.characteristics! {
//            print("外设中的特征有：\(characteristic)")
//        }
//
//        self.characteristic = service.characteristics?.last
//        // 读取特征里的数据
//        peripheral.readValue(for: self.characteristic!)
//        // 订阅  设置 characteristic 的 notifying 属性 为 true ， 表示接受广播
//        peripheral.setNotifyValue(true, for: self.characteristic!)
//    }
//
//    /** 订阅状态 */
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("订阅失败: \(error)")
//            return
//        }
//        if characteristic.isNotifying {
//            print("订阅成功")
//        } else {
//            print("取消订阅")
//        }
//    }
//
//    /** 接收到数据 */
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        let data = characteristic.value
//        self.BluetoothDatastring = String.init(data: data!, encoding: String.Encoding.utf8)
//        print(self.BluetoothDatastring)
//    }
//
//    /** 写入数据回调 */
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("写入数据")
//
//    }
//
//}
