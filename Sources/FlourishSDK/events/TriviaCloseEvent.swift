import Foundation

public struct TriviaCloseEvent: Codable {
    public let eventName: String
    public let data: TriviaCloseEventData
}

public struct TriviaCloseEventData: Codable {
    public let data: String
}
