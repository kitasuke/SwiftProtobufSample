generate:
	cd protos; protoc --swift_out=. *.proto
	cp protos/*.pb.swift Server/Sources/
	cp protos/*.pb.swift Client/Client/

setup:
	cd Server; swift package update; swift package generate-xcodeproj
	cd Client; carthage bootstrap --platform iOS --no-use-binaries --cache-builds

run-server:
	cd Server; swift build; .build/debug/Server
