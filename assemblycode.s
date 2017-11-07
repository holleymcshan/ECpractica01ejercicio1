				.data
nombre_fichero:	.asciiz "/Users/hmcshan/Desktop/tester.txt"
cadena:		 	.asciiz "na"
buffer:			.space 1
mError:			.asciiz "Error al abrir el fichero de entrada"
error_vacio:		.asciiz "Fichero Vacio"

			.text
				.globl main
				
main:			la $a0 nombre_fichero
			la $a1 cadena
			
			addi $sp $sp -8		#guardamos en la pila el $ra y el $fp
			sw $ra 4($sp)
			sw $fp ($sp)
				
			jal ejercicio1		#llamamos a la funcion
				
			lw $fp ($sp)		#recuperamos el $fp y el $ra
			lw $ra 4($sp)
			addi $sp $sp 8
			
			li $v0 10		#terminamos el programa
			syscall


ejercicio1:		move $s2 $a1		#guardamos la direccion de la subcadena	 s2 direccion de la subcadena

			li $a1 0x0		#abrimos el fichero
			li $v0 13
			syscall
			
			li $t0 -1
			beq $v0 $t0 error
			
			
			move $s0 $v0		#copiamos el descriptor del fichero		#$s0 descriptor del archivo
			
			li $s1 0		#inicializamos el contador a 0			#$s1 contador
			
			move $a0 $s0		#lee 1 caracter
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			
			beqz $v0 vacio		#si es el final, el fichero esta vacio
			b comprobar		#si no esta vacio, iniciamoes el bucle despues de leer un caracter
		
				
bucle:			move $a0 $s0		#lee 1 caracter
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			
			beqz $v0 eof		#si ha llegado al final del archivo cerramos el archivo y terminamos
				
comprobar:		lb $t0 buffer		#comprobamos si es un espacio o salto de linea	 #$t0 caracter en buffer
				
			li $t1 0xa
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
			
eof:			move $a0 $s0		#cerramos el archivo y terminamos el programa
			li $v0 16
			syscall					
			
			li $v0 1		#imprimimos el numero y salimos de la funcion
			move $a0 $s1
			syscall
			
			jr $ra
				
error:			la $a0 	mError		#imprimimos el error y salimos de la funcion
			li $v0 4
			syscall
			jr $ra
			
vacio:			li $v0 4		#imprimimos el error y salimos de la funcion
			la $a0 error_vacio
			syscall
			jr $ra        
				
haySubcadena:					#nuestra funcion
			li $t0 0		#iniciamos variables				#$t0 contador de substring
			li $v1 0								#$v1 valor de retorno
			move $t1 $a0		#empezamos el bucle habiendo leido un caracter
			b despuesDeLeer
				
bucleChar:		move $a0 $s0		#leemos un caracter
			la $a1 buffer
			li $a2 1
			li $v0 14
			syscall
			
			lb $t1 buffer		#guardamos el caracter leido			#$t1 caracter leido del archivo
				
despuesDeLeer:		
			move $t2 $s2		#guardamos en t2 la direccion de la subcadena
			add $t2 $t2 $t0		#le sumamos a la direccion de la subcadena el desplazamiento actual
			lb $t2 ($t2)								#$t2 caracter actual de la subcadena
			bne $t1 $t2 else	#si no es igual al caracter actual de la subcadena saltamos a else
			addi $t0 $t0 1
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion
			b bucleChar
			
	
else:			bnez $t2 noFinalSubcadena	#si no, saltamos a noFinalSubcadena
			li $v1 1
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion
			b irFinalPalabra	#si es el final de la subcadena ponemos 1 en v1 (que es lo que devolvemos) y salimos del bucle
				

noFinalSubcadena:	li $t3 0xa		#si el ultimo caracter leido es un espacio, un tabulado o un enter salimos de bucle
			beq $t1 $t3 fin
			li $t3 0x20
			beq $t1 $t3 fin
			
			beqz $v0 fin		#si ha llegado al final del archivo terminamos la funcion	
			li $t0 0		#si no es el final, empezamos de nuevo en busca de la subcadena				
			b bucleChar
			li $v0 1
			
irFinalPalabra:		beq $v0 $0 fin		#leer caracter hasta que sea espacio o enter	
			li $t3 0xa
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

