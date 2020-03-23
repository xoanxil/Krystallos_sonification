

// Utilizando los datos de la tabla para generar audios = audificación con varias aproximaciones a la síntesis wavetable


///////////////////////////////////////////////////////////
//                                                       //
//   db    88   88 8888b.  88 888888 88  dP""b8    db    //
//  dPYb   88   88  8I  Yb 88 88__   88 dP   `"   dPYb   //
// dP__Yb  Y8   8P  8I  dY 88 88""   88 Yb       dP__Yb  //
//dP""""Yb `YbodP' 8888Y"  88 88     88  YboodP dP""""Yb //
//                                                       //
///////////////////////////////////////////////////////////


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

s.boot //encendemos el servidor de audio

/////////////////////////////////////////////////////////
//                 ENTENDIENDO SINEFILL                //
/////////////////////////////////////////////////////////

b = Buffer.alloc(s, 2048); // creamos una tabla vacía


// un ejemplo de como funciona

(
~sig = Signal.sineFill(1024, [1], [0]); // el tamaño que suele funcionar mejor entre 128 y 8.192. El tamaño de 1024 suele funcionar bien
~wt = ~sig.asWavetable; // la convertimos en un formato wavetable legible
b.loadCollection(~wt)
)

b.plot;

~sig.plot // con la señal lo vemos más claro

(
~sig = Signal.sineFill(1024,
	[1, 1/4, 1/6, 1/2],
	0!4);
~wt = ~sig.asWavetable;
b.loadCollection(~wt)
)

b.plot;
~sig.plot

play{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.5)} // osc lee esta array como un ciclo de onda

// ejemplo utilizando ahora las columnas de la tabla pàra generar una onda

~col = ~allData.flop[4][1..2048].asInt // se puede seleccionar el mismo númerodde valores que tiene el buffer
~col.size

~sig = Signal.sineFill(2048, ~col)

~wt = ~sig.asWavetable
b.loadCollection(~wt)

b.plot

play{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.5)} // osc lee esta array como un ciclo de onda

b.sine3(~col, [1], [0], asWavetable:true) // esta otra forma de crear la array permite más parámetros (freq, amps, phases, normalize)

b.plot

play{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.5)} // osc lee esta array como un ciclo de onda. Esto puede generar aliasing en las frecuencias más agudas

play{Osc.ar(b, MouseX.kr(100, 1000, 1)*[1, 2.01], mul: 0.5)} //desafinando un poco derecha e izquierda


/////////////////////////////////////////////////////////
//                    USANDO ENV                       //
/////////////////////////////////////////////////////////

b = Buffer.alloc(s, 2048); // creamos una tabla vacía

e = Env (~col, ~col, \lin).plot

(
var env, sig, wt;
env = Env (~col * [1, -1], ~col, \lin); // \sine redondea los valores o también podemos poner una array y multiplicando por [1, -1] hacemos un leak DC para centrar la onda
sig = env.asSignal(2048);
wt = sig.asWavetable;
b.loadCollection(wt);
)


play{LeakDC.ar(Osc.ar(b, MouseX.kr(100, 1000, 1)*[1, 2.01], mul: 0.01))} // LeakDc centra la onda

s.scope
FreqScope.new

play{Osc.ar(b, MouseX.kr(100, 1000, 1)*[1, 2.01], mul: 0.5)} //desafinando un poco derecha e izquierda

