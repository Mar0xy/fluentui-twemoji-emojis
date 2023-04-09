.PHONY: png
png: fluentui-emoji convert/svg2png
	./convert/convert.sh

convert/svg2png: convert/src/svg2png/*
	cd ./convert/src/svg2png; go build -o ../../svg2png

fluentui-emoji:
	git clone --depth=1 https://github.com/microsoft/fluentui-emoji.git
