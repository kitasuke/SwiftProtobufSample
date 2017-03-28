proto:
	cd protos; protoc --swift_out=. *.proto
	
setup:
	cd Server; swift package update; swift package generate-xcodeproj
	cd Client; carthage bootstrap --platform iOS --no-use-binaries

run-server:
	cd Server; swift build; .build/debug/Server
