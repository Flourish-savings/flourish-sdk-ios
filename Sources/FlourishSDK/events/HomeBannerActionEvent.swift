import Foundation

public struct HomeBannerActionEvent: Codable {
    public let eventName: String
    public let data: HomeBannerActionEventData
}

public struct HomeBannerActionEventData: Codable {
    public let data: String
}

