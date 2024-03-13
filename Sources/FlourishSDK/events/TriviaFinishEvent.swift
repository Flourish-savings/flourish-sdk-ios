import Foundation

public struct TriviaFinishEvent: Codable {
    public let name: String
    public let data: TriviaFinishEventData
}

public struct TriviaFinishEventData: Codable {
    public let hits: Int
    public let questions: Int
    public let prizes: [Prize]
}


public struct Prize: Codable {
    public let quantity: Int
    public let category: String
}
