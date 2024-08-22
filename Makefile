all: format dist

dist: linux windows macos android

zip:
	zip -r dango.love *.lua assets README.md LICENSE.md

linux: zip

windows: zip
	# @echo "Building target: $@"
	@if [ -e  "love.exe" ]; then cat love.exe dango.love > dango.exe; fi;

macos: zip
	# @echo "Building target: $@"
	@if [ -e  "love.app" ]; then \
		cp love.app dango.app; \
		cp dango.love  dango.app/Contents/Resources/; \
		cat info > dango.app/Contents/Info.plist; \
		zip -y dango.zip; \
	fi
	# @echo "Build complete."

android:

lint:
	luacheck --std love *.lua

format:
	stylua *.lua

run: 
	love ./
