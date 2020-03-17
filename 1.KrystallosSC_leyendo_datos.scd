// Tanto pra poder sonificar como audificar datos necesitamos acceder a los datos.

// A continuaión veremos cómo extraer estos datos tanto de archivos CSV como TXT

//Puedes ver los resultados de las lecturas en la Post Window

////////////////////////////////////////////////
//       dP            dP                     //
//       88            88                     //
// .d888b88 .d8888b. d8888P .d8888b. .d8888b. //
// 88'  `88 88'  `88   88   88'  `88 Y8ooooo. //
// 88.  .88 88.  .88   88   88.  .88       88 //
// `88888P8 `88888P8   dP   `88888P' `88888P' //
//                                            //
////////////////////////////////////////////////

///////////////////////////////////////////////
/////////////// ARCHIVOS CSV //////////////////
///////////////////////////////////////////////

//Asignamos una variable a la dirección en la que se encuentra nuestro archivo csv (podemos arrastrar el archivo hasta aquí para obtener su ubicación)

~csv = "/Users/xoanxil/Downloads/geographic-units-by-industry-and-statistical-area-2000-19-descending-order/DimenLookupYEAR7602.csv"

//Si tenemos este archivo de SC en la misma carpeta podemos poner el siguiente código

~csv = thisProcess.nowExecutingPath.dirname +/+ "DimenLookupYEAR7602.csv"

//Cargamos el archivo en la variable x (puede llevarle un poco de tiempo)

x = CSVFileReader.read(~csv, true).postcs

//Leemos el valor una fila como una Array (la primera es la 0)

x[0]

//Podemos leer varias filas como Arrays separadas por comas

x[1..3]

//Con este código podemos eliminar la primera línea

x = x[1..x.size-1]

//Sin mucho los datos puede que sólo muestre unos cuantos y ponga "etc". Si queremos verlos todos podemos utilizar el siguiente código

Post << x[1]

//Si en vez de ver líneas queremos acceder a la columnas utilizamos .flot

x.flop[0].asInt

//Podemos escoger cual y convertirlo a números decimales o a enteros

x.flop[0].asInt
x.flop[0].asFloat


///////////////////////////////////////////////
/////////////// ARCHIVOS TXT //////////////////
///////////////////////////////////////////////

//En el caso de archivos TXT extraidos del powder defraction patterns de los cristales a través del rpograma Vesta podemos utlizar este código

(
~allData = FileReader.read("/Users/xoanxil/Desktop/SONIFICACION | KRYSTALLOS/CuC10_polimorfo_A_Filtrado_H.txt"
, true, true).collect { |line, index| if (index == 0) {

// Convierte la primera línea de texto a símbolo

                line.collect (_.asSymbol)
        } {
// El resto de columns son números y las interpretamos como datos

                line.collect(_.interpret)
        }
};
)


//Así leemos las líneas

~data = ~allData[2]; // Leemos las línea  (En cualquier índice el primer valor es "0")

//Así las columnas

~allData.flop[2] // leemos las columnas
~allData.flop[3].asFloat // convierte a decimales

//Conversiones

~allData[0].asFloat //decimales
~allData[0].asInt //números enteros
~allData.abs[1] //valores absolutos

//Visualizando en una gráfica con .plot

~allData.flop[0].asFloat.plot // muestra gráfico
~allData[0..3].asFloat.plot // mostrar varios gráficos

//

//Asignamos una columna a una variable

~col2 = ~allData.flop[0].asFloat

// Normalizmos (convertimos de 0 a 1 para facilitar la lectura de datos)

~normalize = ~col2.normalize
~normalize.plot

// Usando .linlin podemos mapear estos valores a otros que nos resulten útiles para controlar los parámetros que necesitemos

~midinote2 = ~normalize.linlin(0, 1, 40, 90)


~normalize = ~col3.normalize
~normalize.plot
~normalize3 = ~col3.normalize
~midinote3 = ~normalize.linlin(0, 1, 40, 90)
