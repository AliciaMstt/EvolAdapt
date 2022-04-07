# Organización de un proyecto bioinformático

Recordemos lo ya mencionado en clases previas:

Un proyecto bioinformático consiste en los datos crudos, datos procesados, scripts y documentación  necesarios para reproducir los análisis realizados. Es decir en todo lo que al final debes subir a un repositorio como [Dryad](https://www.datadryad.org/pages/organization) (aunque los datos pueden conectarse desde otros repos, como [SRA](https://www.ncbi.nlm.nih.gov/sra), claro). 

### Organización de directorios 

Un proyecto bioinformático debe tener su propio **directorio** (carpeta) y contener en subdirectorios **todo** lo necesario para realizarlo.

El directorio del proyecto debe dividirse a su vez, lo recomendable es que sea en **subdirectorios** parecidos a los siguientes:

* **data**, contiene los datos, también puede tener otros nombres como *genetic* para datos genéticos y *spatial* para datos espaciales. Los datos genéticos pueden dividierse a su vez en subdirectorios como *raw*, *filtered*, *genotypes*, *data_in*, *data_out* de modo que los datos crudos estén en un directorio y los modificados por análisis subsecuentes en otros directorios. El punto es tener uno o más directorios donde estén todos los datos.  

* **meta**, **info** o **docs** donde puedes guardar todos los metadatos, como un archivo cvs detallando información de cada una de las muestras. Si lo prefieres este archivo puede ir dentro del directorio de datos sin necesidad de hacer la carpeta *meta*. También es posible guardar aquí cualquier otro documento necesario para procesar los datos.
  		
* **bin** o **scripts**, donde guardas todos los scripts necesarios para correr el análisis de principio a fin. Este es un directorio obligatorio. Esta es la carpeta más difícil de documentar.

* **figures**, opcionalmente, puedes poner aquí el código que se utilice sólo para hacer las figuras de una publicación dada. Es como un extracto de *bin* dedicado solo a esto.

* **archive** este directorio NO se sube al repositorio, pero es bueno tenerlo para ir poniendo ahí scripts y resultados que crees no necesitar más pero que es bueno no borrar por completo.

También es posible tener un directorio para cada subanálisis concreto, por ejemplo uno para *stacks* y otro para *admixture*, pero dentro de cada uno de ellos subdirectorios como los anteriores. 

Independientemente del nombre que escojamos para los directorios y archivos, qué es qué y dónde está cada cosa debe ir explicado en un **README**.

Para ver un ejemplo de un repositorio organizado así, baja la sección **Data and scripts for population genomics and SDM** de [este repo de Dryad](https://www.datadryad.org/resource/doi:10.5061/dryad.f7248) (El archivo que se llama ++PopGenomicsIBR.zip++).

### ¿Cómo ocupar mis datos en `data` si mis scripts están en `scripts`?

Todos tus scripts deben estar guardados en un directorio que se llame `scripts` o `bin`. **Tus scripts deben correr asumiendo que ESE es el working directory**. Entonces, para poder ocupar datos que esstén en la carpeta `data` debes ocupar rutas relativas.

Ejemplo:

`bin` y `data` son dos directorios que están al mismo nivel:

```
$ ls 
bin data
```

Si estás adentro de `bin` puedes leer o escribir dentro de `data` usando rutas relativas:

```
$ cd bin
ls ../data
datos.txt
```

Es decir, para correr tus scripts **desde bin** y leer/guardar datos en `data` solo debes agregar `../data/` antes del nombre de tus archivos. Ejemplo

`../data/datos.txt`


### Pipelines de scripts


La *programación modular* se refiere a subdividir un programa de cómputo en varios sub-programas separados.

Ventajas: 

* Es más fácil leer (y escribir) el código.
* Permite revisar el output de pasos complejos antes de enviarlos al siguiente paso.
* Si algo falla es más fácil identificar qué fue.
* Permite tener más de una opción de programas para realizar el análisis completo (e.g. demultiplexeo en un programa, alineación en otro).
* Permite volver a correr las partes del proceso que queremos, y no toooodo desde el inicio otra vez.

A la secuencia completa de módulos necesarios para completar un análisis se le conoce como **pipeline** (de ahí el nombre del símbolo **|**).

De modo que en vez de tener un único script que lo haga todo, un script puede realizar un análisis sencillo, complejo o "disparar" otros scripts. También es posible que algunos de tus scripts sean *funciones* a ser utilizadas por otros scripts (por ejemplo con el comando `source()` en R).

Una buena práctica es **no** escribir scripts bíblicos que lo hagan todo, sino ir partiendo el análisis por "módulos". 

Una vez que tenemos listos los scripts de todos los pasos de un análisis es posible "enlazarlos" en la **pipeline** completa, que los corra todos uno detrás de otro en el orden adecuado.

Ventajas:

-  Prueba de que todo funciona y de que no dejamos scripts basura en el camino
-  Garantiza que los resultados finales son el resultado de los análisis que estamos documentando en nuestros scripts
-  Garantiza reproducibilidad de resultados

Desventajas:

- Utiliza tiempo de cómputo para correr

Normalmente no lo correrías cada vez (para eso están los módulos) sino que sirve para probar al final, antes de publicarlo, que efectivamente tus análisis son reproducibles.

**Pregunta**: ¿en qué módulos podrías dividir tu proyecto?

Si tienes muchos scripts, es buena práctica numerarlos en el nombre del archivo, para que sea más fácil recordar cuál va primero. Ejemplo:

```
1_getdata.sh
2_cleaning.sh
3_denovo.sh
4_snpcalling.sh
5_admixture.sh
6_exploratoryplots.Rmd
7_outlierstest.R
```




### Documentación de scripts y del proyecto

**Documentar** permite que otrxs entiendan qué hace cada parte de nuestro código y cómo. Un proyecto bien documentado incluye:

* **Código comentado y organizado en scripts** 

* **README** 


#### README
	* "Leeme".
	* Un archivo de texto (no Word, pero puede ser MarkDown) que detalla:
   * **Qué hay** dentro del repositorio (y cada uno de sus directorios).
   * **Qué hacen** cada una de las funciones/scripts del repositorio. Esto _debe_ incluir: cuál es el input, cuál es el output, qué hace el script en palabras sencillas y cómo se relaciona con los métodos / Figuras del artículo.
   * **Cómo y en qué órden** deben ocuparse los scripts para realizar los análisis
* Ejemplo:
    * [Este](https://datadryad.org/resource/doi:10.5061/dryad.f7248) repositorio de datos está dividido en varias secciones. El README de última sección "Data and scripts for population genomics and SDM" se ve así: [README_ejemplo](README_ejemplo.md).

    
**Ejercicio**: baja el archivo zip (los datos y scripts) asociados al README anterior y compáralo con el README. Responde:

* ¿Puedes encontrar los datos que ocupa para correr cada script? 
* Brinda un ejemplo de rutas relativas
* Encuentra un ejemplo de for loops que utilice varios comandos y variables dentro de un loop.
