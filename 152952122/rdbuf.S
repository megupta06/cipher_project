#ifndef MYRDBUF_S
#else
// version 1.0 10/12/2022 //
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // global constants
    #include "cipher.h"

    .extern fread
    .extern feof
    .extern ferror
    .text

    // int rdbuf(r0=FILE *in, r1=FILE *fpbook, r2=int cnt, r3=char *iobuf, 
    //            on the stack at ARG5 offset=char *bookbuf)
    // returns number of bytes read EXIT_FAIL otherwise
    // you can change or remove any comments in this file

    .type   rdbuf, %function
    .global rdbuf
    .equ    ARG5,  4 
    .equ    FP_OFF, 28
 
rdbuf:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF

    /* r4 has *in
     * r5 has *fpbook
     * r6 has cnt, bytes
     * r7 has r3 *iobuf
     */
    mov     r4, r0
    mov     r5, r1
    mov     r6, r2
    mov     r7, r3 
    bl      feof
    cmp     r0, 0
    bne     .return0
    // Check for read errors
    mov     r0, r4
    bl      ferror
    cmp     r0, 0
    bne     .returnerror

    //Call fread
    mov     r0, r7
    mov     r1, 1
    mov     r2, r6
    mov     r3, r4
    bl      fread
    cmp     r0, 0
    ble     .return0

    //Call fwrite
    mov     r6, r0
    ldr     r0, =ARG5
    add     r0, fp, r0
    ldr     r0, [r0]
    mov     r1, 1
    mov     r2, r6
    mov     r3, r5 
    bl      fread
    cmp     r0, r6
    bne     .returnerror
    b       .Ldone  
.return0:
    mov     r0, 0
    b       .Ldone

.returnerror:
    mov     r0, EXIT_FAIL     
    
.Ldone:
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size   rdbuf, (. - rdbuf)
    .section .note.GNU-stack,"",%progbits
.end
#endif
