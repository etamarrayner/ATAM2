.global sum_of_text


.extern get_path
.extern text_to_number

sum_of_text:
  movq $0, %rbx #int sum = 0;
  movq $0, %r12 #int i = 0;
  movq $0, %r13 #int j = 0;
  movq $0, %rsi #O_RDONLY flag for open
  call get_path
  movq %rax, %rdi
  syscall open #puts 2 in rax, argument will be in rdi. returns the FD in rax
  movq %rax, %rdi
  syscall read #needs to create a buffer of size 6 in the stack, then we will read from it until seperator,
#  guaranteed to be a number if legal. replace seperator (if exists) with null terminate and pass to text_to_number function. if returns positive, add to sum. continue the reading loop from one after the newly null terminated char (or the next unread if there is no seperator, edge case! if there is no seperator in those six bytes we need to discard and read until a seperator is found and then start over)
  push (%edi) + j, %rax
  call text_to_number
  add %rbx, %rax 
  addq $1, %r12 //i++;
  movq %r12, %r12 //j = i
  ret
