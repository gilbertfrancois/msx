# MSX assembly programs

This is an exploration on how to develop asm for MSX, using an assembler on another platform, like Linux or macOS. These programs are written for the **vasm** assembler. The `bin` folder contains an installation script for the vasm assembler, in case you need it.



Compiling e.g. `helloworld.asm` can be done with:

```sh
export PROJECT_ROOT=<PATH TO MY MSX PROJECT FOLDER>

cd ${PROJECT_ROOT}/src/asm

vasmz80_oldstyle helloworld.asm \
      -chklabels -nocase \
      -Dvasm=1 -DbuildMSX=1 -DBuildMSX_MSX1=1 -Fbin \
      -L ${PROJECT_ROOT}/build/listing.txt \
      -I ${PROJECT_ROOT}/lib/chibiakumas/SrcALL \
      -I ${PROJECT_ROOT}/lib/chibiakumas/SrcMSX \
      -o ${PROJECT_ROOT}/build/cart.rom
```

where `${PROJECT_ROOT}` is the location of this `msx` repository. The compiled rom file will be in the folder `${PROJECT_ROOT}/build/cart.rom`.

To run the rom file with openMSX, run the command:

```sh
openmsx -machine Canon_V-20 -cart ${PROJECT_ROOT}/build/cart.rom
```



### Hello World

[helloworld.asm](helloworld.asm) This program is meant as template for building MSX rom cartridge images with vasm assembler. It makes use fof macros, made available by chibiakumas. 

### Screen 2 test

[sc2.asm](sc2.asm) Test for drawing pixels in screen 2 (WIP).
