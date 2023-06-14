.PHONY: png
png: fluentui-emoji
	./convert/convert.sh

fluentui-emoji:
	git clone --depth=1 https://github.com/microsoft/fluentui-emoji.git
