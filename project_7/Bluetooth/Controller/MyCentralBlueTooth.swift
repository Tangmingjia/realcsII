import CoreBluetooth

class MyCentralBlueTooth:NSObject{
    static var share = MyCentralBlueTooth()
    private override init() {}
    
    lazy var centralManager:CBCentralManager = {
        let central = CBCentralManager.init()
        central.delegate = self
        return central
    }()
    var BluetoothTimer : Timer?
    var BluetoothDictionary : Dictionary = [String : NSNumber]()
    var discoveredPeripherals:[CBPeripheral?] = []  //未连接的蓝牙外设
    var connectedPeripherals:[CBPeripheral?] = []  //已连接的蓝牙外设
    var peripheral:CBPeripheral?
    var characteristic:CBCharacteristic!
    var messageType:String?
    
    let search_UUID:String = "000000ff-0000-1000-8000-00805f9b34fb"
    let service_UUID:String = "000000ff-0000-1000-8000-00805f9b34fb"
    let characteristic_UUID:String = "0000ff01-0000-1000-8000-00805f9b34fb"
    
}

extension MyCentralBlueTooth{
    func bluetoothStart(){
        self.centralManager.delegate = self
//        self.centralManager.scanForPeripherals(withServices: [CBUUID.init(string: service_UUID)], options: nil)
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func connect(peripheral:CBPeripheral) {
        self.peripheral = peripheral
        centralManager.connect(self.peripheral!,options: nil)
    }
    
    func sendMessage(message:String){
        self.messageType = message
        let data = message.data(using: String.Encoding.utf8)
        self.peripheral?.writeValue(data!, for: self.characteristic!, type: CBCharacteristicWriteType.withoutResponse)
    }
    //移除已连接的元素
    func removeElement(nums:inout[CBPeripheral?],val:CBPeripheral){
        var res:Int = 0
        for i in 0..<nums.count{
            if (nums[i] != val){
                nums[res] = nums[i]
                res += 1
            }
        }
    }
}

extension MyCentralBlueTooth:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("未知的")
        case .resetting:
            print("重置中")
        case .unsupported:
            print("不支持")
        case .unauthorized:
            print("未验证")
        case .poweredOff:
            print("未启动")
        case .poweredOn:
            print("可用")
//            central.scanForPeripherals(withServices: [CBUUID.init(string: search_UUID)], options: nil)
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("失败")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        for discoveredPeripheral in discoveredPeripherals{
//            if(discoveredPeripheral == peripheral){
//                continue
//            }else{
//                print("添加设备\(peripheral.name!)")
//                discoveredPeripherals.append(peripheral)
//            }
//        }
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
        BluetoothDictionary[peripheral.identifier.uuidString] = RSSI
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DEVICES"), object: self, userInfo: ["devices":discoveredPeripherals,"device":peripheral])
    }
    // 连接成功后的回调函数
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功")
//        if BluetoothTimer != nil {  //连接成功后销毁定时器
//            BluetoothTimer?.invalidate()
//            BluetoothTimer = nil
//        }
//        centralManager.stopScan()
        
        removeElement(nums: &discoveredPeripherals, val: peripheral)  //在未连接的蓝牙外设里删除该蓝牙
        connectedPeripherals.append(peripheral)                       //在已连接的蓝牙外设里添加该蓝牙
        peripheral.delegate = self //设置代理，需要extension CBPeripheralDelegate
        peripheral.discoverServices([CBUUID.init(string: service_UUID)])//搜索指定的服务
    }
    //连接失败的回调函数
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败")
        removeElement(nums: &connectedPeripherals, val: peripheral)
    }
    //断开连接的回调函数
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("断开连接")
        removeElement(nums: &connectedPeripherals, val: peripheral)
        centralManager.connect(self.peripheral!,options: nil)
    }

}

extension MyCentralBlueTooth:CBPeripheralDelegate{
    //找到服务之后的回调函数
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service:CBService in peripheral.services!{
            print("外设中的服务有：\(service)")
        }
        let service = peripheral.services?.last//因为前面指定了服务，所以这里只有一个服务
        peripheral.discoverCharacteristics([CBUUID.init(string: characteristic_UUID)], for: service!)//通过这个服务，搜索指定特征
    }
    //找到特征之后的回调函数
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic:CBCharacteristic in service.characteristics!{
            print("外设中的特征有：\(characteristic)")
        }
        self.characteristic = service.characteristics?.last
        peripheral.readValue(for: self.characteristic!)//读取特征里的数据
        //订阅
        if !(characteristic!.isNotifying) {
            peripheral.setNotifyValue(true, for: self.characteristic!)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print("订阅失败：\(error)")
            return
        }
        if(characteristic.isNotifying){
            print("订阅成功")
        }else{
            print("订阅取消")
        }
    }
    /* 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //获取的数据是Data类型，我这里将它转为String类型
        let value = String.init(data:characteristic.value!,encoding: String.Encoding.utf8)
        //将获取的数据发给通知中心
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: self.messageType ?? "NOTYPE"), object: self, userInfo: ["value":value!])
    }
}
