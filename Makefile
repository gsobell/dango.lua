all: dist

dist:
	zip -r dango.love *.lua assets README.md LICENSE.md

format:
	stylua *.lua

run: 
	love ./
