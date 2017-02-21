//
//  APIClient.swift
//  Client
//
//  Created by Yusuke Kita on 12/18/16.
//  Copyright © 2016 Yusuke Kita. All rights reserved.
//

import Foundation
import SwiftProtobuf

class APIClient {
    let baseURL: URL
    let contentType: ContentType
    
    enum ContentType: String {
        case protobuf = "application/protobuf"
        case json = "application/json"
        
        var headers: [String: String] {
            return [
                "Accept":        rawValue,
                "Content-Type":  rawValue,
            ]
        }
    }
    
    init(baseURL: URL = URL(string: "http://localhost:8090")!, contentType: ContentType) {
        self.baseURL = baseURL
        self.contentType = contentType
    }
    
    func talks(success: @escaping ((TalkResponse) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        get(path: "/v1/talks", success: success, failure: failure)
    }
    
    func like(body: LikeRequest, success: @escaping ((LikeResponse) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        post(path: "/v1/like", body: body, success: success, failure: failure)
    }
    
    private func get<Response: SwiftProtobuf.Message>(path: String, success: @escaping ((Response) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = contentType.headers
        response(from: request, success: success, failure: failure)
    }
    
    private func post<Body: SwiftProtobuf.Message, Response: SwiftProtobuf.Message>(path: String, body: Body, success: @escaping ((Response) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = contentType.headers
        request.httpBody = try! body.serializeProtobuf()
        
        response(from: request, success: success, failure: failure)
    }
    
    private func response<Response: SwiftProtobuf.Message>(from request: URLRequest, success: @escaping ((Response) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            guard let data = data,
                let urlResponse = urlResponse as? HTTPURLResponse,
                let type = urlResponse.allHeaderFields["Content-Type"] as? String,
                let contentTpye = ContentType(rawValue: type) else {
                    
                DispatchQueue.main.async {
                    failure(NetworkError())
                }
                return
            }
            
            guard 200..<300 ~= urlResponse.statusCode else {
                let error: NetworkError
                switch contentTpye {
                case .protobuf:
                    error = try! NetworkError(protobuf: data)
                case .json:
                    let json = String(data: data, encoding: .utf8)!
                    error = try! NetworkError(json: json)
                }
                failure(error)
                return
            }
            
            DispatchQueue.main.async {
                let response: Response
                switch contentTpye {
                case .protobuf:
                    response = try! Response(protobuf: data)
                case .json:
                    let json = String(data: data, encoding: .utf8)!
                    response = try! Response(json: json)
                }
                success(response)
            }
        }
        task.resume()
    }
}
