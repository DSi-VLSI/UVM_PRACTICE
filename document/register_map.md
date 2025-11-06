# UART Register Map

This document describes the memory-mapped registers for the UART peripheral interface.

## Register Summary

| Offset | Register Name      | Access | Width | Reset Value | Description                              |
|--------|-------------------|--------|-------|-------------|------------------------------------------|
| 0x00   | UART_ENABLE       | R/W    | 1     | 0x0         | UART interface enable control            |
| 0x04   | CLK_DIVISOR       | R/W    | 32    | 0x28B1      | Baud rate clock divisor                  |
| 0x08   | PARITY_CTRL       | R/W    | 2     | 0x0         | Parity configuration control             |
| 0x0C   | STOP_BITS         | R/W    | 1     | 0x0         | Stop bit configuration                   |
| 0x10   | TX_FIFO           | W      | 8     | N/A         | Transmit FIFO data buffer                |
| 0x14   | TX_COUNT          | R      | 8     | 0x0         | Transmit FIFO occupancy counter          |
| 0x18   | RX_FIFO           | R      | 8     | N/A         | Receive FIFO data buffer                 |
| 0x1C   | RX_COUNT          | R      | 8     | 0x0         | Receive FIFO occupancy counter           |

## Register Descriptions

### UART_ENABLE (0x00)
**Access:** Read/Write  
**Width:** 1 bit  
**Reset Value:** 0x0

Enables or disables the UART peripheral.

| Bit | Name   | Access | Reset | Description                                    |
|-----|--------|--------|-------|------------------------------------------------|
| 0   | ENABLE | R/W    | 0     | 0: UART disabled<br>1: UART enabled            |

---

### CLK_DIVISOR (0x04)
**Access:** Read/Write  
**Width:** 32 bits  
**Reset Value:** 0x28B1 (10417 decimal)

Configures the baud rate clock divisor. The divisor determines the UART communication speed based on the system clock frequency.

**Formula:** `Baud Rate = System Clock / CLK_DIVISOR`

| Bits  | Name        | Access | Reset  | Description                     |
|-------|-------------|--------|--------|---------------------------------|
| 31:0  | CLK_DIVISOR | R/W    | 10417  | Clock divisor value             |

---

### PARITY_CTRL (0x08)
**Access:** Read/Write  
**Width:** 2 bits  
**Reset Value:** 0x0

Controls parity checking for error detection.

| Bit | Name        | Access | Reset | Description                                          |
|-----|-------------|--------|-------|------------------------------------------------------|
| 0   | PARITY_EN   | R/W    | 0     | 0: Parity disabled<br>1: Parity enabled              |
| 1   | PARITY_TYPE | R/W    | 0     | 0: Even parity<br>1: Odd parity                      |

---

### STOP_BITS (0x0C)
**Access:** Read/Write  
**Width:** 1 bit  
**Reset Value:** 0x0

Configures the number of stop bits transmitted after each data frame.

| Bit | Name      | Access | Reset | Description                                    |
|-----|-----------|--------|-------|------------------------------------------------|
| 0   | STOP_BITS | R/W    | 0     | 0: 1 stop bit<br>1: 2 stop bits                |

---

### TX_FIFO (0x10)
**Access:** Write-Only  
**Width:** 8 bits  
**Reset Value:** N/A

Transmit FIFO buffer. Writing to this register pushes data into the transmit queue. Data is automatically transmitted when the UART is enabled.

| Bits | Name    | Access | Reset | Description                           |
|------|---------|--------|-------|---------------------------------------|
| 7:0  | TX_DATA | W      | N/A   | Data byte to transmit                 |

---

### TX_COUNT (0x14)
**Access:** Read-Only  
**Width:** 8 bits  
**Reset Value:** 0x0

Reports the current number of bytes stored in the transmit FIFO buffer.

| Bits | Name     | Access | Reset | Description                              |
|------|----------|--------|-------|------------------------------------------|
| 7:0  | TX_COUNT | R      | 0     | Number of bytes in TX FIFO (0-255)       |

---

### RX_FIFO (0x18)
**Access:** Read-Only  
**Width:** 8 bits  
**Reset Value:** N/A

Receive FIFO buffer. Reading from this register pops the oldest received byte from the queue.

| Bits | Name    | Access | Reset | Description                           |
|------|---------|--------|-------|---------------------------------------|
| 7:0  | RX_DATA | R      | N/A   | Received data byte                    |

---

### RX_COUNT (0x1C)
**Access:** Read-Only  
**Width:** 8 bits  
**Reset Value:** 0x0

Reports the current number of bytes available in the receive FIFO buffer.

| Bits | Name     | Access | Reset | Description                              |
|------|----------|--------|-------|------------------------------------------|
| 7:0  | RX_COUNT | R      | 0     | Number of bytes in RX FIFO (0-255)       |
