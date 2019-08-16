//
//  HttpClient.swift
//  Acmeflix
//
//  Created by Manish Katoch on 04/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

typealias onResourceDownloadSuccess<T> = (Resource<T>?) -> Void where T : Decodable
typealias onResourceDownloadFailure = (HttpResponseCode) -> Void


typealias HttpRequestBody = [String: DecodableValueType]

// MARK: - Basic set of response codes required for example. Not exhaustive -
enum HttpResponseCode : Int {
    case OK = 200,
    CREATED = 201,
    UPDATE_SUCCESSFUL = 204,
    UNKNOWN_ERROR = 500,
    NOT_FOUND = 404,
    EMPTY_RESOURCE = 1000
    
    func isFailure() -> Bool {
        return [404,500].contains(self.rawValue)
    }
}

// MARK: - Basic set of Verbs required for the example. Not exhaustive -
enum HttpMethod : String, Decodable {
    case GET, PUT, POST, DELETE
}


// MARK: - RESTful Client -
final class RestfulClient: RestfulNetworking {
    private var requestCounter: Int = 0
    private let session: URLSession
    
    static let shared = RestfulClient()
    
    private init(session: URLSession) {
        self.session = session
    }
    
    private convenience init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.init(session: URLSession(configuration: configuration))
    }
    
    func request<T>(_ link: Link, withBody body: [String: Any]? = nil, _ onSuccess: @escaping onResourceDownloadSuccess<T>, _ onFailure: @escaping onResourceDownloadFailure) where T : Decodable {
        let decodableBody = body?.mapValues {DecodableValueType.from($0)}
        
        self.request(link.url, link.method, body: decodableBody ?? link.bodyJson) { (data, status) in
            if status.isFailure() {
                DispatchQueue.main.async {
                    onFailure(status)
                }
            } else {
                DispatchQueue.main.async {
                    onSuccess(parse(type: Resource<T>.self, data: data))
                }
            }
        }
    }
    
    func requestRaw(_ link: Link, withBody body: [String: Any]? = nil,
                    onCompletion: ((Data, HttpResponseCode) -> Void)? = nil) {
        let decodableBody = body?.mapValues {DecodableValueType.from($0)}
        
        request(link.url, link.method, body: decodableBody ?? link.bodyJson) { (data, status) in
            onCompletion?(data, status)
    }
    }
    
    private func request(_ url: String, _ method: HttpMethod = HttpMethod.GET,  body: HttpRequestBody? = nil,
                         completion: @escaping (Data, HttpResponseCode) -> Void)
    {
        requestCounter += 1
        let reqNumber = requestCounter
        logRequest(reqNumber, method, url, "BODY:", body as Any)
        if let url = URL(string: url) {
            let request = makeUrlRequest(url: url, method: method, body: body)
            let dataTask = self.session.dataTask(with: request) { data, response, error in
                if let errorReturned = error as NSError? {
                        var errorCode: HttpResponseCode = .UNKNOWN_ERROR
                        if errorReturned.code == NSURLErrorCannotConnectToHost{
                            errorCode = .NOT_FOUND
                        }
                        completion(Data(), errorCode)
                        self.logResponse(reqNumber, HTTPURLResponse.init(), error: errorReturned)
                    }
                if let responseUnwrapped = response as? HTTPURLResponse , let dataUnwrapped = data {
                        let status = HttpResponseCode(rawValue: responseUnwrapped.statusCode) ?? HttpResponseCode.UNKNOWN_ERROR
                        self.logResponse(reqNumber, responseUnwrapped, data: dataUnwrapped)
                        DispatchQueue.main.async {
                            completion(dataUnwrapped , status)
                        }
                }
            }
            dataTask.resume()
        }
    }
    
    // MARK: - Poor man's logger -
    private func log(_ msgs: [Any]) {
        let prefix = "[HTTPClient]"
        let msgString = msgs.map { (msgPart) -> String in
            switch msgPart {
            case is String: return msgPart as! String
            default: return String(describing: msgPart)
            }
            }.joined(separator: " ")
        print("\(prefix)\(msgString)")
    }
    private func logRequest(_ reqNumber: Int, _ msg: Any...) {
        log(["[REQUEST #\(reqNumber)]:"] + msg)
    }
    private func logResponse(_ reqNumber: Int, _ response: HTTPURLResponse, data: Data? = nil, error: NSError? = nil) {
        let contentType = response.allHeaderFields["Content-Type"] as? String ?? "UNDEF"
        let dataString = contentType.contains("json") ? String(data: data ?? Data(), encoding: .ascii) : "[IMAGE]"
    
        log(["[RESPONSE #\(reqNumber)]:","Content-Type=\(contentType)", dataString as Any])
    }
}
