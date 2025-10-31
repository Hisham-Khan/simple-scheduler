MEMORY
{
    FLASH : ORIGIN = 0x0, LENGTH = 0x4000       /* 16 KB Flash */
    RAM : ORIGIN = 0x20000000, LENGTH = 0x800   /* 2 KB SRAM */
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > FLASH

    .data : {
        *(.data*)
    } > RAM
}
