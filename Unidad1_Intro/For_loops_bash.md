# For loops en bash

Los *for loops* permiten **repetir** una serie de comandos con diferentes *variables de una lista*.

Sintaxis:

```
for i in list; do
 command1
 command2
 ..
done
```

"i" puede leerse como "el elemento i de la lista". Y  la lista no es más que el conjunto total de las variables que queremos.

Puedes consultar esta y más info de for loops en [esta guía con ejemplos y varios formatos](http://www.thegeekstuff.com/2011/07/bash-for-loop-examples/).


Ejemplo:

```
$ for i in adenina citosina guanina timina; do
> echo "La $i es una base nitrogenada"
> done

La adenina es una base nitrogenada
La citosina es una base nitrogenada
La guanina es una base nitrogenada
La timina es una base nitrogenada
```


**Observaciones importantes:**

* Los elementos de la lista NO se separan por comas (en otros lenguajes sí).
* Para referirnos al "elemento i" dentro de los comandos debemos usar como prefijo el símbolo `$`.
* **No** tienes que escribir el `>` antes de `echo` y de `done`, los pongo solo para mostrar que eso aparece en la terminal hasta que terminemos de meter los comandos que formarán parte del loop. De hecho `done` sirve para decir "ok, aquí termina el loop". En los ejemplos de abajo ya no lo pondré.

Otro ejemplo:

```
for perro in labrador "pastor mesoamericano" xolo; do
echo Mi mejor amigo es un $perro; done

Mi mejor amigo es un labrador
Mi mejor amigo es un pastor mesoamericano
Mi mejor amigo es un xolo
```

**Preguntas**

1) ¿Cuándo debo usar comillas en la lista de elementos?

2) ¿Qué hace `;`?

Y un ejemplo más, usando rutas relativas:

```
for i in {1..100}; do
mkdir directorio$i;
cd directorio$i;
touch texto${i}ok.txt;
cd ../;
done
```

Lo cual hará 100 directorios (llamados directorio1, directorio2 y así) con un archivo de texto (llamados texto1, texto2,...) adentro. Si lo quieres repetir se usa el comando **-p** para sobre-escribir el contenido de cada directorio (a usar con cuidado!)

**NOTA IMPORTANTE: cuándo usar `${i}`**

Como habrás notado arriba, para llamar al elemento `i` dentro del loop a veces usamos solo `$i`, como en `mkdir directorio$i`. Pero también usamos `${i}` como en `touch texto${i}ok.txt`. Esto se debe a que `$i` funciona **solo si no tiene más texto después** (con la execpción de algunos caracteres, como `.`). Así bash puede distinguir entre una variable que se llame `$i` y otra que se llame `$ilusion`. Entonces para evitar errores es buena práctica utilizar `${nombre de la variable}`.

### Enlistar los elementos en una variable fuera del loop

Si nuestra lista de elementos es corta es fácil escribirla dentro del loop, pero si esta es muy larga o queremos hacer comentarios al respecto, puede ser útil que dicha lista se defina en una variable antes del loop, y que luego se llame en el loop.


**Crear variables**

* La sintaxis es **nombre de la variable** + `=` **el contenido de la variable, entre `" "`**
* NO debe haber espacios entre el símbolo = y la variable o su valor. 
* El nombre de la variable NO debe contener espacios.
* El nombre de la variable puede ser cualquier cosa que queramos **MENOS** el nombre de un comando que exista.



Ejemplo:

```
mi_var="gato"
```

Podemos crrear una variable con una lista de elementos para usarla en un for loop:

```
# Crear variable
VAR="2 3 4 6 7 9 19 39 49" 
for i in $VAR; do
echo "$i elefantes se columpiaban sobre la tela de una añaña"
done
```


### Crear arrays y utilizarlos como una lista en un loop

Quizá quieras correr algo sobre muchas variables, como los nombres de 30 muestras o poblaciones distintas. Esto puede resolverse utilizando comodines, si los nombres lo permiten, o alimentando al loop con un **arreglo**.

**Con comodines**

Por ejemplo si el loop lo quieres correr sobre puros archivos fasta que estén en un directorio. Ejemplo:

```
$ ls
VerdesFritos		jitomate.fasta		tomatesverdes.fasta
$ for i in *.fasta; do
> echo "El archivo $i es un fasta ejemplo"
> echo "Utilizamos al archivo $i en este loop"
> done
El archivo jitomate.fasta es un fasta ejemplo
Utilizamos al archivo jitomate.fasta en este loop
El archivo tomatesverdes.fasta es un fasta ejemplo
Utilizamos al archivo tomatesverdes.fasta en este loop
```

**Con arreglos**

Los arreglos (una "lista"). Se generan parecido a las variables, pero con un par de () para indicar que se trata de un arreglo.

```
$ a=( gato gatito gatón )
```

Luego para indicar dentro de un loop que `a` es un array, debemos utilizar la notación `${a[@]}`:

```
$ for i in ${a[@]}; do echo El $i hace miau; done
El gato hace miau
El gatito hace miau
El gatón hace miau
```

Un arreglo también puede ser el resultado de un comando, por ejemplo de `grep`, siguiendo la siguiente sintaxis `


**Leyendo desde un archivo**

Los arrays tienen sus problemas cuando son muy grandes y  es fácil cometer errores porque nunca "los vemos", por lo tanto mucha gente prefiere mejor leer los elementos directo de un archivo. Ejemplo:

```
$ grep -oE "\w+_[0-9]*" nuevos_final.fam > muestras.txt
$ for i in $(cat muestras.txt); do echo Hacer algo con la muestra $i; done
```

## Jueguito

Antes de ponerlos a programar for loops, recomiendo entender su lógica un poco mejor poniéndose a completar el jueguito Maze de [https://blocky-game.appspot.com/](https://blocky-game.appspot.com/). 
