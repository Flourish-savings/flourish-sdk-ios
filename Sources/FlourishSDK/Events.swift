import Combine

public protocol EventListener: AnyObject {
    func didReceiveEvent(data: Any)
}

@available(macOS 13.0, *)
public class EventGenerator {
    public let eventListener: EventListener
    
    public init(eventListener: EventListener) {
        self.eventListener = eventListener
    }

    public func generateEvent(data: Any) {
        self.eventListener.didReceiveEvent(data: data)
    }
}
