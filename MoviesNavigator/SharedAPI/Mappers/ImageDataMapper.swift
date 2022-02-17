//
//  ImageDataMapper.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 16/2/22.
//

import Foundation
import UIKit

public final class ImageDataMapper {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> Data {
        guard response.statusCode == 200, let _ = UIImage(data: data) else {
            throw Error.invalidData
        }
        
        return data
    }
    
}
