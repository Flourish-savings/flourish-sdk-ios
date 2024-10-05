import Foundation
import Alamofire

@available(iOS 12.0, *)
@available(macOS 12.0, *)
public class FlourishSdkManager {
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
        self.flourishEventManager = FlourishEventManager(eventDelegate: eventDelegate)
        requestAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.signIn(token: accessToken)
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func requestAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        let accessTokenRequest = AccessTokenRequest(partner_uuid: partnerUuid, partner_secret: partnerSecret, customer_code: customerCode)
        
        AF.request("\(endpoint.backend)/access_token", method: .post, parameters: accessTokenRequest).response { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                   let jsonDictionary = json as? [String: Any], let accessToken = jsonDictionary["access_token"] as? String {
                    TokenManager.shared.authToken = accessToken
                    completion(.success(accessToken))
                } else {
                    let error = NSError(domain: "FlourishSdkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Access token not found or invalid response"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func signIn(token: String) {
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
