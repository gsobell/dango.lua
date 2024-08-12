all: dist

dist:
	zip -r dango.love *.lua assets README.md LICENSE.md
lint:
	luacheck --std love *.lua
format:
	stylua *.lua

run: 
	love ./
