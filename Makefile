# Flash Component Compiler
FCC := compc
OUT := as3-airbrake.swc

all:
	$(FCC) -source-path ./ -include-sources ./com/cleversoap/airbrake -optimize -output ./bin/$(OUT)
