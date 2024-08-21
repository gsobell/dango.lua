all: format dist

dist: linux windows android

linux:
	zip -r dango.love *.lua assets README.md LICENSE.md

windows: linux
	if [ -e  "love.exe" ]; then
	cat love.exe dango.love > dango.exe
	fi

android:

lint:
	luacheck --std love *.lua

format:
	stylua *.lua

run: 
	love ./
