NAME=datasig

ARCH?=x86

#CFLAGS=-g -Wall -Wa,-ahdlcs=$@.lst $(EXTRA_CFLAGS)
CFLAGS=-g -Werror -Wall $(EXTRA_CFLAGS) -fpack-struct
LDFLAGS=$(EXTRA_LDFLAGS)
GDB=gdb

ifeq ($(ARCH),x86)
EXTRA_CFLAGS=-m32
EXTRA_LDFLAGS=-m32
endif

ifeq ($(ARCH),x86_64)
EXTRA_CFLAGS=-m64
EXTRA_LDFLAGS=-m64
endif

ifeq ($(ARCH),mips)
CC             = /opt/rmi/1.6/mipscross/nptl/bin/mips64-unknown-linux-gnu-gcc
LD             = /opt/rmi/1.6/mipscross/nptl/bin/mips64-unknown-linux-gnu-ld
EXTRA_CPPFLAGS =
EXTRA_CFLAGS   = -mabi=32
EXTRA_LDFLAGS  = -mabi=32
LDLIBS         = -L/opt/rmi/1.6/mipscross/nptl/mips64-unknown-linux-gnu/lib
GDB	       = /opt/rmi/1.6/mipscross/nptl/bin/mips64-unknown-linux-gnu-gdb
endif

ifeq ($(ARCH),arm)
CC             = /opt/ctc/cs8160-sdk-9.0.2.41/bin/arm-openwrt-linux-gcc
LD             = /opt/ctc/cs8160-sdk-9.0.2.41/bin/arm-openwrt-linux-ld
EXTRA_CPPFLAGS =
EXTRA_CFLAGS   = -Werror -D__LITTLE_ENDIAN__ -D_XOPEN_SOURCE -D_GNU_SOURCE  -g -Wall
EXTRA_LDFLAGS  =
LDLIBS         = -L/opt/ctc/cs8160-sdk-9.0.2.41/bin/arm-open/lib
GDB	       = /opt/ctc/cs8160-sdk-9.0.2.41/usr/bin/arm-openwrt-linux-gdb
endif

all: $(NAME) txt md5 crc
all: $(NAME) txt

$(NAME): $(NAME).o

$(NAME).o: Makefile

datasig.o: datasig.c project.h global.h system.h

ifeq (0,1)
$(NAME)-gdb.log: GDB=gdb
$(NAME)-gdb.log: $(NAME) gdbcmd
	$(GDB) --silent -x gdbcmd > $@

$(NAME)-gdb.txt: $(NAME)-gdb.log
	grep -E '^ *(name|tagname|code|length|\[[0-9]+\])' $< | sed 's/(0x[0-9a-fA-F]\+)//g; s/type 0x[0-9a-fA-F]\+//g' > $@
else
$(NAME)-gdb.txt: GDB=gdb
$(NAME)-gdb.txt: $(NAME) cmd.gdb
	$(GDB) --silent -x cmd.gdb > $@
	! grep -s '@@@' $@
endif

$(NAME)-one.txt: $(NAME)-gdb.txt
	cat $< | tr '\r\n' '  ' | tr -s '[:blank:]' ' ' > $@

$(NAME)-gdb.md5: $(NAME)-gdb.txt
	md5sum $< | cut -d' ' -f 1 | xxd -r -p > $@

$(NAME)-one.md5: $(NAME)-one.txt
	md5sum $< | cut -d' ' -f 1 | xxd -r -p > $@

$(NAME)-gdb.crc: $(NAME)-gdb.md5
	crc32 $< > $@

$(NAME)-one.crc: $(NAME)-one.md5
	crc32 $< > $@

txt: $(NAME)-gdb.txt $(NAME)-one.txt
md5: $(NAME)-gdb.md5 $(NAME)-one.md5
crc: $(NAME)-gdb.crc $(NAME)-one.crc

clean:
	-rm -f *.o *.lst *~ $(NAME) $(NAME)-gdb.log $(NAME)-gdb.txt $(NAME)-one.txt $(NAME)-gdb.md5 $(NAME)-one.md5 $(NAME)-gdb.crc $(NAME)-one.crc

.PHONEY: all txt md5 crc clean
