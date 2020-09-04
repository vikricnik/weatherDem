//
//  TargetType.swift
//  weatherDemo
//
//  Created by dies irae on 30/08/2020.
//  Copyright © 2020 dies irae. All rights reserved.
//

import Foundation

protocol TargetType {
    var urlRequest: URLRequest { get }

    var schema: String { get }

    var host: String { get }

    var header: [String: String] { get }

    var body: Data? { get }

    var httpMethod: String { get }

    var path: String { get }

    var queryItems: [URLQueryItem]? { get }

}

extension TargetType {
    var urlRequest: URLRequest {
        var componentes = URLComponents()
        componentes.scheme = schema
        componentes.host = host
        componentes.path = path
        componentes.queryItems = queryItems

        let fullURL = componentes.url!
        var req = URLRequest(url: fullURL,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 120)
        req.httpMethod = httpMethod
        req.httpBody = body
        header.forEach {
            req.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return req
    }
}

