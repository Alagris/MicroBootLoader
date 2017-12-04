OUTPUT_FORMAT("elf64-x86-64");
/* We define an entry point to keep the linker quiet. This entry point
 * has no meaning with a bootloader in the binary image we will eventually
 * generate. Bootloader will start executing at whatever is at 0x07c00 */
ENTRY(start);
SECTIONS
{
    __screenwidth_ld = 2;
    __screenheight_ld = 23;
    __words_per_line_ld = 15;
    __bytes_per_line_ld = __words_per_line_ld * 2;
    __bytes_per_page_ld = __screenheight_ld  * __bytes_per_line_ld;
    __byte_per_scroll_ld = __bytes_per_page_ld - __bytes_per_line_ld;
    . = 0x7C00;
    .text : {
        /* Place the code in start.o before all other code */
        build/obj/start.o(.text);
        *(.text);
    }

    /* Place the data after the code */
    .data : SUBALIGN(4) {
        *(.data);
        *(.rodata);
    }
    .gdt : {
        __gdt_start_ld = . ;
        __gdt_null_ld = . ;
            LONG(0x0);
            LONG(0x0);
        __gdt_code_ld = . ;
            SHORT(0xffff);
            SHORT(0x0);
            BYTE(0x0);
            BYTE(0x9A);
            BYTE(0xCF);
            BYTE(0x0);
        __gdt_data_ld = . ;
            SHORT(0xffff);
            SHORT(0x0);
            BYTE(0x0);
            BYTE(0x92);
            BYTE(0xCF);
            BYTE(0x0);
        __gdt_end_ld = . ;
        __gdt_descriptor_ld = . ;
            SHORT(__gdt_end_ld - __gdt_start_ld);
            LONG(__gdt_start_ld);
    }
    /* Place the boot signature at VMA 0x7DFE */
    . = 0x7DFE;
    .sig : {
        SHORT(0xaa55);
    }
    /*. = 0x7E00;*/
    .afterboot : {
        *(.afterboot)
    }

    /* Remove sections that won't be relevant to us */
    /DISCARD/ : {
        *(.eh_frame);
        *(.comment);
        *(.note.gnu.build-id);
    }
    . = ALIGN(512);
}