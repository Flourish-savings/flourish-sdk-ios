import Foundation

public struct BackButtonPressedEvent: Codable {
    public let eventName: String
    public let data: BackButtonPressedEventData
}

public struct BackButtonPressedEventData: Codable {
    public let path: String
}

