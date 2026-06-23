.global sum_of_text


.extern get_path
.extern text_to_number

sum_of_text:
  pushq %rbp
  movq %rsp, %rbp #prolouge
  movq $0, %rbx #int sum = 0;
  movq $0, %r12 #int i = 0;
  #movq $0, %r13 #int j = 0;
  movq $0, %rsi #O_RDONLY flag for open
  movb %dl, %r14b #seperator argument
  call get_path
  movq %rax, %rdi
  movq $2, %rax
  syscall #open: puts 2 in rax for syscall identifier, argument will be in rdi. returns the FD in rax
main_loop:
  movq %rax, %rdi #rax holds the fd from the open syscall, passing to rdi argument
  movq $0, %rax #syscall identifier for read
  movq (%rbp,%r12,1), %rsi #beginning of the stack buffer will be passed as argument
  movq $1, %rdx #size of read buffer.
  syscall #calling read of one byte into the top of the buffer stack 
  cmpb (%rbp,%r12,1), %r14b #check if read_char == seperator
  je handle_seperator
  addq $1, %r12 #i++
  j sum_of_text #if reached then we should keep reading the next byte

handle_seperator:
  movb $0, (%rbp,%r12,1) #replacing the seperator with null
  call text_to_number
  add %rax, %rbx 

  leave
  ret