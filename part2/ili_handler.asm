
.globl my_ili_handler
.extern what_to_do, old_ili_handler

.text
.align 4, 0x90
  my_ili_handler:

    pushq %rax
    pushq %rcx
    pushq %rdx
    pushq %rsi
    pushq %rdi
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    
    movq 72(%rsp), %rax #the faulty instructions rip
    movzbl (%rax), %edi
    cmpb $0x0F, %dil
    jne one_byte_opcode
    movzbl 1(%rax), %edi #if reached, the last byte is the second one (rax + 1)
    call what_to_do
    cmpq $0, %rax
    je original_control
    movq %rax, 32(%rsp) #if reached, need to advance rip by two and continue executing
    addq $2, 72(%rsp) 
    jmp restore_and_return

one_byte_opcode:

    call what_to_do
    cmpq $0, %rax
    je original_control
    movq %rax, 32(%rsp) #if reached, need to advance rip by one and continue executing
    addq $1, 72(%rsp) 
    
restore_and_return:
    #pop everything we have pushed
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rdi
    popq %rsi
    popq %rdx
    popq %rcx
    popq %rax

    iretq

  original_control:
    #pop everything we have pushed
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rdi
    popq %rsi
    popq %rdx
    popq %rcx
    popq %rax
    jmp *old_ili_handler
    
