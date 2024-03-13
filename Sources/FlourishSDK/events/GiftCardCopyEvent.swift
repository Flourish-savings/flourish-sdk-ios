import Foundation

public struct GiftCardCopyEvent: Codable {
    public let eventName: String
    public let data: GiftCardCopyEventData
}

public struct GiftCardCopyEventData: Codable {
    public let giftCardCode: String
}

