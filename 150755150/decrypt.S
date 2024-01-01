#ifndef MYDECRYPT_S
#else
// version 1.0 11/12/2022
    .arch armv6
    .arm
    .fpu vfp
    .syntax unified

    #include "cipher.h"

    .text     // start of text segment

    //////////////////////////////////////////////////
    // int decrypt(char *iobuf, char *bookbuf, int cnt)
    // decrypts iobuf using bookbuf; result in iobuf
    //////////////////////////////////////////////////
    .global decrypt
    .type   decrypt, %function
    .equ    FP_OFF, 28

decrypt:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF
    // do not alter anything above this line
    // r0 contains char *iobuf
    // r1 contains char *bookbuf
    // r2 contains cnt
    // r3 is i (index used in outer loop)
    // r4-r9 preserved registers are ok to use
    // r4 is unsigned int bookbuf
    // r5 is unsigned int iobuf
    // r6 is the book buffer (buftemp)
    // r7 is j (index used in the inner loop)
    // r8 is a register to hold a subtraction
    // r9 is the result (res)

    cmp     r2, 0               // if buffer empty we are done
    ble     .Ldone
	mov r6,0
	mov r3,0      /* i=0*/
/* this loop goes through all the characters in iobuf*/
.Lforouter:
    mov r9,0      /* res=0*/
    ldrb r5, [r0,r3]
    ldrb r4, [r1,r3]
    eor r5,r5,r4
    mov r7,0     /* j=0*/
/* this loop goes through all the bits in character*/
.Lforinner:
    lsr r6,r5,r7  /* shift the bits to the left*/
    and r6,r6,1
    rsb r8, r7,7  
    lsl r6,r6,r8  /* shift the bits to right*/
    add r9,r9,r6
    add r7,r7,1  /* increment j by 1*/
    cmp r7,8
    blt .Lforinner
    strb r9, [r0,r3]
    add r3,r3,1  /* increment i by 1*/
    cmp r3,r2
    blt .Lforouter

    // do not alter anything below this line
.Ldone:
    mov     r0, r2              // return cnt processed
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size decrypt, (. - decrypt)
    .section .note.GNU-stack,"",%progbits
.end
#endif
