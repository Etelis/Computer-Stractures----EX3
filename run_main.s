	.file	"run_main-test.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1

LC0: .string	"%d"
LC1: .string	"%s"
LC2: .string "\0"

	.text
	.globl	run_main
	.type	run_main, @function

run_main:
    pushq   %rbp
    movq    %rsp,   %rbp
    subq    $528,   %rsp        # Allocate 256x2 for strings + null_chr, 8x2 - for two lens, 8 - to fix stack allignment

    movq    $LC0,   %rdi        # Move format to first arg - rdi.
    xorl    %eax,   %eax        # initialize eax back to zero before going to printf.
    leaq    (%rsp), %rsi   
    call    scanf

    movq    $LC1,   %rdi
    xor     %eax,       %eax     # initialize eax back to zero before going to printf.
    leaq    9(%rsp),    %rsi     # allow 256 bytes for string.
    call    scanf

    leaq    8(%rsp),    %r8
    movq    (%rsp),     %rax
    movb    %al,        (%r8)
    
# second string.
    movq    $LC0,   %rdi          # Move format to first arg - rdi.
    xorl    %eax,   %eax          # initialize eax back to zero before going to printf.
    leaq    264(%rsp), %rsi   
    call    scanf

    movq    $LC1,       %rdi
    xor     %eax,       %eax       # initialize eax back to zero before going to printf.
    leaq    273(%rsp),  %rsi       # allow 256 bytes for string.
    call    scanf

    leaq    272(%rsp),    %r9
    movq    264(%rsp),    %rax
    movb    %al,          (%r9)  


# opt
    movq    $LC0,       %rdi        # Move format to first arg - rdi.
    xorl    %eax,       %eax        # initialize eax back to zero before going to printf.
    leaq    -8(%rbp),   %rsi   
    call    scanf


# call func
    movq    -8(%rbp),    %rdi
    leaq    8(%rsp),     %rsi
    leaq    272(%rsp),   %rdx
    call    run_func

# finish func.
    addq $528, %rsp
    movq %rbp, %rsp
    pop  %rbp
    ret






