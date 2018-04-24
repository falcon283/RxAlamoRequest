//
//  ApiResponse.swift
//  Gabriele Trabucco
//
//  Created by Gabriele Trabucco on 21/04/2018.
//  Copyright © 2018 Gabriele Trabucco. All rights reserved.
//

import Foundation
import RxAlamofire

public protocol ApiResponseProtocol {
    associatedtype Response
    var result: Response? { get }
    var progress: RxProgress { get }
}

public struct ApiResponse<T>: ApiResponseProtocol {
    public let result: T?
    public let progress: RxProgress
}
