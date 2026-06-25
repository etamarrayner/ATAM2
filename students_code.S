.global sum_of_text


.extern get_path
.extern text_to_number

sum_of_text:
  pushq %rbp
  pushq %rbx
  pushq %r12
  pushq %r13
  pushq %rsi
  pushq %r14
  pushq %r15
  movq %rsp, %rbp #prolouge
  movq $0, %rbx #int sum = 0;
  movq $0, %r12 #int i = 0;
  movq $1, %r13 #reached EOF if it is zero
  movb %dil, %r14b #seperator argument
  movq $0, %r15 #fd from open
  subq $48, %rsp #reserving 40 chars sized bytes

  call get_path
  movq $0, %rsi #O_RDONLY flag for open
  movq %rax, %rdi
  movq $2, %rax
  syscall #open: puts 2 in rax for syscall identifier, argument will be in rdi. returns the FD in rax
  movq %rax, %r15
main_loop:
  movq %r15, %rdi #r15 holds the fd from the open syscall, passing to rdi argument
  movq $0, %rax #syscall identifier for read
  leaq -48(%rbp,%r12,1), %rsi #beginning of the stack buffer will be passed as argument
  movq $1, %rdx #size of read buffer.
  syscall #calling read of one byte into the top of the buffer stack 
  movq %rax, %r13
  cmpq $0, %rax #check if reached EOF
  je handle_seperator
  cmpb -48(%rbp,%r12,1), %r14b #check if read_char == seperator
  je handle_seperator
  cmpb $13, -48(%rbp,%r12,1) #check if read_char == \n
  je handle_seperator
  cmpb $10, -48(%rbp,%r12,1) #check if read_char == \n
  je handle_seperator
  addq $1, %r12 #i++
  jmp main_loop #if reached then we should keep reading the next byte

handle_seperator:
  cmpq $0, %r12
  je reset_stack
  movb $0, -48(%rbp,%r12,1) #replacing the seperator with null
  leaq -48(%rbp), %rdi #putting the start of the stack as the char* argument
  call text_to_number
  cmpw $-1, %ax
  je reset_stack
  addw %ax, %bx #if reached then %rax holds an actual number

reset_stack:
  movq $0, %r12
  cmpq $0, %r13
  jne main_loop


  movq $3, %rax
  movq %r15, %rdi
  syscall
  movzwl %bx, %eax
  addq $48, %rsp
  popq %r15
  popq %r14
  popq %rsi
  popq %r13
  popq %r12
  popq %rbx
  popq %rbp
  ret
  