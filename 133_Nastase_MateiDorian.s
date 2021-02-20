.data
n:    .space 4           # numar de noduri
m:    .space 4           # numar de conexiuni
c:    .space 4
d:    .space 4
a:    .space 2000        # matricea de adiacenta asociata grafului
r:    .space 100         # vectorul roles
q:    .space 100         # coada pentru bfs -> lungime maxim = nr noduri 
xi:   .space 4           # nodul initial din task 3
xf:   .space 4           # nodul final din task 3
viz:  .space 100         # vectorul in care marcam vecinii vizitati
task: .space 4           # numarul cerintei
cod:  .space 50          # codul citit 
dcod: .space 50          # codul descifrat

ca:   .byte 'a'
cz:   .byte 'z'
sp:   .asciiz " "
nl:   .asciiz "\n"
ho:   .asciiz "host index "
swi:  .asciiz "switch index "
swm:  .asciiz "switch malitios index "
co:   .asciiz "controller index "    
dots: .asciiz ": "                    
sep:  .asciiz "; "                 
yes:  .asciiz "Yes"
no:   .asciiz "No"                # pentru afisari

.text
main:

#--CITIREA--

li $v0, 5
syscall
sw $v0, n

li $v0, 5
syscall
sw $v0, m

la $t0, 0    # controul pentru for
lw $t1, m    # salvam nr de muchii
lw $t2, n    # salvam nr de noduri
li $t7, 4

loop_read_m:
            bge $t0, $t1, continue_read1
               li $v0, 5
               syscall
               move $t3, $v0       # in t3 avem x-ul
               
               li $v0, 5
               syscall
               move $t4, $v0       # in t4 avem y-ul

               mul $t5, $t2, $t3   # x*nrc
               add $t5, $t5, $t4   # +y
               mul $t5, $t5, $t7

               li $t6, 1
               sw $t6, a($t5)      # a[x][y]=1

               mul $t5, $t2, $t4   # y*nrc
               add $t5, $t5, $t3   # +x
               mul $t5, $t5, $t7
               sw $t6, a($t5)      # a[y][x]=1
               
               addi $t0, $t0, 1    # i++
               j loop_read_m

continue_read1: 
              
              li $t0, 0    # controul pentru for
              lw $t1, n    # salvam nr de noduri

loop_read_roles:
                bge $t0, $t1, continue_read2
                    li $v0,5
                    syscall
                    mul $t2, $t0, $t7 
                    sw $v0, r($t2)
                    addi $t0, $t0, 1
                    j loop_read_roles

continue_read2:              
              li $v0, 5            # citim si memoram tipul problemei
              syscall
              sw $v0, task

#--REZOLVARE_MAIN--
              
              lw $t0, task
              li $t1, 1
              li $t2, 2
              li $t3, 3
              beq $t0, $t1, rezolvare1
              beq $t0, $t2, rezolvare2
              beq $t0, $t3, rezolvare3
              li $v0, 10
              syscall
             

#--PRIMA CERINTA--
rezolvare1:
      
      li $t0, 0                      # contorul pentru for
      lw $t1, n                      # nr de noduri
      loop_r1:                       # parcurgem vectorul r
              bge $t0, $t1, exit_r1   
                   mul $t2, $t0, $t7                  
                   lw $t3, r($t2)                     # elementul curent e in $t3
                   li $t8, 3                     
                   beq $t3, $t8, afisare_swm          # daca rolul elementului curent e 3
                       addi $t0, $t0, 1
                       j loop_r1
      afisare_swm:
                la $a0, swm    # afisam tipul
                li $v0, 4
                syscall

                move $a0, $t0
                li $v0, 1
                syscall
                
                la $a0, dots   # afisam :
                li $v0, 4
                syscall
                
                
                li $t4,0
                parcurgere_vecini:
                                  bge $t4, $t1, sf_afis_swm
                                   move $t5, $t0             # i*4
                                   mul $t5, $t5, $t1         # n*4*i
                                   add $t5, $t5, $t4         # vecinul curent
                                   mul $t5, $t5, $t7
                                   li $t6, 1
                                   lw $t5, a($t5)
                                   beq $t5, $t6, vecin_gasit
                                   addi $t4, $t4, 1
                                   j parcurgere_vecini
                  vecin_gasit:
                              li $t8, 1
                              move $t5, $t4
                              mul $t5, $t5, $t7
                              lw $t5, r($t5)
                              beq $t5, $t8, vecin1
                              li $t8, 2
                              beq $t5, $t8, vecin2
                              li $t8, 3
                              beq $t5, $t8, vecin3
                              li $t8, 4
                              beq $t5, $t8, vecin4
                              
                         
                   vecin1: 
                              la $a0, ho    # afisam tipul
                              li $v0, 4
                              syscall
                              
                              move $a0, $t4
                              li $v0, 1
                              syscall

                              la $a0, sep    # afisam ;
                              li $v0, 4
                              syscall 

                              addi $t4, $t4, 1
                              j parcurgere_vecini

                   vecin2: 
                              la $a0, swi    # afisam tipul
                              li $v0, 4
                              syscall
                              
                              move $a0, $t4
                              li $v0, 1
                              syscall

                              la $a0, sep    # afisam ;
                              li $v0, 4
                              syscall 

                              addi $t4, $t4, 1
                              j parcurgere_vecini

                    vecin3: 
                              la $a0, swm    # afisam tipul
                              li $v0, 4
                              syscall
                              
                              move $a0, $t4
                              li $v0, 1
                              syscall

                              la $a0, sep    # afisam ;
                              li $v0, 4
                              syscall 

                              addi $t4, $t4, 1
                              j parcurgere_vecini

                    vecin4: 
                              la $a0, co    # afisam tipul
                              li $v0, 4
                              syscall
                              
                              move $a0, $t4
                              li $v0, 1
                              syscall

                              la $a0, sep    # afisam ;
                              li $v0, 4
                              syscall 

                              addi $t4, $t4, 1
                              j parcurgere_vecini
                               
        
     sf_afis_swm:
                la $a0, nl     # afisam \n
                li $v0, 4
                syscall
                addi $t0, $t0, 1
                j loop_r1
           
      exit_r1:
           li $v0, 10
           syscall



rezolvare2:
           #initializari:
           lw $t0, n
           li $t1, 0            # $t1 - st 
           li $t2, 1            # $t2 - dr
           li $t3, 0            # $t3 - xc = elementul curent 
           sw $t3, q($t3)       # adaugam in coada nodul de la care pornim aka nodul 0
           sw $t2, viz($t3)     # marcam nodul 0 ca fiind vizitat    
           li $t4, 4   
           li $t5, 0            # contorul pentru parcurgerea vecinilor 
           li $t7, 1        

parcurgere_BFS:
           
           beq $t1, $t2, final_BFS
               mul $t6, $t1, $t4
               lw $t3, q($t6)        # xc = q.pop()
               addi $t1, $t1, 1
               
               mul $t6, $t3, $t4
               lw $t8, r($t6)
               beq $t7, $t8, afisare_host    
                   j continue_BFS
               continue_BFS:
                    li $t5, 0
                    loop_vecini:
                            bge $t5, $t0, next_in_q                # parcurgem vecinii for(i=0;i<n;i++)   
                                mul $t8, $t5, $t4                  # i*4
                                mul $t6, $t3, $t0   # x*nrc
                                add $t6, $t6, $t5   # +y
                                mul $t6, $t6, $t4
                                lw $t6, a($t6)      # $t6 = a[xc][i]
                                bne $t6, $t7, continue_vecini      # daca nu avem muchie sarim la urmatoru
                                    lw $t9, viz($t8)
                                    bnez $t9, continue_vecini      # daca a mai fost vizitat sarim la urm
                                        # am gasit urmatorul nod    
                                        mul $t2, $t2, $t4
                                        sw $t5, q($t2)             # q[dr] = i
                                        div $t2, $t2, $t4
                                        addi $t2, $t2, 1           # dr++
                                        sw $t7, viz($t8)           # viz[i]=1
                                        addi $t5, $t5, 1
                                        j loop_vecini
                               continue_vecini:
                                        addi $t5, $t5, 1
                                        j loop_vecini
             final_BFS:                                           # verificam daca graful este conex
                      li $t1, 0  # parcurgem vectorul viz
                      li $t2, 1
                      loop_viz:
                               bge $t1, $t0, end_task2
                                   mul $t3, $t1, $t4
                                   lw $t5, viz($t3)
                                   beqz $t5, afisare_neconex
                                   addi $t1, $t1, 1
                                   j loop_viz

next_in_q:
          j parcurgere_BFS
afisare_host:
            la $a0, ho
            li $v0, 4
            syscall

            move $a0, $t3
            li $v0, 1
            syscall

           la $a0, sep
           li $v0, 4
           syscall
           
           j continue_BFS       #revenim in bfs  
             
afisare_neconex:
           
           la $a0, nl
           li $v0, 4
           syscall
           la $a0, no
           li $v0, 4
           syscall
           li $v0, 10
           syscall

end_task2:
           la $a0, nl
           li $v0, 4
           syscall
           la $a0, yes
           li $v0, 4
           syscall
           li $v0, 10
           syscall

rezolvare3:
           li $v0, 5
           syscall
           sw $v0, xi
           
           li $v0, 5
           syscall
           sw $v0, xf
           
           li $v0, 8
           li $a1, 50
           la $a0, cod
           syscall
           #sw $v0, cod     # citirile suplimentare
           
           lw $t0, n
           li $t1, 0
           li $t2, 3
           li $t4, 4
           elim_swm:      
                     bge $t1, $t0, parcurgere_BFS3   # incercam sa gasim o conexiune sigura
                        mul $t1, $t1, $t4
                        lw $t3, r($t1)
                        beq $t3, $t2, turn_off
                        j continue_elim_swm
           continue_elim_swm:  
                               div $t1, $t1, $t4
                               addi $t1, $t1, 1
                               j elim_swm
           turn_off:
                    li $t3, 1
                    sw $t3, viz($t1)                 # marcam switchul malitios ca fiind deja parcurs
                    j continue_elim_swm
parcurgere_BFS3:          
           
           lw $t0, n
           li $t1, 0            # $t1 - st 
           li $t2, 1            # $t2 - dr
           lw $t3, xi           # $t3 - xc = elementul curent 
           mul $t3, $t3, $t4
           sw $t3, q($t1)       # adaugam in coada nodul de la care pornim
           sw $t2, viz($t3)     # marcam nodul xi ca fiind vizitat    
           li $t4, 4   
           li $t5, 0            # contorul pentru parcurgerea vecinilor 
           lw $t7, xf 
         
       BFS3:
           beq $t1, $t2, descifrare
               mul $t6, $t1, $t4
               lw $t3, q($t6)        # xc = q.pop()
               addi $t1, $t1, 1
               lw $t7, xf 
               beq $t7, $t3, afisare_conexiune_sigura # am ajuns in nodul final   
                   j continue_BFS3
               continue_BFS3:
                    li $t5, 0
                    loop_vecini3:
                            bge $t5, $t0, next_in_q3                # parcurgem vecinii for(i=0;i<n;i++)   
                                mul $t8, $t5, $t4                  # i*4
                                mul $t6, $t3, $t0   # x*nrc
                                add $t6, $t6, $t5   # +y
                                mul $t6, $t6, $t4
                                lw $t6, a($t6)      # $t6 = a[xc][i]
                                li $t7, 1
                                bne $t6, $t7, continue_vecini3      # daca nu avem muchie sarim la urmatoru
                                    lw $t9, viz($t8)
                                    bnez $t9, continue_vecini3      # daca a mai fost vizitat sarim la urm
                                        # am gasit urmatorul nod    
                                        mul $t2, $t2, $t4
                                        sw $t5, q($t2)             # q[dr] = i
                                        div $t2, $t2, $t4
                                        addi $t2, $t2, 1           # dr++
                                        sw $t7, viz($t8)           # viz[i]=1
                                        addi $t5, $t5, 1
                                        j loop_vecini3

                               continue_vecini3:
                                        addi $t5, $t5, 1
                                        j loop_vecini3

             descifrare:                                           # verificam daca graful este conex
                        li $t1, 0
                        lb $t2, ca   # pasul din caesar
                        lb $t3, cz
                        lb $t0, cod($t1)
                        parcurgere_char:
                                  lb $t0, cod($t1)
                                  beqz $t0, cod_corect
                                 
                                  blt $t0, $t2, next_char
                                  bgt $t0, $t3, next_char

                                  addi $t0, $t0, -10
                                  blt $t0, $t2, revenire
                                  move $a0, $t0
                                  li $v0, 11
                                  syscall
                                  j next_char

                        next_char:
                                 
                                  #sb $t0, dcod($t1)
                                  addi $t1, $t1, 1
                                  #lb $t0, cod($t1)
                                  j parcurgere_char

                        revenire:
                                  addi $t0, $t0, 26
                                  move $a0, $t0
                                  li $v0, 11
                                  syscall
                                  j next_char

                       cod_corect:
                                   #la $a0, dcod
                                   #li $v0, 4
                                   #syscall

                                   li $v0, 10
                                   syscall
                    
 
next_in_q3:
          j BFS3
 
afisare_conexiune_sigura:
                         la $a0, cod
                         li $v0, 4 
                         syscall
                         
                         li $v0, 10
                         syscall
