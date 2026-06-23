.global sum_of_text


.extern get_path
.extern text_to_number

sum_of_text:
  pushq %rbp
  movq %rsp, %rbp #prolouge
  subq $26, %rsp #reserving 26 chars sized bytes
  movq $0, %rbx #int sum = 0;
  movq $0, %r12 #int i = 0;
  movq $1, %r13 #reached EOF if it is zero
  movq $0, %rsi #O_RDONLY flag for open
  movb %dl, %r14b #seperator argument
  movq $0 %r15 #fd from open

  call get_path
  movq %rax, %rdi
  movq $2, %rax
  syscall #open: puts 2 in rax for syscall identifier, argument will be in rdi. returns the FD in rax
  movq %rax, %r15
main_loop:
  movq %r15, %rdi #r15 holds the fd from the open syscall, passing to rdi argument
  movq $0, %rax #syscall identifier for read
  movq (%rbp,%r12,1), %rsi #beginning of the stack buffer will be passed as argument
  movq $1, %rdx #size of read buffer.
  syscall #calling read of one byte into the top of the buffer stack 
  movq %rax, %r13
  cmpb $0, %rax #check if reached EOF
  je handle_seperator
  cmpb (%rbp,%r12,1), %r14b #check if read_char == seperator
  je handle_seperator
  cmpb $10, (%rbp,%r12,1) #check if read_char == \n
  je handle_seperator
  addq $1, %r12 #i++
  jmp main_loop #if reached then we should keep reading the next byte

handle_seperator:
  movb $0, (%rbp,%r12,1) #replacing the seperator with null
  movq %rbp, %rdi #putting the start of the stack as the char* argument
  call text_to_number
  cmbq %rax, $-1
  je reset_stack
  addq %rax, %rbx #if reached then %rax holds an actual number

reset_stack:
  movq $0, %r12
  cmpq $0, %r13
  jne main_loop


  movq $3, %rax
  movq %r15, %rdi
  syscall
  movq %rbx, %rax
  leave
  ret