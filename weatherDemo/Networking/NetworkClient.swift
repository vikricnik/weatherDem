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

    init(session: URLSession = URLSession(configuration: .default,
                                          delegate: nil,
                                          delegateQueue: OperationQueue())) {
        self.session = session
    }

    func request<D: Decodable>(target: TargetType,
                               decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<D, Error> {
        return session.dataTaskPublisher(for: target.urlRequest)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
            return data
        }
        .decode(type: D.self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func request(target: TargetType) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: target.urlRequest)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
            return data
        }
        .eraseToAnyPublisher()
    }
}
