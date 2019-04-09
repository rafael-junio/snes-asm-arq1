# To run
Just download any SNES emulator and load the "sourceCompiled.smc"
# To compile
Clone this repository on your linux (https://github.com/vhelin/wla-dx) and them on the root of the wla-dx repository:

Linux
```
cmake -G ''Unix Makefiles'' . 
make 
make install 
wla-65816
```


After that you just need two commands to compile to the "source.smc"

```
sudo wla-65816 -v source.asm
wlalink -v sourcelink.link sourceCompiled.smc
```
Windows

```
Download the 9.8a version
http://www.villehelin.com/wla-win32.html
```
Put the files on the root folder:
```
wla-65816.exe
wlalink.exe
```
Use the folowing commands to compile and link:

```
wla-65816 -v source.asm
wlalink -v sourcelink.link sourceCompiled.smc
```
