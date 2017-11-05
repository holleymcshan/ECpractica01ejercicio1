# ECpractica01ejercicio1

Objetivos de la práctica
El objetivo de la práctica consiste en entender los conceptos básicos relacionados con la programación en ensamblador. Para ello, se utilizará como ejemplo el ensamblador del MIPS32 y el simulador QtSpim. La práctica consta de 2 ejercicios.

Ejercicio 1
El objetivo de este ejercicio es desarrollar un programa en ensamblador que procese un fichero de entrada formado por palabras, que podrán estar separadas por uno o más blancos o saltos de línea. El objetivo del programa es determinar el número de palabras del texto que incluyen como subcadena otra dada.

El segmento de datos del programa incluirá, al menos, las siguientes definiciones:
  .data:
      nombre_fichero: .asciiz "c:\users\fichero.txt " 
      cadena: .asciiz "na"

Donde nombre_fichero será el nombre del fichero a procesar. El programa deberá indicar cuántas palabras de las incluidas en el fichero de entrada tienen a la cadena na como subcadena. Por ejemplo, considere el fichero de entrada:
    ￼   Este fichero es un ejemplo de prueba para
       Determinar cuantas palabras del mismo tienen na como subcadena

Para este fichero de prueba, el programa debería imprimir el valor 3. En caso de que el fichero no pueda ser abierto (el fichero no existe o la apertura del mismo falla), el programa deberá imprimir el siguiente mensaje de error:
      Error al abrir el fichero

Si el fichero está vacío, el programa deberá imprimir en la consola “Fichero Vacío”.

El programa deberá, además, hacer todo el tratamiento de errores necesario. Tenga en cuenta que el programa debe poder ejecutar con cualquier fichero de texto y cualquier subcadena.

En el apartado del enunciado Procesamiento de ficheros con QtSpim, se describe cómo procesar archivos con el simulador QtSpim.
