.globl __start

.rodata
    msg0: .string "This is HW1-1: T(n) = 2T(n/2) + 8n + 5, T(1) = 4\n"
    msg1: .string "Enter a number: "
    msg2: .string "The result is: "
    msg3: .string "Test value: "

.text
################################################################################
  # You may write function here
  
################################################################################

__start:
  # Prints msg0
    addi a0, x0, 4
    la a1, msg0
    ecall

  # Prints msg1
    addi a0, x0, 4
    la a1, msg1
    ecall

  # Reads an int
    addi a0, x0, 5
    ecall

################################################################################ 
  # Write your main function here. 
  # Input n is in a0. You should store the result T(n) into t0
  # HW1-1 T(n) = 2T(n/2) + 8n + 5, T(1) = 4, round down the result of division
  # ex. addi t0, a0, 1
  
  #func(n):
    #if(n==1) return 4
    #else return 2*func(n/2)+8n+5
  
  
  #a0=x10 t0=x5
jal x1, func
jal result #after the recurrence -> jump to result
func:
  addi sp,sp,-8
  sw x1,4(sp)
  sw x10,0(sp)
  addi x5,x10,-2 #x5=x10-2
  bge x5,x0,L1 #if x5>=0
  addi x10,x0,4 #T(1)=4
  addi sp,sp,8
  mv t0,x10
  jalr x0,0(x1)
L1:
  srli x10,x10,1 #n=n/2
  jal x1,func
  addi x6,x10,0
  lw x10,0(sp)
  lw x1,4(sp)
  addi sp,sp,8
  addi x18,x0,2#x18=2
  slli x19,x10,3 #x19=8*n
  addi x19,x19,5#x19=8n+5
  mul x10,x18,x6#x10=2T(n/2)
  add x10,x10,x19#T(n)=2T(n/2)+8n+5
  mv t0,x10
  jalr x0,0(x1)
  
  
    
   
    
    
################################################################################

result:
  # Prints msg2
    addi a0, x0, 4
    la a1, msg2
    ecall

  # Prints the result in t0
    addi a0, x0, 1
    add a1, x0, t0
    ecall
    
  # Ends the program with status code 0
    addi a0, x0, 10
    ecall