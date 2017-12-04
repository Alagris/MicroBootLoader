KERNEL_BUILD_PARAMS=IMAGE_NAME=kernel SRCDIR=kernel

build:
	make -f build.mk

kernel:
	make $(KERNEL_BUILD_PARAMS) -f build.mk

rebuild:
	make -B -f build.mk

rebuild_kernel:
	make $(KERNEL_BUILD_PARAMS) -B -f build.mk
	
dry:
	make -n -f build.mk

dry_kernel:
	make $(KERNEL_BUILD_PARAMS) -n -f build.mk

clean:
	rm -rf build/*