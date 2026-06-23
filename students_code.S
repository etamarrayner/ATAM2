.global sum_of_text


.extern get_path
.extern text_to_number

sum_of_text:
  movq $0, %rbx #int sum = 0;
  movq $0, %r12 #int i = 0;
  #movq $0, %r13 #int j = 0;
  movq $0, %rsi #O_RDONLY flag for open
  movb %dl, %r14l #seperator argument
  call get_path
  movq %rax, %rdi
  movq $2, %rax
  syscall #open: puts 2 in rax for syscall identifier, argument will be in rdi. returns the FD in rax
main_loop:
  movq %rax, %rdi #rax holds the fd from the open syscall, passing to rdi argument
  movq $0, %rax #syscall identifier for read
  movq (%rbp,%r12,1), %rsi #beginning of the stack
  movq $1, %rdx #size of read buffer.
  syscall #needs to create a buffer of size 6 in the stack, then we will read from it until seperator,
#  guaranteed to be a number if legal. replace seperator (if exists) with null terminate and pass to text_to_number function. if returns positive, add to sum. continue the reading loop from one after the newly null terminated char (or the next unread if there is no seperator, edge case! if there is no seperator in those six bytes we need to discard and read until a seperator is found and then start over)
  #check if readed char is the seperator, if yes, null terminate it and call text_to_number
  cmpb (%r12)%rbp, (%r14l) #check if read_char == seperator
  je handle_seperator
  addq $1, %r12 #i++;

handle_seperator:
  call text_to_number
  add %rax, %rbx 

  ret