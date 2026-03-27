SCHEME   = Cafezinho
PROJECT  = Cafezinho.xcodeproj
BUILD_DIR = build
APP      = $(BUILD_DIR)/Build/Products/Release/Cafezinho.app
INSTALL_DIR = /Applications

.PHONY: build install clean

build:
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Release \
		-derivedDataPath $(BUILD_DIR) \
		CODE_SIGN_IDENTITY="-" \
		| grep -E "(error:|warning:|BUILD|SUCCEED|FAILED)"

install: build
	cp -R "$(APP)" "$(INSTALL_DIR)/Cafezinho.app"
	@echo "Installed to $(INSTALL_DIR)/Cafezinho.app"

clean:
	rm -rf $(BUILD_DIR)
