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
    
    init(baseURL: URL = URL(string: "http://localhost:8090")!) {
        self.baseURL = baseURL
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
        
        response(from: request, success: success, failure: failure)
    }
    
    private func post<Body: SwiftProtobuf.Message, Response: SwiftProtobuf.Message>(path: String, body: Body, success: @escaping ((Response) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! body.serializeProtobuf()
        
        response(from: request, success: success, failure: failure)
    }
    
    private func response<Response: SwiftProtobuf.Message>(from request: URLRequest, success: @escaping ((Response) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(NetworkError())
                }
                return
            }
            
            guard let urlResponse = urlResponse as? HTTPURLResponse,
                200..<300 ~= urlResponse.statusCode else {
                    failure(try! NetworkError(protobuf: data))
                    return
            }
            
            DispatchQueue.main.async {
                success(try! Response(protobuf: data))
            }
        }
        task.resume()
    }
}
