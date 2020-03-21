

// Utilizando los datos de la tabla para generar audios = audificación

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

// Crear una onda de audio a partirde de una table en la que se almacenan los valores de la columna [5] y ver su representación

Wavetable.sineFill(512, 1.0/~allData.flop[4].asInt.lincurve(0, 90, 60, 800)).plot;

Wavetable.sineFill(512, 1.0/~allData.flop[4].asInt.lincurve(0, 90, 60, 800)).asSignal.play; // audificación


// Asignar a una variable

a = Wavetable.sineFill(1024, 1.0/~allData.flop[4].asInt.lincurve(0, 4, 600, 8000)).asSignal.play; // audificación diferente resolución cambiando por potencia de 2 el tamaño de la tabla

//( https://en.wikipedia.org/wiki/Power_of_two)

// Reproducirlo

a.play
b.play

// Reproduciendo la onda en loop

play{PlayBuf.ar(1, b, 1, Impulse.kr(90), 1, loop:1)}

// Leyendo el audio variando aleatoriamente la posición de inicio y moviéndose en el espectro estereo

play{Pan2.ar(PlayBuf.ar(1, b, 90, Impulse.kr(90), WhiteNoise.ar, loop:1), SinOsc.kr(0.2))} // reproduciendo la onda