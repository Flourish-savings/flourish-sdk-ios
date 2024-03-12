import Foundation

struct TriviaFinishEvent {
    public let name: String
    public let data: TriviaFinishEventData
}

struct TriviaFinishEventData {
    public let hits: Int
    public let questions: Int
    public let prizes: [Prize]
}


struct Prize {
    public let quantity: Int
    public let category: String
}
