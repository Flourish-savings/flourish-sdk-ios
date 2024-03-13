import Combine
import Foundation

public protocol FlourishEvent: AnyObject {
    func onTriviaGameFinishedEvent(triviaFinishEvent: TriviaFinishEvent)
    func onBackButtonPressedEvent(backButtonPressedEvent: BackButtonPressedEvent)
}

@available(macOS 13.0, *)
public class FlourishEventManager {
    public let eventDelegate: FlourishEvent
    
    public init(eventDelegate: FlourishEvent) {
        self.eventDelegate = eventDelegate
    }

    public func generateEvent(eventString: String) {
        guard let jsonData = eventString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data")
            fatalError()
        }
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print(jsonDictionary)
                
                if let eventName = jsonDictionary["eventName"] as? String {
                    switch eventName {
                    case "TRIVIA_GAME_FINISHED":
                        let eventData = try JSONDecoder().decode(TriviaFinishEvent.self, from: jsonData)
                        self.eventDelegate.onTriviaGameFinishedEvent(triviaFinishEvent: eventData)
                    case "BACK_BUTTON_PRESSED":
                        let eventData = try JSONDecoder().decode(BackButtonPressedEvent.self, from: jsonData)
                        self.eventDelegate.onBackButtonPressedEvent(backButtonPressedEvent: eventData)
                    default:
                        print("Event not found")
                    }
                }
            } else {
                print("Failed to convert JSON data into dictionary")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
