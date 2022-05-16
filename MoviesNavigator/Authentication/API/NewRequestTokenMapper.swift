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
    
    private struct CodableError: Codable {
        let success: Bool
        let status_code: Int
        let status_message: String
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> SessionToken {
        guard response.statusCode == 200,
              let token = try? JSONDecoder().decode(CodableSessionToken.self, from: data).sessionToken else {
            throw mapError(data)
        }
        
        return token
    }
    
    private static func mapError(_ data: Data) -> AuthenticationError {
        guard let error = try? JSONDecoder().decode(CodableError.self, from: data) else {
            return .invalidData
        }
        
        switch error.status_code {
        case 30:
            return .incorrectUserOrPassword
        default:
            return .invalidData
        }
    }
    
}
