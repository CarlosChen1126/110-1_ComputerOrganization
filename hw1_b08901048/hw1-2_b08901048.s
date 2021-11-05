.globl __start

.rodata
    msg0: .string "This is HW1-2: \n"
    msg1: .string "Plaintext:  "
    msg2: .string "Ciphertext: "
.text

################################################################################
  # print_char function
  # Usage: 
  #     1. Store the beginning address in x20
  #     2. Use "j print_char"
  #     The function will print the string stored from x20 
  #     When finish, the whole program with return value 0

print_char:
    addi a0, x0, 4
    la a1, msg2
    ecall
    
    add a1,x0,x20
    ecall

  # Ends the program with status code 0
    addi a0,x0,10
    ecall
    
################################################################################

__start:
  # Prints msg
    addi a0, x0, 4
    la a1, msg0
    ecall

    la a1, msg1
    ecall
    
    addi a0,x0,8
    li a1, 0x10130
    addi a2,x0,2047
    ecall
    
  # Load address of the input string into a0
    add a0,x0,a1
################################################################################ 
  # Write your main function here. 
  # a0 stores the begining Plaintext
  # Do store 66048(0x10200) into x20 
  # ex. j print_char
  li x22,48 #index of counting space
  li x20, 0x10200 #the pointer which point to the address that new bit(encrypted) to be stored
  li x19, 32 #x19="space"
  li x26, 255 #x26=0x000000ff
  li x27, 120 #Ascii of "x"
  jal loop
xyz: # handle "x" "y" "z" encrypting("x"->"a", "y"->"b", "z"->"c")
 addi x18,x18,-26
 jal cipher
space: #calculate the numbers of space
  sw x22, 0(x20) 
  addi x22,x22,1
  addi a0,a0,1 #point to next char
  addi x20,x20,1 #dest.address++
  jal loop 
loop: # main loop function 
  lw x18, 0(a0)
  and x18,x18,x26 #extract the char we used
  beq x18, x19, space # if x18=" " -> space
  blt x18,x19, final # if x18 < " "(beacause input only space or lowercase alphabets)
  bge x18,x27, xyz
cipher:
  addi x18,x18,3 #Caesar cipher
  sw x18,0(x20) #stored encrypted bit into memory
  addi a0,a0,1 #point to next char
  addi x20,x20,1 #dest.address++
  jal loop
final:
  li x20,0x10200
  j print_char
################################################################################

