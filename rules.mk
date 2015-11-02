ARCHIVE_POSTFIX ?=
ARCHIVE ?= $(NAME)$(ARCHIVE_POSTFIX).zip
ARCHIVE_CONTENTS ?=



GENERATED += .gitignore $(ARCHIVE)



all: .gitignore test package

test:
	luacheck
	prove

package: $(ARCHIVE)

clean:
	rm -rf $(GENERATED)

.PHONY: all test package clean
.DEFAULT: all



.gitignore: Makefile
	echo '# FILE IS GENERATED BY MAKE - DO NOT EDIT' > $@
	echo '/config.mk' >> $@
	for file in $(GENERATED) ; do \
		echo /$$file >> $@ ; \
	done

$(ARCHIVE): Makefile $(ARCHIVE_CONTENTS)
	zip --compression-method deflate -9 --suffixes '.png:.ogg' $@ $(ARCHIVE_CONTENTS)

%.json: %.blend
	$(BUILD_TOOLS)/blend2json $< $@

%.png: %.xcf
	$(BUILD_TOOLS)/xcf2png $< $@