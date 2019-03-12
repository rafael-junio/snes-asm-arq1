# To run
Just download any SNES emulator and load the "source.smc"
# To compile
Clone this repository on your linux (https://github.com/vhelin/wla-dx) and them on the root of the wla-dx repository:

cmake -G ''Unix Makefiles'' .
make
make install
wla-65816

After that you just need two commands to compile to the "source.smc"
sudo wla-65816 -v source.asm
wlalink -v sourcelink.link sourceCompiled.smc
