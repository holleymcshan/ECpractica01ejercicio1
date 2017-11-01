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
			
			#copiamos el descriptor del fichero										$s0 descriptor del archivo
				move $s0 $v0
				
			#inicializamos el contador a 0											$s1 contador
				li $s1 0
				
bucle:			#lee 1 caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
			
			#si ha terminado el archivo terminamos el programa
				beqz $v0 finPrograma
				
			#comprobamos si es un espacio, un tabulado, o un salto de linea			$t0 caracter en buffer
				lb $t0 buffer
				
				li $t1 0x9
				beq $t1 $t0 bucle
				li $t1 0x13
				beq $t1 $t0 bucle
				li $t1 0x20
				beq $t1 $t0 bucle
				
			#si no lo es seguimos
			#pasamos el caracter leido como parametro
				move $a0 $t0
				
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
				add $s1 $s1 $v1
				
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
				
haySubcadena:	
			#nuestra funcion
			#iniciamos variables
				li $t0 0															#$t0 contador de substring
				li $v1 0															#$v1 valor de retorno
			#empezamos el bucle habiendo leido un caracter
				move $t1 $a0
				b despuesDeLeer
				
bucleChar:		#leemos un caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
			
			#si ha llegado al final del archivo terminamos la funcion
				beqz $v0 fin
			
			#guardamos el carater leido												#$t1 caracter leido del archivo
				lb $t1 buffer
				
despuesDeLeer:	
			#si no es igual al caracter actual de la subcadena saltamos a else
			#si es igual al primer caracter de la subcadena sumamos 1 al contador de la subcadena y volvemos a empezar el bucle
				lb $t2 cadena($t0)													#$t2 caracter actual de la subcadena
				bne $t1 $t2 else	
				addi $t0 $t0 1
				b bucleChar
				
else:		#si es el final de la subcadena ponemos 1 en v1 (que es lo que devolvemos) y salimos del bucle
			#si no, saltamos a noFinalSubcadena
				bnez $t2 noFinalSubcadena
				li $v1 1
				b irFinalPalabra
				

noFinalSubcadena:
			#si el ultimo caracter leido es un espacio, un tabulado o un enter salimos de bucle
				li $t3 0x9
				beq $t1 $t3 fin
				li $t3 0x13
				beq $t1 $t3 fin
				li $t3 0x20
				beq $t1 $t3 fin
				
			#si no es el final, empezamos de nuevo en busca de la subcadena	
				li $t0 0				
				b bucleChar	
				
irFinalPalabra:	#leer caracter hasta que sea espacio, tabulado o enter	
				li $t3 0x9
				beq $t1 $t3 fin
				li $t3 0x13
				beq $t1 $t3 fin
				li $t3 0x20
				beq $t1 $t3 fin
				
			#leemos otro caracter
				move $a0 $s0
				la $a1 buffer
				li $a2 1
				li $v0 14
				syscall
				lb $t1 buffer
				
				b irFinalPalabra
fin:				jr $ra		

finPrograma:
