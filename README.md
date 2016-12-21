# SwiftProtobufSample
Sample project for client/server in Swift with Protocol Buffers

See also [this sample app](https://github.com/kitasuke/SwiftProtobufSample) using [APIKit](https://github.com/ishkawa/APIKit) whice is type-safe network layer library

## Sample app

### Client side

APIClient uses `URLSession` with [swift-protobuf](https://github.com/apple/swift-protobuf)

### Server side

Web framework, [Kitura](http://www.kitura.io/) provides HTTP server with [swift-protobuf](https://github.com/apple/swift-protobuf) 

## Usage

### Install protobuf

Follow [this instruction](https://github.com/apple/swift-protobuf#build-and-install)

Generate Swift output then

```
$ cd protos
$ protoc --swift_out=. *.proto
```

### Server app
```
$ cd Server
$ swift build
$ ./.build/debug/Server
```

Generate xcode project if needed

```
$ swift package generate-xcodeproj
```

### Client app

```
$ cd Client
$ carthage update
```

Open and Run `Client.xcodeproj`

### Docs

Markdown

```
$ cd protos
$ protoc --doc_out=markdown,docs.md:. protos/*.proto
```

Install `protoc-gen-doc` in case you don't have it

```
$ brew install qt5
$ brew link --force qt5
$ git clone https://github.com/estan/protoc-gen-doc.git
$ cd protoc-gen-doc
$ PROTOBUF_PREFIX=/usr/local/Cellar/protobuf/3.1.0 qmake
$ make && make install
```

## Reference

https://github.com/KyoheiG3/ProtobufExample
