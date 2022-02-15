//
//  Combine+Helpers.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/1/22.
//

import Foundation
import Combine
import SharedAPI

extension HTTPClient {
    
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(from url: URL) -> Publisher {
        Deferred {
            Future { completion in
                get(from: url, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}

extension AnyPublisher {
    public func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.sharedImmediateMainQueueScheduler)
            .eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    
    static let sharedImmediateMainQueueScheduler = ImmediateMainQueueScheduler.shared
    
    struct ImmediateMainQueueScheduler: Scheduler {
        
        static let shared = Self()
        
        private init() {}
        
        var now: DispatchQueue.SchedulerTimeType { DispatchQueue.main.now }
        
        var minimumTolerance: DispatchQueue.SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard Thread.isMainThread else {
                return DispatchQueue.main.schedule(options: options, action)
            }

            action()
        }

        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
