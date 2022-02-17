//
//  ImageDataMapper.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 16/2/22.
//

import Foundation

public final class ImageDataMapper {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws {
        throw Error.invalidData
    }
    
}
