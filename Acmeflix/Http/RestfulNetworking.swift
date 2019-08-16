//
//  RestfulNetworking.swift
//  Acmeflix
//
//  Created by Manish Katoch on 07/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

protocol RestfulNetworking {
    func request<T>(_ link: Link, withBody body: [String: Any]?, _ onSuccess: @escaping onResourceDownloadSuccess<T>, _ onFailure: @escaping onResourceDownloadFailure) where T : Decodable
}

extension RestfulNetworking {
    func makeUrlRequest(url: URL, method: HttpMethod, body: HttpRequestBody? = nil) -> URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let bodyUnwrapped = body {
            return addBody(request: request, body: bodyUnwrapped)
        }
        return request
    }
    
    private func addBody(request: URLRequest, body: HttpRequestBody) -> URLRequest {
        let dict =  body.mapValues { (decodableValueType) -> Any in
            decodableValueType.getValue()
        }
        var mutableRequest = request
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: [])
        return mutableRequest
    }
}

