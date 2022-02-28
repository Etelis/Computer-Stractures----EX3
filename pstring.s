	.file	"pstring.s"

  	.data
  	.align	8
	.section	.rodata
result_invalid:	.string	"invalid input!\n"	 # String - invalid error.
	

	.text	# The beginning of the code.

	.globl	pstrlen
	.type	pstrlen, @function


pstrlen:    # return the size of the pstr sent. --- %rdi - &pstring.
    movzbq	(%rdi),     %rax    # move len to return value.
	ret	


	.globl	pstrijcpy
  	.type pstrijcpy @function

pstrijcpy:   # getting 2 pstring and two indexes - copying chars from src[i:j] pstring to dst[i:j] --- rdi = &dest_pstring, %rsi = &src_pstring , %rdx = i , %rcx = j.

    cmpb    %dl,    %cl          # check if 'i' > 'j'
    jb      .invalid

    movzbq  (%rdi),      %r11    # get len to %rdi register.
    decq    %r11                 # decrease from len 1 to receive last index.
    cmpq    %rcx,        %r11    # compair if index j > dest.len.
    jb      .invalid

    movzbq  (%rsi),     %r11     # get len to %rdi register.
    decq    %r11                 # decrease from len 1 to receive last index.
    cmpq    %rcx,       %r11     # compair if index j > src.len.
    jb      .invalid             # incase j > len return invalid.

    inc     %rsi                 # increment rsi to skip len.
    inc     %rdi                 # increment rdi to skip len.

.start:
    leaq    (%rsi,%rdx), %r11            #  move src.str[i] into r11.- (address)
    movb    (%r11),      %al
    movb    %al,         (%rdi,%rdx)     # assign dest.str[i] = src.str[i]

    # check while if.
    cmpq    %rcx,   %rdx    # check if j < i
    inc     %rdx            # otherwise - increment i++ 
    jbe     .start          # incase j > i go to start.
    ja      .fin                         

.invalid:
    push    %rdi
    mov     $result_invalid, %rdi     # move invalid message - to first argument for printf.
    xor     %rax, %rax                # assign rax to 0 for printf.
    call    printf
    pop     %rax
    ret

.fin:
    subq    $1,     %rdi            # move rdi back to point at &pstring.
    movq    %rdi,   %rax            # move dest_pstring back to return value.
    ret


	.p2align 4
	.globl	replaceChar
	.type	replaceChar, @function

replaceChar: # replace old char by new char. --- %rdi = *pstr, %rsi = oldChar, %rdx = newChar

	movl	%edx,   %ecx    # move newchar to %edx
	movsbl	(%rdi), %edx	# instead of using pstrlen - implement alone - edx hold size of str now.
	movq	%rdi,   %r8     # move pstr to temp register r8.
	xorl	%eax,   %eax    # initialze i in eax.

.L5:    # if statment for pstr->str[i] == oldChar
	cmpb	%sil, 1(%r8,%rax)	    # compare oldChar with pstr-str[i] - when 1 is to skip len, r8 hold pstr, rax is the index.
	jne	    .L4                     # if pstr->str[i] != oldChar move to L4.
	leaq	1(%r8,%rax),	%r9 
    movb	%cl,    (%r9)           # otherwise make pstr->str[i] = newChar.

.L4:
	inc %rax	# increment i by one.
	cmpl	%eax,   %edx	# check if i > size(pstr->str)
	jg	    .L5	            # if not move back to if.
    movq	%r8,    %rax	# otherwise move pstr to return value and return.
	ret	



	.p2align 4
	.globl	swapCase
	.type	swapCase, @function

swapCase:       # swap all case of characters, --- %rdi &pstring

	movsbl	(%rdi),     %esi	  # instead of using pstrlen - implement alone - edx hold size of str now.
	movq	%rdi,       %r8       # move pstr to temp register r8.
	xorl	%eax,       %eax      # initialze i in eax.

.L6:    # if statment for 'Z' >= pstr->str[i] >= 'A'
    movzbl	1(%r8,%rax),    %edx    # save pstr-str[i] in temp edx
    leal	-65(%edx),      %ecx    # in order to check if edx is in range of 65-90('A' - 'Z') we will substract 65 from edx and check on it. 
	cmpb	$25,            %cl	    # compare 'A' with pstr-str[i] - when 1 is to skip len, r8 hold pstr, rax is the index.
	jbe   	.L7                     # if 'Z' > pstr->str[i] > 'A' jump to L7

    # condition else
    leal	-97(%rdx),  %ecx    # in order to check if edx is in range of 65-90('A' - 'Z') we will substract 65 from edx and check on it. 
	cmpb	$25,        %cl	    # compare 'a' with pstr-str[i] - when 1 is to skip len, r8 hold pstr, rax is the index.
	jbe   	.L8                 # if 'z' > pstr->str[i] > 'a' jump to L8
    jmp     .L9

.L7:
	addl	$32, %edx	        # change captial letter to low order.
	movb	%dl, 1(%r8,%rax)    # move result to str[i]
    jmp     .L9

.L8:
    subl    $32, %edx           # change low order letter to capital.
    movb	%dl, 1(%r8,%rax)    # move result to str[i]

.L9:
	inc     %eax    	    # increment i by one.
	cmpl	%eax,   %esi	# check if i > size(pstr->str)
	jg	    .L6	            # if not move back to if.
    movq	%r8,    %rax	# otherwise move pstr to return value and return.
	ret	


	.globl	pstrijcmp
	.type	pstrijcmp, @function
pstrijcmp:      # compare two given strings character by character.  --- %rdi - &pstring1,  %rsi - &pstring2,   %rdx - i,  %rcx - j

    cmpb    %dl,    %cl    # check if 'i' > 'j'
    jb      .L15

    movzbq	(%rdi), %r8     # instead of using pstrlen - implement alone - r8 hold size of str now.
    cmpb    %dl,    %r8b    # check if 'i' is greater then pstr1->len
    jb      .L15

    cmpb    %cl,    %r8b    # check if 'j' is greater then pstr1->len
    jb      .L15

    movzbq	(%rsi), %r8     # instead of using pstrlen - implement alone - r8 hold size of str now.
    cmpb    %dl,    %r8b    # check if 'i' is greater then pstr1->len
    jb      .L15

    cmpb    %cl,    %r8b   # check if 'j' is greater then pstr1->len
    jb      .L15

.L10:    # if statment for pstr1->str[i] > pstr2->str[i]
	movzbq 	1(%rdi,%rdx),	%r9
	cmpb	%r9b,	1(%rsi,%rdx)	    # compare pstr1->str[i] with pstr2->str[i]
	ja	    .L11                        # if pstr2->str[i] > pstr1->str[i] go to finish ptstr2 > ptstr1
    jb      .L12                        # if pstr1->str[i] > pstr2->str[i] go to finish ptstr1 > ptstr2

.L13:
    inc %dl
    cmpb	%dl, %cl	# check if j < i
    jae      .L10
    xorl    %eax,   %eax
    ret

.L11:
    movl	$-1, %eax	
	ret	

.L12:
    movl	$1, %eax	
	ret	

.L15:
    movq    $result_invalid,   %rdi
    call    printf
    movl    $-2, %eax
    ret




