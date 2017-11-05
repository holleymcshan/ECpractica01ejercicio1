				.data
nombre_fichero:	.asciiz "/Users/hmcshan/Desktop/tester.txt"
cadena:		 	.asciiz "na"
buffer:			.space 1
mError:			.asciiz "Error al abrir el fichero de entrada"
error_vacio:		.asciiz "Fichero Vacio"

			.text
				.globl main
				
main:			la $a0 nombre_fichero	#abrimos el fichero
			li $a1 0x0
			li $v0 13
			syscall
			li $t0 -1
			beq $v0 $t0 error
			
			move $s0 $v0		#copiamos el descriptor del fichero		#$s0 descriptor del archivo
		
			li $s1 0		#inicializamos el contador a 0			#$s1 contador
				
bucle:			move $a0 $s0		#lee 1 caracter
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			
			beqz $v0 vacio		#si ha terminado el archivo terminamos el programa
				
			lb $t0 buffer		#comprobamos si es un espacio o salto de linea	 #$t0 caracter en buffer
				
			li $t1 0x13
			beq $t1 $t0 bucle
			li $t1 0x20
			beq $t1 $t0 bucle

			move $a0 $t0		#si no lo es seguimos, pasamos el caracter leido como parametro
				
			addi $sp $sp -8		#guardamos en la pila el $ra y el $fp
			sw $ra 4($sp)
			sw $fp ($sp)
				
			jal haySubcadena	#llamamos a la funcion
				
			lw $fp ($sp)		#recuperamos el $fp y el $ra
			lw $ra 4($sp)
			addi $sp $sp 8
			
			add $s1 $s1 $v1		#sumamos al contador si hay subcadena
				
			bnez $v0 bucle		#comprobamos si en el subprograma o en el descarte de espacios ha llegado al final
			
			move $a0 $s0		#cerramos el archivo y terminamos el programa
			li $v0 16
			syscall					
			b finPrograma
				
error:			la $a0 	mError		#sacamos por pantalla el mensaje de error
			li $v0 4
			syscall
			li $v0 10		#no queremos imprimir
			syscall
				
haySubcadena:		li $t0 0		#nuestra funcion 	#iniciamos variables	#$t0 contador de substring
			li $v1 0								#$v1 valor de retorno
			move $t1 $a0		#empezamos el bucle habiendo leido un caracter
			b despuesDeLeer
				
bucleChar:		move $a0 $s0		#leemos un caracter
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			
			lb $t1 buffer		#guardamos el caracter leido			#$t1 caracter leido del archivo
				
despuesDeLeer:		lb $t2 cadena($t0)							#$t2 caracter actual de la subcadena
			bne $t1 $t2 else	#si no es igual al caracter actual de la subcadena saltamos a else
			addi $t0 $t0 1
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion
			b bucleChar
			
	
else:			bnez $t2 noFinalSubcadena	#si no, saltamos a noFinalSubcadena
			li $v1 1
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion
			b irFinalPalabra	#si es el final de la subcadena ponemos 1 en v1 (que es lo que devolvemos) y salimos del bucle
				

noFinalSubcadena:	li $t3 0x13		#si el ultimo caracter leido es un espacio, un tabulado o un enter salimos de bucle
			beq $t1 $t3 fin
			li $t3 0x20
			beq $t1 $t3 fin
			
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion	
			li $t0 0		#si no es el final, empezamos de nuevo en busca de la subcadena				
			b bucleChar
			li $v0 1
			
irFinalPalabra:		beq $v0 $0 fin		#leer caracter hasta que sea espacio o enter	
			li $t3 0x13
			beq $t1 $t3 fin
			li $t3 0x20
			beq $t1 $t3 fin
				
			move $a0 $s0
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			lb $t1 buffer
				
			b irFinalPalabra


fin:			jr $ra		

vacio:			li $v0 4
			la $a0 error_vacio
			syscall
			li $v0 10		#no queremos imprimir
			syscall

finPrograma:	        li $v0 1
			move $a0 $s1
			syscall
			li $v0 10
			syscall
