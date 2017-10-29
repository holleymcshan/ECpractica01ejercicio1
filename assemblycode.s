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
				li $t0 -1
				beq $v0 $t0 error
				
			#copiamos el descriptor del fichero						$t0 descriptor del archivo
				move $t0 $v0
				
			#inicializamos el contador a 0							$t3 contador
				li $t3 0
				
bucle:			#lee 1 caracter
				move $a0 $t0
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
