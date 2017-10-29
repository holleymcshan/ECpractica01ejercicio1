				.data
nombre_fichero:	.asciiz "c:\users\fichero.txt "
cadena:		 	.asciiz "na"
buffer:			.space 1
mError:			.asciiz "Error al abrir"
				.text
				.globl main
				
main:			#abrimos el fichero
				la $a0 nombre_fichero
				li $a1 0x0
				li $v0 13
				syscall
				li $s0 -1
				beq $v0 $s0 error
				
			#copiamos el descriptor del fichero						$s0 descriptor del archivo
				move $s0 $v0
				
			#inicializamos el contador a 0							$t3 contador
				li $t3 0
				
bucle:			#lee 1 caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
				
			#comprobamos si es un espacio, un tabulado, o un salto de linea			$t2 caracter en buffer
				lw $t2 buffer
				
				li $t1 9
				beq $t1 $t2 bucle
				li $t1 13
				beq $t1 $t2 bucle
				li $t1 20
				beq $t1 $t2 bucle
				
			#si no lo es seguimos
			#pasamos el caracter leido como parametro
				move $a0 $t2
				
			#guardamos en la pila el $ra y el $fp
				addi $sp $sp -8
				sw $ra 4($sp)
				sw $fp ($sp)
				
			#llamamos a la funcion
				jal haySubcadena
				
			#recuperamos el $fp y el $ra
				lw $fp ($sp)
				lw $ra 4($sp)
				addi $sp $sp 8
				
			#sumamos al contador si hay subcadena
				add $t3 $t3 $v1
				
			#comprobamos si en el subprograma o en el descarte de espacios ha llegado al final
				bnez $v0 bucle
			
			#cerramos el archivo y terminamos el programa
				move $a0 $s0
				li $v0 16
				syscall
				
				b finPrograma
				
error:			#sacamos por pantalla el mensaje de error
				la $a0 	mError
				li $v0 4
				syscall
				b finPrograma
				
haySubcadena:		#nuestra funcion
			#iniciamos variables
				li $t0 0							#$t0 contador de substring
				li $v0 0							#$v0 valor de retorno
			#cargamos el primer byte de la subcadena en $t4, si no es igual saltamos al else, si es igual sumamos uno al contador
				lb $t4 cadena
				bne $a0 $t4 else
				addi $t0 $t0 1
				
			#inicializamos el valor de retorno a 0	
bucleChar:		#leemos otro caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
				
			#si ha llegado al final del archivo terminamos la funcion
				beqz $v0 fin
				
				lb $t3 buffer							#$t3 caracter leido del archivo
				
			#si no es igual al primer caracter de la subcadena 
				lb $t5 cadena($t0)						#$t5 caracter actual de la subcadena
				bne $t3 $t5 else
				addi $t0 $t0 1
				b bucleChar
				
else:			#si es el final de la subcadena sumamos 1 a v0(que es lo que devolvemos) y salimos del bucle 
				lb $t5 cadena($t0)						#$t5 caracter actual de la subcadena
				bnez $t5 noFinalSubcadena
				li $v0 1
				b fin
				
noFinalSubcadena:	#si el ultimo caracter leido es un espacio, un tabulado o un enter salimos de bucle
				li $t2 9
				beq $t3 $t2 fin
				li $t2 13
				beq $t3 $t2 fin
				li $t2 20
				beq $t3 $t2 fin
				
			#si no es el final, empezamos de nuevo en busca de la subcadena	
				li $t0 0				
				b bucleChar	
				
irFinalPalabra:		#leer caracter hasta que sea espacio, tabulado o enter	
				li $t2 9
				beq $t3 $t2 fin
				li $t2 13
				beq $t3 $t2 fin
				li $t2 20
				beq $t3 $t2 fin
				
			#leemos otro caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
				lb $t3 buffer
				
				b irFinalPalabra
fin:				jr $ra		

finPrograma:
