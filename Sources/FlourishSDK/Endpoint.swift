import Foundation


public class Endpoint {
    var environment: Environment
    var language: Language
    private var backendUrlMapper = [Environment.production: "https://api.flourishfi.com/api/v1",
                                   Environment.staging: "https://api-stg.flourishfi.com/api/v1"]
    
    private var frontendUrlMapper = [Environment.production: "https://platform.flourishfi.com",
                                     Environment.staging: "https://platform-stg.flourishfi.com"]

    init(environment: Environment, language: Language) {
        self.environment = environment
        self.language = language
    }

    var backend: String {
        return backendUrlMapper[environment] ?? "https://api-stg.flourishfi.com/api/v1"
    }

    var frontend: String {

        let baseUrl = frontendUrlMapper[environment] ?? "https://platform-stg.flourishfi.com"

        return "\(baseUrl)?lang=\(self.language)"
    }
}
