//
//  Service.swift
//  Nexi
//
//  Created by Gabriele Trabucco on 20/04/2018.
//  Copyright © 2018 Nexi. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

open class Service {

    open private(set) lazy var manager: SessionManager = { SessionManager.default }()

    private var decodeQueue = DispatchQueue.init(label: "rx.alamorequest.decode", attributes: .concurrent)

    public func make<T: Decodable>(_ request: ApiRequest, for type: T.Type) -> Observable<ApiResponse<T>> {

        let decodeQueue = self.decodeQueue

        return manager.rx
            .request(request.method,
                     request.destination,
                     parameters: request.parameters,
                     headers: request.headers)
            .validate(statusCode: request.validStatusCode)
            .validate(contentType: request.validContentType)
            .flatMapLatest { response -> Observable<ApiResponse<T>> in
                let data = response.rx.data()
                    .observeOn(ConcurrentDispatchQueueScheduler(queue: decodeQueue))
                    .map { try request.decoder.decode(T.self, from: $0) }

                let progress = response.rx.progress()

                return Observable.combineLatest(data, progress)
                    .map { ApiResponse(result: $0, progress: $1) }
            }
            .observeOn(MainScheduler.instance)
    }
}
