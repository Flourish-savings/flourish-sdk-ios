import Foundation
import Alamofire
import SwiftUI

@available(macOS 13.0, *)
public class FlourishSdkManager: ObservableObject {
    public let customerCode: String
    public let partnerUuid: String
    public let partnerSecret: String
    public let environment: Environment
    public let language: Language
    public let endpoint: Endpoint
    public var flourishEventManager: FlourishEventManager?

    public init(
            customerCode: String,
            partnerUuid: String,
            partnerSecret: String,
            environment: Environment,
            language: Language
        ) {
            self.customerCode = customerCode
            self.partnerUuid = partnerUuid
            self.partnerSecret = partnerSecret
            self.environment = environment
            self.language = language
            self.endpoint = Endpoint(environment: self.environment, language: self.language)
        }

    public func initialize(completion: @escaping (Result<String, Error>) -> Void, eventDelegate: FlourishEvent) {
        let accessTokenRequest = AccessTokenRequest(partner_uuid: partnerUuid, partner_secret: partnerSecret, customer_code: customerCode)
        self.flourishEventManager = FlourishEventManager(eventDelegate: eventDelegate)
        AF.request("\(endpoint.backend)/access_token", method: .post, parameters: accessTokenRequest).response { response in
            switch response.result {
            case .success(let data):
                // Use optional chaining to safely access response.data
                if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    // Check if the parsed JSON is a dictionary
                    if let jsonDictionary = json as? [String: Any] {
                        // Access the value of "access_token" key
                        if let accessToken = jsonDictionary["access_token"] as? String {
                            TokenManager.shared.authToken = accessToken
                            self.signIn(token: accessToken)
                            completion(.success((accessToken)))
                        } else {
                            let error = NSError(domain: "FlourishSdkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access token not found in response"])
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "FlourishSdkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
                        completion(.failure(error))
                    }
                } else {
                    // Handle the case where data or jsonData is nil
                    let error = NSError(domain: "FlourishSdkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Response data is nil or invalid"])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    public func signIn(token: String) -> Void {
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        if let versionCode = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            headers["Sdk-Version"] = versionCode
        }

        AF.request("\(endpoint.backend)/sign_in", method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                print("SignIn request success: \(String(describing: data))")
            case .failure(let error):
                print("SignIn request failed with error: \(error)")
            }
        }
    }
}

public struct AccessTokenRequest: Encodable {
    let partner_uuid: String
    let partner_secret: String
    let customer_code: String
}
