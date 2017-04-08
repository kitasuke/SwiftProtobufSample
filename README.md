# SwiftProtobufSample
Sample project with Protocol Buffers for client/server in Swift

## Sample apps

### Client app

APIClient uses `URLSession` with [swift-protobuf](https://github.com/apple/swift-protobuf)

### Server app

Web framework, [Kitura](http://www.kitura.io/) provides HTTP server with [swift-protobuf](https://github.com/apple/swift-protobuf)

## Requirements

Swift 3.1  
Xcode 8.3    
protoc 3.2  
swift-protobuf 0.9.29  
Kitura 1.3  

## Setup

### Protocol Buffers

Follow [this instruction](https://github.com/google/) to install protoc

### Plugin for Swift

Follow [this instruction](https://github.com/apple/swift-protobuf#build-and-install) to install swift-protobuf

### Code Generator

Run command below to generate swift files from proto files

```
$ make generate
```

### Dependencies

Run command below to install libraries for Server/Client app

```
$ make setup
```

## Usage

### Server app

Run command below to run server app

```
$ make run-server
```

### Client app

Open `Client.xcodeproj` and simply run it.

## Reference

https://developer.ibm.com/swift/2016/09/30/protocol-buffers-with-kitura/
https://github.com/KyoheiG3/ProtobufExample
