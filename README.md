# Advanced Encryption Standard Encoding 🗜️

This project is an application of the Advanced Encryption Standard encoding using the hardware language SystemVerilog. This project can encrypt sensitive data using a secret key. AES helps protect data from being stolen, altered or compromised. This project is simulated with ModelSim and synthesized with VCS Synopsys.

## Introduction 📚

AES is a block cipher algorithm that was chosen as the standard encryption algorithm by the U.S. government in 2001. AES was developed by two Belgian cryptographers, Joan Daemen and Vincent Rijmen, based on their Rijndael algorithm. AES can use keys of 128, 192 or 256 bits to encrypt and decrypt data blocks of 128 bits. AES operates in rounds, each round consisting of four main steps: byte substitution (SubBytes), row shift (ShiftRows), column mix (MixColumns) and key addition (AddRoundKey). The number of rounds depends on the key length, specifically 10 rounds for 128-bit keys, 12 rounds for 192-bit keys and 14 rounds for 256-bit keys. AES is considered one of the strongest encryption algorithms today, widely used in many fields such as military, government, finance, network security and communication.

## Requirements 🛠️

To run this project, you need:

- A computer with ModelSim and VCS Synopsys installed.
- A string text of characters not exceeding 128 bit to encode.
- A key 128 bits, 192 bits or 256 bits.
- 2 bits to select type of key

## Installation and Usage 🚀

To install and use this project, you can follow these steps:

1. Clone this repository to your computer using the command:

```bash
git clone https://github.com/Binh-Diep/encryption-aes.git
```
2. Create the project on ModelSim

3. Add existing files (.sv)

4. Run the testbench file to check results of modules on ModelSim

5. Check results displaying on Simulation window with referrence document

## Technologies and Tools 🛠️

This project uses following technologies and tools:

- SystemVerilog - Hardware language for design and simulation
- ModelSim - Tool for compiling and simulating SystemVerilog
- VCS synopsys - Tool for synthesizing circuit

References 📚

To learn more about AES coding algorithm and how to apply it with SystemVerilog, you can refer to the following materials:

AES coding - Wikipedia
SystemVerilog Tutorial for beginners - ChipVerify
AES in SystemVerilog - YouTube