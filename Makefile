
install:
	swift build -c release
	install .build/release/develop-tools /usr/local/bin/dl
