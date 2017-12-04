
#############
#tools/commands
#############
# CC=gcc
AS=as
LD=ld
GI=genisoimage
OC=objcopy
OD=objdump
#############
#flags
#############
LD_SCRIPT=build.ld
# CC_FLAGS=-ffreestanding
AS_FLAGS=-I $(SRCDIR)
LD_FLAGS=-T$(LD_SCRIPT) --nmagic
GI_FLAGS=-V '$(IMAGE_NAME)' -input-charset iso8859-1
OC_FLAGS=-O binary
OD_FLAGS=-D
#############
#directories
#############
SRCDIR?=src
BUILDDIR=build
LOGDIR=log
ISODIR=$(BUILDDIR)/iso
OBJDIR=$(BUILDDIR)/obj

#############
#suffixes
#############
# C_SRC_SFX=c
S_SRC_SFX=asm
# C_OBJ_SFX=o
S_OBJ_SFX=o
BIN_SFX=bin
IMG_SFX=img
ISO_SFX=iso

#############
#file lists
#############
# C_SOURCES := $(shell find $(SRCDIR) -name '*.$(C_SRC_SFX)')
S_SOURCES := $(shell find $(SRCDIR) -name '*.$(S_SRC_SFX)')
# C_OBJECTS = $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(C_SOURCES:.$(C_SRC_SFX)=.$(C_OBJ_SFX))) 
S_OBJECTS = $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(S_SOURCES:.$(S_SRC_SFX)=.$(S_OBJ_SFX))) 
# OBJECTS=  $(S_OBJECTS) $(C_OBJECTS)

#############
#names
#############
BINARY_NAME?=bootloader
LINKED_OBJ_NAME?=bootloader
IMAGE_NAME?=image
DUMP_NAME=$(LINKED_OBJ_NAME).$(S_SRC_SFX).dump
#############
#files
#############
ISO_FILE=$(BUILDDIR)/$(IMAGE_NAME).$(ISO_SFX)
IMAGE_FILE=$(ISODIR)/$(IMAGE_NAME).$(IMG_SFX)
BINARY_FILE=$(BUILDDIR)/$(BINARY_NAME).$(BIN_SFX)
LINKED_FILE=$(OBJDIR)/$(LINKED_OBJ_NAME).$(S_OBJ_SFX)
DUMPED_FILE=$(LOGDIR)/$(DUMP_NAME)
#############
#make instructions
#############

$(ISO_FILE) : $(IMAGE_FILE)
	$(GI) $(GI_FLAGS) -o $@ -b $(IMAGE_NAME).$(IMG_SFX) -hide $< $(ISODIR)/

$(IMAGE_FILE): $(BINARY_FILE) $(ISODIR)
	dd if=/dev/zero of=$@ bs=1024 count=1440 &&         \
	dd if=$< of=$@ seek=0 count=1 conv=notrunc 

# $(BUILDDIR)/$(BINARY_NAME).$(BIN_SFX): $(OBJECTS)
# 	$(LD) $(LD_FLAGS) $(OBJECTS) -o $@

# $(OBJDIR)/%.$(C_OBJ_SFX): $(SRCDIR)/%.$(C_SRC_SFX)
# 	$(CC) -c $(CC_FLAGS) $< -o $@

$(BINARY_FILE): $(LINKED_FILE) $(DUMPED_FILE)
	$(OC) $(OC_FLAGS)  $<  $@

$(LINKED_FILE): $(S_OBJECTS) $(OBJDIR)
	$(LD) $(LD_FLAGS)  $(S_OBJECTS) -o $@

$(OBJDIR)/%.$(S_OBJ_SFX): $(SRCDIR)/%.$(S_SRC_SFX) $(OBJDIR)
	$(AS) $(AS_FLAGS)  $< -o $@

$(ISODIR):
	mkdir -p $(ISODIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(DUMPED_FILE): $(LINKED_FILE)
	$(OD) $(OD_FLAGS) $< > $@

