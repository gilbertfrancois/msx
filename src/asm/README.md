# MSX assembly programs

This is an exploration on how to develop asm for MSX, using an assembler on another platform, like Linux or macOS. These programs are written for the **vasm** assembler or **glass** assembler. The `bin` folder contains an installation script for the vasm and glass assembler, in case you need it.



Compiling source code with **vasm** can be done with:

```sh
export PROJECT_ROOT=<PATH TO MY MSX PROJECT FOLDER>

cd ${PROJECT_ROOT}/src/asm

vasmz80_oldstyle my_program.asm \
      -chklabels -nocase \
      -Dvasm=1 -DbuildMSX=1 -DBuildMSX_MSX1=1 -Fbin \
      -L ${PROJECT_ROOT}/build/listing.txt \
      -I ${PROJECT_ROOT}/lib/chibiakumas/SrcALL \
      -I ${PROJECT_ROOT}/lib/chibiakumas/SrcMSX \
      -o ${PROJECT_ROOT}/build/cart.rom
```

where `${PROJECT_ROOT}` is the location of this `msx` repository. The compiled rom file will be in the folder `${PROJECT_ROOT}/build/cart.rom`.



Compiling with **glass**  can be done with:

```
export PROJECT_ROOT=<PATH TO MY MSX PROJECT FOLDER>

cd ${PROJECT_ROOT}/src/asm

java -jar ${PROJECT_ROOT}/bin/glass.jar my_program.asm ${PROJECT_ROOT}/build/cart.rom
```



To run the rom file with openMSX, run the command:

```sh
openmsx -machine Canon_V-20 -cart ${PROJECT_ROOT}/build/cart.rom
```



### Hello World

[helloworld.asm](helloworld.asm) This program is meant as template for building MSX rom cartridge images with vasm assembler. It makes use of macros, made available by chibiakumas. 

### Screen 2 test

[sc2.asm](sc2.asm) Test for drawing pixels in screen 2 (WIP).
