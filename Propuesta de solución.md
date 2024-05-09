# Propuesta de diseño / solución
# Parte 1 - Interfaz SPI Maestro Generico

![image](https://user-images.githubusercontent.com/110439118/228861053-e63303fa-fe33-4a3b-b704-3373dd5ccd75.png)

En esta tabla se resume la maquina de estados de la interfaz. Consta de 3 estados: IDLE, WRITE y READ. El estado de IDLE es el estado inicial en el cual se espera el bit de send para proceder a comunicarse con algun dispositivo. Al recibir el bit de send, procede al estado WRITE. Aqui se envian o escriben datos dependiendo de n_tx_end. Hay un contador que lleva la cantidad de datos que se han escrito y el estado cambia a READ hasta que se alcance n_rx_end datos enviados. En READ se guardan los datos recibidos en los registros y vuelve al estado inical a esperar otra transaccion. 

![image](https://user-images.githubusercontent.com/110439118/232734536-606547fb-eb30-4851-bbc4-b2b4934366c7.png)

# Parte 2 - Interfaz UART:

Explicación de los estados.

S1. Espera:
La interfaz UART está esperando a que se le solicite la transmisión o recepción de datos. En este 
estado, el bit "send" del registro de control está en cero y el bit "new_rx" del registro de control
está en cero.

S2. Transmisión: La interfaz UART está transmitiendo datos a través del puerto serie. En este 
estado, el bit "send" del registro de control está en uno para indicar que se va a realizar una 
transmisión. El bloque de datos de salida está enviando el dato almacenado en el registro de datos 
cero y la interfaz UART está esperando la confirmación de que se ha transmitido correctamente.

S3. Recepción: La interfaz UART está recibiendo datos a través del puerto serie. En este estado, el 
bit "new_rx" del registro de control está en uno para indicar que se ha recibido un nuevo dato. La
unidad de control interna almacena el dato recibido en el registor de datos 1 y espera a que se lea 
el dato. Una vez que el dato ha sido leído, el bit "new_rx" del registro de control vuelve a cero para 
indicar que se ha completado la transacción.


Lógica de estados:

S1 -> S2:

Se activa el bit "send"

S2 -> S1:

Se espera a que se confirme la transmisi[on del dato y se desactiva "send"

S1 -> S3:

Se activa el bit "new_rx"

S3 -> S1:

Se espera a que se lea el dato almacenado en el registro de datos 1 y se desactiva el bit "new_rx"


![image](https://user-images.githubusercontent.com/88419042/228716770-9465a70a-3c9f-4523-bf56-ce3fbde68e04.png)


![image](https://user-images.githubusercontent.com/88419042/228716818-01d44ff6-6ebf-4f39-a4ca-de4bc93d1e55.png)


![image](https://user-images.githubusercontent.com/88419042/228726849-0173d9ea-4a24-44db-b51b-2ed9fcd9fd47.png)

![transmisor](https://user-images.githubusercontent.com/88419042/228729482-e8ec5d40-cbcd-46c6-8738-c2090194056f.png)

![image](https://user-images.githubusercontent.com/88419042/228729589-4cb0122e-1b4a-438d-b242-7817253ac0b6.png)

# Parte 3 Lectura de sensor de luminosidad

En esta parte se hará lectura del sensor de luminosidad mediante SPI, los datos obtenidos se envían tanto al display como a un convertidor a ASCII y estos entran al bloque UART que se encargará de enviar los datos hacia un Arduino, Raspberri Pi o una computadora.

A continuación se muestran los bloques a implementar:

![imagen](https://github.com/Shiofi/Pruebas/blob/main/FPGA.jpg)

Además se propone la siguiente máquina de estados:

![imagen](https://user-images.githubusercontent.com/39966622/228740460-f6d9c839-6394-4469-91c3-9f2273b863e0.png)

El estado Espera se encarga de indicar cuando pasó un segundo y se pasa al estado Leer sensor.

En Leer sensor, el bloque SPI hace lectura del sensor y envía los datos a los displays y se pasa al estado UART

En el estado UART se envían los datos por el puerto serie y si se confirma la llegada de los datos entonces vuelve al estado espera.

