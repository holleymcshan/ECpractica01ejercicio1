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
				
error:			#sacamos por pantalla el mensaje de error
				la $a0 	mError
				li $v0 4
				syscall
				
haySubcadena:		#nuestra funcionø
				li $t0 0							#$t0 contador
				lw $t1 cadena($t0)						#$t1 caracter en contador
				beq $a0 $t1 igual
				
			#leemos otro caracter
bucleChar:			move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
			#si no es igual al primer caracter de la subcadena empezamos de nuevo
				
				bneq $a1 cadena($t0) else
				addi $t0 $t0 4
				
				
else:				li $t2 9
				beq $t1 $t2 fin
				li $t2 13
				beq $t1 $t2 fin
				li $t2 20
				beq $t1 $t2 fin
				
				li $t0 0				#si no es el final, empezamos de nuevo en busca de la subcadena
				b bucleChar
igual:			
fin:
