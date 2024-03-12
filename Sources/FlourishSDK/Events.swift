import Combine

public protocol EventListener: AnyObject {
    func didReceiveEvent(data: Any)
}

@available(macOS 13.0, *)
public class EventGenerator {
    public let eventPublisher = PassthroughSubject<Any, Never>()
    
    public init() {
        
    }

    func subscribe(listener: EventListener) -> AnyCancellable {
        return eventPublisher.sink { data in
            listener.didReceiveEvent(data: data)
        }
    }

    public func generateEvent(data: Any) {
        eventPublisher.send(data)
    }
}
