all: format dist

dist: linux windows android

linux:
	zip -r dango.love *.lua assets README.md LICENSE.md
windows:

android:

lint:
	luacheck --std love *.lua
format:
	stylua *.lua

run: 
	love ./
