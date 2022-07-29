
install:
	swift build -c release
	cp ".build/x86_64-apple-macosx/release/develop-tools" "./dl"
