# mlcoalsim con scripts y loops


Esta práctica asume que tienes instalado [mlcoalsim](http://www.ub.edu/softevol/mlcoalsim/). Si no, tienes que descargar el archivo [mlcoalsim.zip de esta liga](https://code.google.com/archive/p/mlcoalsim-v1/downloads). Descomprimirlo:

```
# un zip 
unzip mlcoalsim.zip
```

y dentro de las carpetas descomprimidas navegar a la carpeta `source_files`:

```
cd source_files/
``` 

Una vez ahí, hay que [compilar](https://www.computerhope.com/jargon/c/compile.htm) el programa correriendo la línea: 

```
gcc *.c -lm -o mlcoalsim 
```

El que ya esté "compilado", quiere decir que se hizo creará (dentro de la misma carpeta) un nuevo archivo llamado `mlcoalsim` que es un ejecutable ajustado a las especificaciones de nuestro sistema, es decir, un programa que podemos correr en nuestra computadora sin necesidad de instalar nada más. Pero ojo, si paso ese archivo ejecutable a otra computadora no necesiriamente va a funcionar, pues cada computadora tiene distintas especificaciones.

Si la compilación fue exitosa, deberás obtener algo así al correr `./mlcoalsim -h` (la ayuda del programa).

```
$ ./mlcoalsim -h
mlcoalsim version 1.44 (20080320)
usage: input_file output_file
```

Los archivos y scripts para esta práctica se encuentran en el directorio `clase_Ajaliscana` de esta unidad. Puedes descargarlo [aquí](clase_Ajaliscana.zip). Y descomprimirlo con:

```
unzip clase_Ajaliscana.zip
```

Tras descomprimir, podemos explorar el contenido del directorio:

```{bash}
cd clase_Ajaliscana # moverse al directorio
ls # enlistar contenido
```

Copia el archivo ejecutable `mlcoalsim` que se creo en el paso de la compilación al directorio `clase_Ajaliscana`. 

En la práctica que dio Gustavo vimos cómo correr mlcoalsim desde la línea de comando, corriendo mlcoalsim para cada modelo en una línea distinta. Por ejemplo para el modelo 8 hicimos:

```
./mlcoalsim jalism8.txt jalism8.out
```

Y para el 9 hicimos:

```
./mlcoalsim jalism9.txt jalism9.out
```

En esta práctica vamos a repetir lo anterior, pero utilizando un **for loop** y poniendo todo nuestro código en un script. Posteriormente vamos a extraer los valores de probabilidad de que los estadisticos de resumen de cada archivo output, mediante otro loop. 

## Correr mlcoalsim con un loop y ponerlo en un script


Los pasos que recomiendo seguir para construir un for loop a partir de un código que ya tenemos son:

0. Abrir mi editor de texto plano favorito (WORD **no** es un editor de texto) para escribir mi script ahí. Desde la línea de comando puede ser `nano` o `vim`. O puede ser un programa externo como Fraise, Atom, Edit o Bloc de Notas. Pero JAMÁS Word, porque **no** es un editor de texto plano, sino un *procesador* de texto que formatea los archivos de formas extrañas aunque no lo veamos.

1. Escribir dos ejemplos de la línea que quiero loopear, uno después de otro:

```
./mlcoalsim jalism8.txt jalism8.out
./mlcoalsim jalism9.txt jalism9.out
```

2. Detectar cuál es el elemento que cambia y cuál es el texto que quiero dejar igual. En  este caso solo cambian los números 8 y 9.

3. Sustituir el texto que cambia por `${i}` (Pregunta: ¿Por qué es mejor usar `${i}` qué `$i`?) y dejar una sola línea:

```
./mlcoalsim jalism${i}.txt jalism${i}.out
``` 

4. En la línea previa, enlistar los elementos que deben sustituir a i en cada ciclo.

```
8 9 10 15
./mlcoalsim jalism${i}.txt jalism${i}.out
```

5. Compeltar la sintaxis del for loop:

```
for i in 8 9 10 15; do
./mlcoalsim jalism${i}.txt jalism${i}.out
done
```

6. Ahora hay que completar el script con sus respectivos comentarios:

```
# Script to run mlcoalsim in A. jaliscana
# The script assumes that the input data is in the WD of this script. 
# Also the executable mlcoalsim should be available in the WD.

# This loop runs mlcoalsim for 4 demographic models
for i in 8 9 10 15; do  
./mlcoalsim jalism${i}.txt jalism${i}.out 
done
```

7. Antes de guardar el script, recomiendo copiar y pegar el loop en la terminal para ver que efectivamente corra. Ojo, no necesariamente tengo que esperar a que termine de correr, si ya funciona puedo "cancelar" con `Control + C`.

Si todo sale bien, entonces:

8. Ya podemos guardar todo en un script (que es un archivo de texto) que llamaremos: [1\_run\_mlcoalsim.sh](clase_Ajaliscana/1_run_mlcoalsim.sh). 

Puedes llamar al script como sea, pero como veremos más adelante, es buena idea numerarlos cuando forman parte de una pipeline.

9. Ahora mi trabajo está documentado y guardado en un script que le puedo enviar a mis colegas por correo electrónico. Para correrlo, solo es necesario:

```
bash 1_run_mlcoalsim.sh
```
Si corre bien, deberás ver algo como:

```
mlcoalsim version 1.44 (20080320)

 Starting coalescent simulations...
 Each dot indicate that aproximately 2% of the simulation is done.
         1    2    3    4    5    6    7    8    9  100%
 RUN .................................................. Simulation finished.
 Saving results in output file/s...
 Calculating percentiles and (if required) probabilities for observed values... 
 mlcoalsim version 1.44 (20080320) exited succesfully.

mlcoalsim version 1.44 (20080320)

 Starting coalescent simulations...
 Each dot indicate that aproximately 2% of the simulation is done.
         1    2    3    4    5    6    7    8    9  100%
 RUN ..........................
```

Nota que el output que vemos "se repite" porque está corriendo para cada simulación. Si quieres saber en cuál va sin ponerte a contar, se puede modificar el for loop para incluir un mensaje personalizado, por ejemplo:

```
for i in 8 9 10 15; do  
echo Inicia a correr el modelo $i
./mlcoalsim jalism${i}.txt jalism${i}.out 
echo Terminó de correr el modelo $i
done
```

(modifica el loop dentro del script guardado y vuélvelo a correr para ver qué hace).


**Ejercicio:**

Revisa la sección "Enlistar los elementos en una variable fuera del loop" de las notas [For loops en bash](../Unidad1_Intro/For_loops_bash.md) para modificar el script 1_run_mlcoalsim.sh de forma que los elementos `8 9 10 15` se definan **fuera** del loop en **una variable**.


## Extraer los valores de probabilidad de cada archivo de salida

En la práctica con Gus vimos que podíamos extraer valores de probabilidad de que los estadisticos de resumen simulados sean más pequeños o iguales a los estadisticos de resumen observados, buscando el valor promedio (average) dentro de los archivos output que terminan en "PPercentiles.out". Por ejemplo para el modelo 8:

```
grep -E "average" jalism8_PPercentiles.out | awk 'NR == 2'
```

Desglozando la línea anterior:

`grep -E "average" jalism8_PPercentiles.out` nos da todas las líneas que empiezan con "average". 

`|` manda el output del comando anterior (o sea el resultado del `grep`) como input para el siguiente comando, o sea `awk`

`awk 'NR == 2` es una manera de decir que solo queremos quedarnos con el renglón 2 de los resultados (si exploras el archivo  PPercentiles.out verás por qué). 

Para no solo imprimir los resultados en pantalla sino guardarlos en un archivo primero nesitamos crear una tabla bonita donde poner los resultados, con un encabezado informativo que podemos sacar del mismo archivo output.

```
awk 'NR == 34' jalism8_PPercentiles.out > P.txt # Save headers to a file
```

**Nota** recuerda que `>` manda el resultado de correr un comando (lo que normalmente se imprimiría en la consola) a un archivo de texto que SE CREA (o sobreescribe si ya existe) en ese momento.

Ahora podemos guardar los resultados en una nueva línea de ese mismo archivo:

```
grep -E "average" jalism8_PPercentiles.out | awk 'NR == 2' >> P.txt
```

**Nota** Ojo, `>>` manda el resultado de correr un comando (lo que normalmente se imprimiría en la consola) al final de un archivo de texto existente (como una línea nueva). Es decir NO sobreescribe el archivo.

Si ponemos todo en un script:

```
# Create a file to save results, adding as first line a useful header.
awk 'NR == 34' jalism8_PPercentiles.out > P.txt # Save headers to a file

# Save results in output file for model 8
grep -E "average" jalism8_PPercentiles.out | awk 'NR == 2' >> P.txt
```

Lo anterior funciona para el modelo 8, pero la tarea ahora es repetirlo para todos los modelos usando un loop.

**Ejercicio**

Utiliza como base el código anterior para hacer un script con un for loop que, para todos los modelos, extraiga los valores que extraimos antes solo para el modelo 8. El resultado se debe guardar en el archivo `P.txt`. 



