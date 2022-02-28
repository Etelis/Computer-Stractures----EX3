	.file	"func_select.s"
    .data
    .align	8

	.section	.rodata
result_50_60:	.string	"first pstring length: %d, second pstring length: %d\n"	 # String - result for codition 50/60
result_52:	    .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"	 # String - result for codition 52
result_53_54:	.string "length: %d, string: %s\n"	                                         # String - result for codition 53/54
result_55:	    .string	"compare result: %d\n"                                             	 # String - result for codition 54
result_in:	    .string	"invalid option!\n"                                               	 # String - result for codition invalid
scan_char:      .string "%s"
scan_int:       .string	"%d"

  .text
  .globl run_func
  .extern pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp, scanf, printf

.L10:
    .quad .L4 # Case 100: loc_A.
    .quad .L3 # Case 101: loc_def
    .quad .L5 # Case 102: loc_B
    .quad .L6 # Case 103: loc_C
    .quad .L7 # Case 104: loc_D
    .quad .L8 # Case 104: loc_D


.L4:    # Case 50 / 60
    xorq    %rax,   %rax        # rax = 0, for pstrlen function.
    movq    %rsi,   %rdi        # move &opt1 to first argument for function.   
    call    pstrlen             # arguments: %rdi - &pstr. - return value: len
    movq    %rdx,   %rdi        # move &p2 to arg 1 for pstrlen fucntion.
    movq    %rax,   %rsi        # move len from pstrlen to rcx save argument.
    xorq    %rax,   %rax        # rax = 0, for prstlen function.
    call    pstrlen
    movq    %rax,   %rdx        # move len from pstrlen to rsi (for printf fucntion)
    xorq    %rax,   %rax        # rax = 0, for printf function.
    movq    $result_50_60,  %rdi    # move result format for printf.
    call    printf
    jmp .L11                      # Goto done



.L3:
    subq    $8,  %rsp               # fix allingment for printf.
    movq    $result_in,   %rdi      # other wise the opt entered is wrong, print message and finish.
    call    printf
    addq    $8,  %rsp               # return to previous.


    # Return:
.L11:
    popq    %rsi
    popq    %rdx                # restore calle registrers.
    popq    %rdi
    movq    %rbp,   %rsp        # restoring the old stack pointer.
    popq    %rbp                # restoring the old frame pointer.
    ret                         # returning to the function that called us.


.L5:    # Case 52:
    subq      $8,          %rsp       # allocate 8 bytes for scanf. - keep stack line asignment
    lea       scan_char(%rip), %rdi   # efficient format loading to rdi.
    xorq      %rax,        %rax       # rax = 0, for scanf function.
    leaq      (%rsp),      %rsi       # set storage to local variable
    call      scanf

    lea       scan_char(%rip), %rdi   # efficient format loading to rdi.
    xorq      %rax,        %rax       # rax = 0, for scanf function.
    subq      $16, %rsp               # allocate 8 bytes for scanf. - keep stack line asignment
    leaq      8(%rsp),     %rsi       # set storage to local variable
    call      scanf

    addq      $8,         %rsp        # move rsp back toward the second scanf value, jump over ret addy.
    movzbq    (%rsp),     %rdx        # set rdx to new char.
    movzbq    8(%rsp),    %rsi        # set rsi to old char             Replace first string.

    movq      16(%rsp),   %rdi        # set rdi back to point at first addy op1.
    xorq      %rax,       %rax        # rax = 0, for replaceChar function.
    call      replaceChar
    pushq     %rax                    # rax will now hold the &p1 - push rax to stack.

    movzbq    8(%rsp),     %rdx       # set rdx to new char.
    movzbq    16(%rsp),    %rsi       # set rsi to old char             Replace first string.
    mov       32(%rsp),    %rdi       # set rdi back to point at secon addy op2.
    xorq      %rax,        %rax       # rax = 0, for replaceChar function.
    call      replaceChar             # rax now hold &p2

    popq      %rcx                    # pop first modified string to rcx (forth arg to printf)
    leaq      1(%rcx),   %rcx         # move toward string, skip len.
    leaq      1(%rax),   %r8          # move second modified string to r8(fifth arg to printf)
    xorq      %rax,   %rax            # rax = 0, for scanf function.
    movq      $result_52,  %rdi       # move result format for printf.
    popq      %rdx                    # pop new char to rdx (third argument for printf)
    popq      %rsi                    # pop old char to rsi (second argument for printf.)
    call      printf
    jmp .L11                           # Goto done


.L6:    # Case 53

    subq    $8,          %rsp       # allocate 8 bytes for scanf. - keep stack line asignment
    lea     scan_int(%rip), %rdi    # efficient format loading to rdi.
    xorq    %rax,        %rax       # rax = 0, for scanf function.
    leaq    (%rsp),      %rsi       # set storage to local variable
    call    scanf

    lea     scan_int(%rip), %rdi    # efficient format loading to rdi.
    xorq    %rax,        %rax       # rax = 0, for scanf function.
    subq    $16, %rsp               # allocate 8 bytes for scanf. - keep stack line asignment
    leaq    8(%rsp),     %rsi       # set storage to local variable
    call    scanf

    addq    $8,          %rsp       # move rsp back toward the second scanf value, jump over ret addy.
    popq    %rcx                    # save to rcx index end j.
    popq    %rdx                    # save to rdx index start i.
    movq    (%rsp),      %rdi       # save op1 to first arg 
    movq    8(%rsp),     %rsi       # save op2 to second arg
    xorq    %rax,        %rax       # rax = 0, for pstrijcpy function.
    call    pstrijcpy

    movq    %rax,        %rdi       # move &op1 to arg 1 for pstrlen fucntion.
    call    pstrlen
    movq    %rax,        %rsi       # move len from pstrlen to correct arg.
    movq    (%rsp),      %rdx       # move &op1 to arg 1 for printf fucntion.
    inc     %rdx
    xorq    %rax,        %rax       # rax = 0, for printf function.
    movq    $result_53_54, %rdi     # move result format for printf.
    call    printf

    movq    8(%rsp),      %rdi      # move &op2 to arg 1 for pstrlen fucntion.
    call    pstrlen
    movq    %rax,        %rsi       # move len from pstrlen to correct arg.
    movq    8(%rsp),     %rdx       # move &op2 to arg 1 for printf fucntion.
    inc     %rdx                    # skip len by incrementing by 1.
    xorq    %rax,        %rax       # rax = 0, for printf function.
    movq    $result_53_54,  %rdi   # move result format for printf.
    call    printf

    jmp .L11                   # Goto done


.L7:    # Case 54:
    push    %r12                    # push %r12 calle-saved register  - will be used to hold pstr len.
    movq    8(%rsp),   %rdi         # move &op1 to arg 1 for swapCase fucntion.
    call    pstrlen
    movq    %rax,       %r12        # len of op1
    call    swapCase                # arguments: %rdi - &pstr, return value: &pstr.

    movq    %r12,       %rsi        # move len to %rsi - second printf argument.
    leaq    1(%rax),    %rdx        # returned address to print.
    xorq    %rax,       %rax        # rax = 0, for printf function.
    lea     result_53_54(%rip), %rdi   # efficient format loading to rdi.

        # length: %d, string: %s\n"
    call    printf

    movq    16(%rsp),   %rdi        # move &op2 to arg 1 for pstrlen fucntion.
    call    pstrlen
    movq    %rax,       %r12        # len of op2
    call    swapCase

    movq    %r12,       %rsi        # move len to %rsi - second printf argument.
    leaq    1(%rax),    %rdx        # returned address to print.
    xorq    %rax,       %rax        # rax = 0, for printf function.
    lea  result_53_54(%rip), %rdi   # efficient format loading to rdi.

        # length: %d, string: %s\n"
    call    printf
    pop     %r12                    # restore calle-saved register.

    jmp .L11                         # Goto done


.L8:    # Case 55

    subq    $8,          %rsp       # allocate 8 bytes for scanf. - keep stack line asignment
    lea     scan_int(%rip), %rdi    # efficient format loading to rdi.
    xorq    %rax,        %rax       # rax = 0, for scanf function.
    leaq    (%rsp),      %rsi       # set storage to local variable
    call    scanf

    lea     scan_int(%rip), %rdi    # efficient format loading to rdi.
    xorq    %rax,        %rax       # rax = 0, for scanf function.
    subq    $16, %rsp               # allocate 8 bytes for scanf. - keep stack line asignment
    leaq    8(%rsp),     %rsi       # set storage to local variable
    call    scanf

    addq    $8,          %rsp       # move rsp back toward the second scanf value, jump over ret addy.
    popq    %rcx                    # save to rcx index end j.
    popq    %rdx                    # save to rdx index start i.
    movq    (%rsp),      %rdi       # save op1 to first arg 
    movq    8(%rsp),     %rsi       # save op2 to second arg
    xorq    %rax,        %rax       # rax = 0, for pstrijcpy function.
    call    pstrijcmp               # arguments - %rdi - &opt1, %rsi - &opt2, %rdx - start index, %rcx - end index. -- return value: 1(pstr1 >pstr 2), -1(pstr2 > pstr1), 0(equal)
    movq    %rax,        %rsi
    xorq    %rax,        %rax       # rax = 0, for printf function.

        # "compare result: %d\n"
    movq    $result_55,   %rdi      # move result format for printf.
    call    printf

    jmp .L11                         # Goto done


.L9:    # compare for opt = 60
    cmpq    $10, %rcx               # compare xi:10
    je      .L4                     # check if opt send was 60.
    jmp     .L3


	.globl	run_main
	.type	run_main, @function


    # %rdi - switch number, %rsi - &op1, %rdx - &op2.
    .type run_func, @function
run_func:
    pushq   %rbp
    movq    %rsp,  %rbp
    pushq   %rdi
    pushq   %rdx              # Save calle registers before calling an outer function.
    pushq   %rsi  

    # Set up the jump table access
    leaq -50(%rdi), %rcx        # Compute xi = x-50
    cmpq $5,%rcx                # Compare xi:5
    ja .L9                      # if >, goto default-case
    jmp *.L10(,%rcx,8)          # Goto jt[xi]
