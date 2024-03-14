import Foundation

public struct MissionActionEvent: Codable {
    public let eventName: String
    public let data: MissionActionEventData
}

public struct MissionActionEventData: Codable {
    public let data: String
}
