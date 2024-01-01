 // version 1.0 05/22/2022 //
#ifndef MYMAIN_S
#else
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // imports
    #include "main.h"
    #include "rdbuf.h"
    #include "setup.h"
    #include "cipher.h"
    .extern fwrite
    .extern stdin
    .extern stdout
    .extern stderr

    .section .rodata
    // do not change these error messages
.Lbdrd:  .string "%s: read failed\n"
.Lbdwr:  .string "%s: write failed\n"

    .text

    //
    // encrypter [-d | -e] -b bookfile
    //
    // int main(int argc, char **argv)
    // int main(r0=argc, r1=argv)

    .global main
    .type   main, %function

    //
    // stack frame layout
    //
    // PA9: complete the following stack frame design
    // You can change or delete any comments in this file
    //
    .equ    FP_OFF,     32              // fp offset in main stack frame
    .equ    FPBOOK,     4 + FP_OFF      // FILE * to book file
    .equ    IOBUF,      BUFSZ + FPBOOK  // buffer for input file
    .equ    MODE,       4 + IOBUF       // decrypt or encrypt mode
    .equ    BOOKBUF,    BUFSZ + MODE    // buffer for book file
    .equ    ARGV0,      4 + BOOKBUF     // save argv[0] for error printing
    //
    // add your local variables here if you need them:
    // NOTICE: Adjust PAD so FRMADD + FP_OFF + 4 divides by 8 EVENLY!
    //
    .equ    PAD,        0 + ARGV0       // Stack frame PAD
    .equ    OARG5,      4 + PAD         // output arg5 must be at bottom
    .equ    FRMADD,     OARG5-FP_OFF    // space in frame for locals+passed args

    // PA9: list how you are using the preserved registers
    // preserved register use
    // r4 
    // r5 
    // r6 mode flag
    // r7 
    // r8 *argv0
    // r9           
    // r10 cnt

main:
    push    {r4-r10, fp, lr}        // push all the usable preserved registers
    add     fp, sp, FP_OFF          // set frame pointer to frame base
    ldr     r3, =FRMADD             // get space needed for locals+passed args
    sub     sp, sp, r3              // allocate space for locals and passed args 
    ldr     r8, [r1]
    ldr     r7, =ARGV0
    sub     r7,fp,r7
    str     r8, [r7]
    ldr     r2, =MODE
    sub     r2, fp, r2
    ldr     r3, =FPBOOK
    sub     r3, fp, r3
    bl      setup
    cmp     r0, EXIT_FAIL
    bne     .Lloop
    mov     r0, EXIT_FAILURE
    b       .Lexit
.Lloop:
    ldr     r0, =stdin
    ldr     r0, [r0]
    ldr     r1, =FPBOOK
    sub     r1, fp, r1
    ldr     r1, [r1]
    ldr     r2, =BUFSZ
    ldr     r3, =IOBUF
    sub     r3, fp, r3
    ldr     r4, =BOOKBUF
    sub     r4, fp, r4
    ldr     r5, =OARG5
    sub     r5, fp, r5
    str     r4, [r5]
    bl      rdbuf
    cmp     r0, 0
    beq     .Ldone
    cmp     r0, 0
    bgt     .Lmode
    ldr     r1, =.Lbdrd
    b      .Lerror
.Lmode:
    mov     r2, r0
    ldr     r0, =IOBUF
    sub     r0, fp, r0
    ldr     r1, =BOOKBUF
    sub     r1, fp, r1     
    ldr     r6, =MODE
    Sub     r6, fp, r6
    ldr     r6, [r6]
    cmp     r6, ENCRYPT_MODE
    beq     .Lencrypt
    bl      decrypt
    b       .Lfwrite
.Lencrypt:
    bl      encrypt
.Lfwrite:
    mov     r10, r0
    ldr     r0, =IOBUF
    sub     r0, fp, r0
    mov     r1, 1
    mov     r2, r10
    ldr     r3, =stdout
    ldr     r3, [r3]
    bl      fwrite
    cmp     r0, r10
    beq     .Lloop
    ldr     r1, =.Lbdwr
.Lerror:
    ldr     r0, =stderr
    ldr     r0, [r0]
    ldr     r2, =ARGV0
    sub     r2, fp, r2
    ldr     r2, [r2]
    bl      fprintf
    mov     r0, EXIT_FAILURE    
.Ldone:
    mov     r9, r0
    ldr     r0, =FPBOOK
    sub     r0, fp, r0
    ldr     r0, [r0]
    bl      fclose
    mov     r0, r9
.Lexit:
    sub     sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}
    bx      lr

    .size   main, (. - main)
    .section .note.GNU-stack,"",%progbits
.end
#endif
