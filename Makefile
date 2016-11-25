%.mp3 : %.wav
	lame -b 192 $< $@

%.mp3 : %.flv
	ffmpeg -i $< $@

# Help
all:
	@echo 'make hoge.mp3  -  convert hoge.xxx to hoge.mp3'
