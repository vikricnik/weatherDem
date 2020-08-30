//
//  NetworkClient.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation
import Combine

class NetworkClient {
    let session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func request<D: Decodable>(target: TargetType,
                               decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<D, Error> {
        return session.dataTaskPublisher(for: target.urlRequest)
        .tryMap { result in
            return try decoder.decode(D.self, from: result.data)
        }
        .eraseToAnyPublisher()
    }
}
