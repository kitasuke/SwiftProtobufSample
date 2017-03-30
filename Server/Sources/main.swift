import Kitura
import SwiftProtobuf
import Foundation

enum AcceptType: String {
    case protobuf = "application/protobuf"
    case json = "application/json"
}

private let router = Router()

// returns array of talk information
router.get("/v1/talks") { request, response, next in
    
    // unsupported accept type
    guard let acceptHeader = request.headers["Accept"],
        let acceptType = AcceptType(rawValue: acceptHeader) else {
            return
    }
    
    // make TalkResponse value
    let data = TalkResponse.with { response in
        let user = User.with {
            $0.id = 1
            $0.type = .speaker
            $0.name = "kitasuke"
            $0.introduction = "Yusuke is an iOS developer at Mercari in San Francisco. He has been working on internationalization of Mercari app in iOS team. he is passionate about learning new technology in iOS. When not coding, you can find him cycling."
            $0.photoURL = "https://res.cloudinary.com/skillsmatter/image/upload/c_crop,g_custom/c_scale,w_96,h_96/v1483978529/zebllx0e1udrvjl1twp3.jpg"
        }
        
        let talk = Talk.with {
            $0.id = 1
            $0.title = "Type-safe Web APIs with Protocol Buffers in Swift"
            $0.desc = "Apple recently open sourced swift-protobuf which is a plugin of Protocol Buffers for swift language. Protocol Buffers enables us to have type safety, make API faster and unify schema of structured data. JSON used to be a reasonable way for Web APIs in most cases, but Protocol Buffers could be another option if we consider these benefits. In this talk, you'll discover examples of usage with swift-protobuf in server and client apps. Yusuke will also highlight pros and cons compare to JSON based on his knowledge and experiences."
            $0.speaker = user
            $0.tags = ["swift", "iOS", "protocol-buffers", "ioscon", "type-safe"]
        }
        
        response.talks = [talk]
    }
    print(data)
    
    // send serialized data to client
    response.headers["Content-Type"] = acceptType.rawValue
    switch acceptType {
    case .protobuf:
        response.send(data: try data.serializedData())
    case .json:
        response.send(try data.jsonString())
    }
    
    next()
}

// returns error(.badRequest)
router.post("/v1/like") { request, response, next in
    var body = Data()
    
    // unsupported accept type
    guard let acceptHeader = request.headers["Accept"],
        let acceptType = AcceptType(rawValue: acceptHeader) else {
            return
    }
    
    // desealize to LikeRequest type
    guard let bytes = try? request.read(into: &body),
        let likeRequest = try? LikeRequest(serializedData: body) else {
        return
    }
    
    // make NetworkError value
    let error = NetworkError.with {
        $0.code = .badRequest
        $0.message = "Not implemented"
    }
    print(error)
    
    // send serialized data to client
    response.headers["Content-Type"] = acceptType.rawValue
    switch acceptType {
    case .protobuf:
        response.status(.badRequest).send(data: try error.serializedData())
    case .json:
        response.status(.badRequest).send(try error.jsonString())
    }
    
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

