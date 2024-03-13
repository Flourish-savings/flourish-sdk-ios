import Foundation

public struct ReferralCopyEvent: Codable {
    public let eventName: String
    public let data: ReferralCopyEventData
}

public struct ReferralCopyEventData: Codable {
    public let data: String
}
