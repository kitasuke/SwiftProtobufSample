import Kitura
import SwiftProtobuf
import Foundation

enum Accept: String {
    case protobuf = "application/protobuf"
    case json = "application/json"
    
}

private let router = Router()

router.get("/v1/talks") { request, response, next in
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
            $0.title = "Type-safe API call with Protocol Buffers in Swift"
            $0.desc = "Apple recently open sourced swift-protobuf which is a plugin of Protocol Buffers for swift language. Protocol Buffers enables us to have type safety, make API faster and unify schema of structured data. JSON used to be a reasonable way for API call in most cases, but Protocol Buffers could be another option if we consider these benefits. In this talk, you'll discover examples of usage with swift-protobuf in server and client apps. Yusuke will also highlight pros and cons compare to JSON based on his knowledge and experiences."
            $0.speaker = user
            $0.tags = ["swift", "iOS", "protocol-buffers", "ioscon", "type-safe"]
        }
        
        response.talks = [talk]
    }
    
    print(data)
    
    guard let acceptHeader = request.headers["Accept"],
        let accept = Accept(rawValue: acceptHeader) else {
        return
    }
    
    response.headers["Content-Type"] = accept.rawValue
    switch accept {
    case .protobuf:
        response.send(data: try data.serializeProtobuf())
    case .json:
        response.send(try data.serializeJSON())
    }
    
    next()
}

router.post("/v1/like") { request, response, next in
    var body = Data()
    
    guard let bytes = try? request.read(into: &body),
        let token = try? LikeRequest(protobuf: body) else {
        return
    }
    
    let error = NetworkError.with {
        $0.code = .badRequest
        $0.message = "Not implemented"
    }
    
    print(error)
    
    guard let acceptHeader = request.headers["Accept"],
        let accept = Accept(rawValue: acceptHeader) else {
            return
    }
    
    response.headers["Content-Type"] = accept.rawValue
    switch accept {
    case .protobuf:
        response.status(.badRequest).send(data: try error.serializeProtobuf())
    case .json:
        response.status(.badRequest).send(try error.serializeJSON())
    }
    
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

