//
//  ApiRequest.swift
//  Gabriele Trabucco
//
//  Created by Gabriele Trabucco on 21/04/2018.
//  Copyright © 2018 Gabriele Trabucco. All rights reserved.
//

import Foundation
import Alamofire

public let defaultStatusCodes: Set<Int> = {
    let statuses = 200 ..< 300
    return Set(statuses)
}()

public protocol ApiRequest {
    var destination: URLConvertible { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var validStatusCode: Set<Int> { get }
    var validContentType: Set<String> { get }
    var parameters: [String: Any]? { get }
    var decoder: DecoderObject { get }
}

extension ApiRequest {
    public var method: HTTPMethod { return .get }
    public var validStatusCode: Set<Int> { return defaultStatusCodes }
    public var parameters: [String: Any]? { return nil }
}

public protocol JSONApiRequest: ApiRequest { }

extension JSONApiRequest {
    public var validContentType: Set<String> { return ["text/json", "application/json"] }
    public var decoder: DecoderObject { return JSONDecoder() }
}

public protocol DecoderObject {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: DecoderObject { }
