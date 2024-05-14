import Combine
import Foundation
import SwiftUI

public protocol FlourishEvent: AnyObject {
    func onGiftCardCopyEvent(giftCardCopyEvent: GiftCardCopyEvent)
    func onBackButtonPressedEvent(backButtonPressedEvent: BackButtonPressedEvent)
    func onHomeBannerActionEvent(homeBannerActionEvent: HomeBannerActionEvent)
    func onMissionActionEvent(missionActionEvent: MissionActionEvent)
    func onReferralCopyEvent(referralCopyEvent: ReferralCopyEvent)
    func onTriviaCloseEvent(triviaCloseEvent: TriviaCloseEvent)
    func onTriviaGameFinishedEvent(triviaFinishEvent: TriviaFinishEvent)
}

@available(macOS 13.0, *)
public class FlourishEventManager {
    public let eventDelegate: FlourishEvent
    
    public init(eventDelegate: FlourishEvent) {
        self.eventDelegate = eventDelegate
    }

    public func generateEvent(eventString: String) {
        let jsonData = eventString.data(using: .utf8)!
        
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print(jsonDictionary)
                
                if let eventName = jsonDictionary["eventName"] as? String {
                    switch eventName {
                    case "GIFT_CARD_COPY":
                        let eventData = try JSONDecoder().decode(GiftCardCopyEvent.self, from: jsonData)
                        self.eventDelegate.onGiftCardCopyEvent(giftCardCopyEvent: eventData)
                    case "BACK_BUTTON_PRESSED":
                        let eventData = try JSONDecoder().decode(BackButtonPressedEvent.self, from: jsonData)
                        self.eventDelegate.onBackButtonPressedEvent(backButtonPressedEvent: eventData)
                    case "HOME_BANNER_ACTION":
                        let eventData = try JSONDecoder().decode(HomeBannerActionEvent.self, from: jsonData)
                        self.eventDelegate.onHomeBannerActionEvent(homeBannerActionEvent: eventData)
                    case "MISSION_ACTION":
                        let eventData = try JSONDecoder().decode(MissionActionEvent.self, from: jsonData)
                        self.eventDelegate.onMissionActionEvent(missionActionEvent: eventData)
                    case "REFERRAL_COPY":
                        let eventData = try JSONDecoder().decode(ReferralCopyEvent.self, from: jsonData)
                        let message = eventData.data.referralCode
                        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                        self.eventDelegate.onReferralCopyEvent(referralCopyEvent: eventData)
                    case "TRIVIA_CLOSED":
                        let eventData = try JSONDecoder().decode(TriviaCloseEvent.self, from: jsonData)
                        self.eventDelegate.onTriviaCloseEvent(triviaCloseEvent: eventData)
                    case "TRIVIA_GAME_FINISHED":
                        let eventData = try JSONDecoder().decode(TriviaFinishEvent.self, from: jsonData)
                        self.eventDelegate.onTriviaGameFinishedEvent(triviaFinishEvent: eventData)
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
