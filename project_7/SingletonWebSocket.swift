import Starscream

let webSocket = WebSocketSingle.shared
let websocketURL = "http://\(Host!):8998/websocket/\(gameId!)/0/\(teamId!)/\(personId!)"

final class WebSocketSingle:NSObject,WebSocketDelegate {
    
    //  socket连接上函数
    func websocketDidConnect(socket: WebSocketClient) {
    }
    
    //  socket断开执行函数
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    }
    
    //  接收返回消息函数
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    }
    
    //构造单例数据
    static let shared = WebSocketSingle()
    private override init() {
    }
}

// initSocket方法
func initWebSocketSingle () {
    SingletonWebSocket.sharedInstance.socket.delegate = webSocket
}

//声明webSocket单例
class SingletonWebSocket {
    //socketURL为websocket地址
    let socket:WebSocket = WebSocket(url: URL(string: websocketURL)!)
    
    class var sharedInstance : SingletonWebSocket{
        struct Static{
            static let instance:SingletonWebSocket = SingletonWebSocket()
        }
        
        if !Static.instance.socket.isConnected{
            Static.instance.socket.connect()
        }
        return Static.instance
    }
}
