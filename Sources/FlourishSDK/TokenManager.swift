//
//  TokenManager.swift
//  SdkExample
//
//  Created by Yuri Logatto Pamplona on 10/03/24.
//

import SwiftUI

@available(macOS 13.0, *)
public class TokenManager {
    @AppStorage("FLOURISH_ACCESS_TOKEN") var accessToken: String?

    public func saveToken(_ token: String) {
        accessToken = token
    }
}
