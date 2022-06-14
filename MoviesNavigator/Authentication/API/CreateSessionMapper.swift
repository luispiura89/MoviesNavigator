//
//  CreateSessionMapper.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 14/6/22.
//

import Foundation

public final class CreateSessionMapper {
    private struct CodableSession: Codable {
        let session_id: String
        let success: Bool
        
        var session: RemoteSession {
            RemoteSession(id: session_id)
        }
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> RemoteSession {
        guard response.statusCode == 200,
              let session = try? JSONDecoder().decode(CodableSession.self, from: data).session else {
                  throw AuthenticationError.invalidData
              }
        
        return session
    }
    
}
