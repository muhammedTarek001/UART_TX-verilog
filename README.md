# UART_TX-verilog

Specifications: -
- UART TX receive the new data on P_DATA Bus only when
Data_Valid Signal is high.

- Registers are cleared using asynchronous active low reset
- Data_Valid is high for only 1 clock cycle

- Busy signal is high as long as UART_TX is transmitting the frame,
otherwise low.

- UART_TX couldn't accept any data on P_DATA during UART_TX
processing, however Data_Valid get high.

- S_DATA is high in the IDLE case (No transmission).

- PAR_EN (Configuration)
0: To disable frame parity bit
1: To enable frame parity bit

- PAR_TYP (Configuration)
0: Even parity bit
1: Odd parity bit


All Expected Output Frames: -

1. Data Frame (in case of Parity is enabled & Parity Type is even)
– One start bit (1'b0)
– Data (LSB first or MSB, 8 bits)
– Even Parity bit
– One stop bit

2. Data Frame (in case of Parity is enabled & Parity Type is odd)
– One start bit (1'b0)
– Data (LSB first or MSB, 8 bits)
– Odd Parity bit
– One stop bit

3. Data Frame (in case of Parity is not Enabled)
– One start bit (1'b0)
– Data (LSB first or MSB, 8 bits)
– One stop bit
