

// Vamos a utilizar los datos de la tabla para controlar parámetros sonoros

/////////////////////////////////////////////////////////
//                                                     //
// .dP"Y8  dP"Yb  88b 88 88 888888 88  dP""b8    db    //
// `Ybo." dP   Yb 88Yb88 88 88__   88 dP   `"   dPYb   //
// o.`Y8b Yb   dP 88 Y88 88 88""   88 Yb       dP__Yb  //
// 8bodP'  YbodP  88  Y8 88 88     88  YboodP dP""""Yb //
//                                                     //
/////////////////////////////////////////////////////////


// Cargar archivo .txt

(
~allData = FileReader.read("/Users/xoanxil/Desktop/SONIFICACION | KRYSTALLOS/2003649_Cholesteryl_benzoate.txt"
, true, true).collect { |line, index| if (index == 0) {

// Convierte la primera línea de texto a símbolo

                line.collect (_.asSymbol)
        } {
// El resto de columns son números y las interpretamos como datos

                line.collect(_.interpret)
        }
};
)

/////////////////////////////////////////////////////////

// Leer columna como números enteros (para SC las columnas empiezan en 0)

~col4 = ~allData.flop[3].asInt

// Concatenar columnas

~col1 = ~allData.flop[0].asInt
~col2 = ~allData.flop[1].asInt
~col3 = ~allData.flop[2].asInt


// Concatenando columnas

~col1_2 = ~col1++~col2


// Ver todo el contenido de esta concatenación

Post << ~col1_2

/////////////////////////////////////////////////////////

// Varias formas de mapear datos

//1. Min-Max

~min = ~col4.minItem // duvuelve el valor más bajo
~max = ~col4.maxItem // devuelve el valor más bajo

// Mapeamos la columna 2 a un rango entre 20-90 después de convertir a números enteros y detectar el mínimo y el máximo

~col4.linlin(~min, ~max, 20, 90).asInt.postln


//2. Normalizamos entre 0 y 1 y luego convertimos a un rango de valores entre 20-90

~norm = ~col4.normalize
~col2norm = ~col4.linlin(0, 1, 40, 127)

// Seleccionar una serie de valores

~col1[9] // uno
~col1[8..10] // varios


/////////////////////////////////////////////////////////

// Convertir array de valores (columna) en una secuencia y en un stream para utilizar

~stream = Pseq(~col4.abs, 1).asStream; // una vuelta
~stream = Pseq(~col2.abs, inf).asStream; // cuando acaba empieza otra vez
~stream.next // valor a valor
~stream.nextN(5) // varios de 5 en 5

// Eliminamos duplicados

~secuencia = ~allData.flop[4].asInt.abs.as(Set).as(Array)

// Creamos la secuencia

~stream = Pseq(~secuencia, inf).asStream; // una vuelta


// Creamos sonido utiizando un instrumento por defecto incluido en SC

//Encendemos el servidor de audio

s.boot;

(
~patron = Pbind(\instrument, \default,
	\note, ~stream.cpsmidi,
	\octave, 4,
	\amp, 0.5,
	\dur, 0.2
).play
)

// Posibles comandos de control

~patron.play
~patron.stop

~patron.pause
~patron.start

~patron.mute
~patron.unmute
