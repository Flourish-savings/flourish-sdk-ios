import Combine
import Foundation
import SwiftUI

public protocol FlourishEvent: AnyObject {
    func onGenericEvent(event: Data)
    func onGiftCardCopyEvent(giftCardCopyEvent: GiftCardCopyEvent)
    func onBackButtonPressedEvent(backButtonPressedEvent: BackButtonPressedEvent)
    func onHomeBannerActionEvent(homeBannerActionEvent: HomeBannerActionEvent)
    func onMissionActionEvent(missionActionEvent: MissionActionEvent)
    func onReferralCopyEvent(referralCopyEvent: ReferralCopyEvent)
    func onTriviaCloseEvent(triviaCloseEvent: TriviaCloseEvent)
    func onTriviaGameFinishedEvent(triviaFinishEvent: TriviaFinishEvent)
}

@available(macOS 12.0, *)
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
                    case "REFERRAL_COPY":
                        let eventData = try JSONDecoder().decode(ReferralCopyEvent.self, from: jsonData)
                        let message = eventData.data.referralCode
                        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    default:
                        self.eventDelegate.onGenericEvent(event: jsonData)
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
