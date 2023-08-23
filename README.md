# VeriQuiz1 diseño y verificacion de una FIFO

## 1. Desarrollo

### 1.1 Modulo "Registro"

Es un simple flip_flop parametrizable por medio de `N`, su implementacion es a traves de un always secuencial que reacciona al posedge del clock, en el momento que recibe un posedge, coloca la entrada en la salida.

### 1. Encabezado del modulo

```SystemVerilog
module Registro #( parameter N = 32)
    (
    input  logic         rst_i, 
    input  logic         push_i, //Entrada que al ser verdadera entoncer manda el valor a la salida
    input  logic [N-1:0] data_i,
    output logic [N-1:0] data_o
    );
```

### 2. Parametros
- `N`: Indica el tamaño de los registros.

### 3. Entradas y salidas:

- `rst_i`: reset del registro
- `push_i`: valor que guarda el valor de entrada en el registro
- `data_i`: dato que se va a guardar
- `data_o`: salida que reflejara la entrada en el momento que se guarde


### 1.2 Modulo "Registros"

Modulo que mediante un generate toma el modulo `registros` y conecta varios entre si, precisamente conecta la salida del anterior con la entrada del siguiente y asi sucesivamente

### 1. Encabezado del modulo

```SystemVerilog
module Registros#( parameter WIDTH = 32, DEPTH = 4 ) //Derecha ancho del vector
                                                      //Izquierda Tama?o de los registros 
    (
    input  logic                            rst_i,
    input  logic                            push_i,
    input  logic [WIDTH - 1:0]              data_i,  // Dato que entra al primer flip flop  
      
    output logic [DEPTH - 1:0][WIDTH - 1:0] data_o   //Salida de este modulo.
    );
```

### 2. Parametros
- `DEPTH`: indica la cantidad de registros
- `WIDTH`: indica el tamaño del registro

### 3. Entradas y salidas:

- `rst_i`: reset del registro
- `push_i`: valor que guarda el valor de entrada en el registro
- `data_i`: dato que se va a guardar
- `data_o`: cadena de registros.

### 1.3 Modulo "control_fifo"

Diseñado mediante una maquina de estados, cada combinacion de entrada de push y pop, genera una salida especifica que controla el comportamiento de los registros y el multiplexor

### 1. Encabezado del modulo

```SystemVerilog
module control_fifo #(parameter WIDTH = 32, DEPTH = 16)
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input logic                             pop_i,
    
    output logic                            full_o,
    output logic                            pnding_o,
    output logic [$clog2(DEPTH) - 1:0]      selmux_o,
    output logic                            rst_reg_o
    
    );
```

### 2. Parametros
- `DEPTH`: indica la cantidad de registros
- `WIDTH`: indica el tamaño del registro

### 3. Entradas y salidas:

- `clk_i`: reloj
- `rst_i`: reset del registro
- `push_i`: valor que guarda el valor de entrada en el registro
- `pop_i`: señal que saca los datos de los registros
- `full_o`: señal que indica que ya los registros estan llenos
- `pnding_o`: indica si hay datos que pueden ser procesados, si es 0 los registros estan vacios.
- `selmux_o`: selecciona el valor de los registros.
- `rst_reg_o`: es 1 cuando se hace un pop y ya el contador es 0 por lo que reinicia todos los registros dejandolos vacios por completo.


### 1.4 Modulo "fifo_top"

Modulo que conecta todos los registros con el multiplexor que se establecio como un solo assign que guarda el valor de la salida segun un indice dado por el modulo de contro

### 1. Encabezado del modulo

```SystemVerilog
module fifo_top #(parameter WIDTH = 32, DEPTH = 4)
    (
    input  logic                            clk_i,  
    input  logic                            rst_i,  
    input  logic                            push_i, 
    input  logic [WIDTH - 1:0]              data_i,  //Dato de entrada que se le hara push
    input  logic                            pop_i,
    
    output logic [WIDTH - 1:0]              data_o,  //Dato de salida despues de hacer pop
    output logic                            full_o,  //Señal de que los registros ya estan llenos 
    output logic                            pnding_o //Señal de que hace falta agregar datos

);
```

### 2. Parametros
- `DEPTH`: indica la cantidad de registros
- `WIDTH`: indica el tamaño del registro

### 3. Entradas y salidas:

- `clk_i`: reloj
- `rst_i`: reset del registro
- `push_i`: valor que guarda el valor de entrada en el registro
- `pop_i`: señal que saca los datos de los registros
- `data_i`: dato que entra a los registros
- `data_o`: dato que sale del mux
- `full_o`: señal que indica que ya los registros estan llenos
- `pnding_o`: indica si hay datos que pueden ser procesados, si es 0 los registros estan vacios.

### 4. Criterio de diseño
El diseño de la fifo esta basada en el siguiente diagrama de bloques.

![fifo_BD](https://github.com/Jeremy185/VeriQuiz1/blob/15b142f0191c177260a61b8839d578aafa6e2aef/Imagenes/block_diagram.png)

### 5. Testbench








