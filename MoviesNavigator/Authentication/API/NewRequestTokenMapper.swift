//
//  NewRequestTokenMapper.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 9/5/22.
//

import Foundation

public final class NewTokenRequestMapper {
    private struct CodableSessionToken: Codable {
        let expires_at: String
        let request_token: String
        
        var sessionToken: SessionToken {
            SessionToken(requestToken: request_token, expiresAt: expires_at)
        }
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> SessionToken {
        guard response.statusCode == 200,
              let token = try? JSONDecoder().decode(CodableSessionToken.self, from: data).sessionToken else {
            throw AuthenticationError.invalidData
        }
        
        return token
    }
    
}
