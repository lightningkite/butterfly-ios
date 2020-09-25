import RxSwift
import RxRelay
import Starscream

public final class ConnectedWebSocket: WebSocketDelegate, Disposable {

    public var ownConnection = PublishSubject<ConnectedWebSocket>.create()
    var underlyingSocket: WebSocket?
    var url: String
    private let _read: PublishSubject<WebSocketFrame> = PublishSubject.create()
    public var read: Observable<WebSocketFrame> { return _read }

    init(url: String) {
        self.url = url
    }

    public func onComplete() -> Void {
        underlyingSocket?.disconnect(closeCode: 1000)
    }

    public func onNext(frame: WebSocketFrame) -> Void {
        return onNext(frame)
    }

    public func onError(error: Error) -> Void {
        return onError(error)
    }

    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .binary(let data):
            print("Socket to \(url) got binary message of length '\(data.count)'")
            _read.onNext(WebSocketFrame(binary: data))
            break
        case .text(let string):
            print("Socket to \(url) got message '\(string)'")
            _read.onNext(WebSocketFrame(text: string))
            break
        case .connected(let headers):
            print("Socket to \(url) opened successfully.")
            ownConnection.onNext(self)
            break
        case .disconnected(let reason, let code):
            print("Socket to \(url) disconnecting with code \(code). Reason: \(reason)")
            ownConnection.onCompleted()
            _read.onComplete()
            break
        case .error(let error):
            print("Socket to \(url) failed with error \(error)")
            ownConnection.onError(error ?? Exception())
            read.onError(error ?? Exception())
            break
        case .cancelled:
            print("Socket to \(url) cancelled")
            ownConnection.onError(Exception("Socket connection cancelled."))
            _read.onComplete()
            break
        default:
            break
        }
    }
    
    public func dispose() {
        print("Socket to \(url) was disposed, closing with OK code.")
        underlyingSocket?.disconnect(closeCode: 1000)
        ownConnection.onCompleted()
        _read.onComplete()
    }

}

