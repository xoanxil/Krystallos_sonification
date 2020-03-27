

// Utilizando los datos de la tabla para generar audios = audificación procesandolo el resultado a tavés de síntesis granular


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

s.boot //encender el servidor de audio

// ejemplo utilizando ahora las columnas de la tabla pàra generar una onda

~col = ~allData.flop[4][1..2048].asInt // se puede seleccionar el mismo númerodde valores que tiene el buffer

~sig = Signal.sineFill(2048, ~col)

~wt = ~sig.asWavetable
b.loadCollection(~wt)

b.plot

/////////////////////////////////////////////////////////
//                   PROCESADO GRANULAR                //
/////////////////////////////////////////////////////////

// prueba r´pida con función

{TGrains.ar(2, Dust.ar(20),b, 1, Saw.kr(0.1), 0.01, WhiteNoise.ar)*4}.play


// encapsulado en un SynthDef

(
SynthDef(\grainbuf, {|amp 0.1, gate  1, rate = 1, buf a, dur = 1, pos = 0|
	var env, sig, trig;
	env = EnvGen.kr(Env.asr(1, 0.9, 1), gate, doneAction:2);
	trig =Dust.kr(10);
	sig = Resonz.ar(GrainBuf.ar(2, trig, dur, buf, rate, pos), 400);
	Out.ar(0, sig*amp*env);
}).add
)

~grain = Synth(\grainbuf)

// lanzar el play y luego actualizamos con el stream

(
e = Pbind(
    \instrument, \grainbuf,
	\dur, 1, // or for more "human" timing, try   Pwhite(0.2, 0.5, inf)
	\amp, 0.4,
	\pos, Pseq(~allData.flop[4].asInt.lincurve(0, 90, 60, 800), 1),
	\rate, Pseq(~allData.flop[1].asInt.lincurve(0, 90, 60, 800), 1);
).play; // returns an EventStream
)


~min = ~allData.flop[2].asInt.minItem
~max = ~allData.flop[2].asInt.maxItem


// hacer cambios sobre la marcha

(
e.stream = Pbind(
	\instrument, \grainbuf,
	\dur, Pseq(~allData.flop[2].asInt.lincurve(~min, ~max, 0, 0.1), 1),
	\amp, 3,
	\pos, Pseq(~allData.flop[2].asInt.lincurve(~min, ~max, 0, 1024), 1),
	\rate, Pseq(~allData.flop[2].asInt.lincurve(~min, ~max, 0, 127), 1).midicps, //midicps genera un resultadp más "musical"
).asStream;
)

// cambiar buffers si tenemos varios cargados

~grain.set(\buf, a)

e.play
e.stop
e.reset
e.mute;
e.unmute;
