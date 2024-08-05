##
# MdDoc
# @file
# @version 0.1

TARGET = mddoc
COMPILER = ghc

MDDOC = ./$(TARGET)

HS_FILES = $(shell find . -name '*.hs')
MD_DOC_FILES = $(shell find . -name '*.hs.md')
MD_SRC = $(patsubst %.md,%,$(MD_DOC_FILES))
SRCS = $(sort $(HS_FILES) $(MD_SRC))

TFLAGS =

.PHONY: test default clean bootstrap

default: test

$(MD_SRC): $(MD_DOC_FILES)
	$(MDDOC) $< "--"

$(TARGET): $(SRCS)
	$(COMPILER) --make $^ -o $@

test: $(TARGET)
	./$(TARGET) $(TFLAGS)

bootstrap:
	$(COMPILER) --make mddoc.hs -o $(TARGET)

clean:
	rm *.o *.hi $(TARGET) -rf

# end
