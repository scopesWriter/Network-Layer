//
//  ustomInterceptor.swift
//  Banoon
//
//  Created by bishoy on 26/11/2020.
//

import Foundation
import Alamofire

/// Used to handle retrier logic
class CustomInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.retryWithDelay(3))
    }
}

