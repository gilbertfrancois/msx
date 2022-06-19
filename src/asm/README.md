# MSX assembly programs

This is an exploration on how to develop asm for MSX, using an assembler on another platform, like Linux or macOS. These programs are written for the **glass** assembler. The `bin` folder contains an installation script for the glass assembler, in case you need it. As a bonus, some files are for the **vasm** assembler, used by Chibiakumas. 


Compiling with **glass**  can be done with:

```
export PROJECT_ROOT=<PATH TO MY MSX PROJECT FOLDER>

cd ${PROJECT_ROOT}/src/asm

java -jar ${PROJECT_ROOT}/bin/glass.jar my_program.asm \
	-L listing.txt \
	${PROJECT_ROOT}/build/cart.rom
```


Compiling source code with **vasm** can be done with:

```sh
export PROJECT_ROOT=<PATH TO MY MSX PROJECT FOLDER>

cd ${PROJECT_ROOT}/src/asm

vasmz80_oldstyle my_program.asm \
      -chklabels -nocase -Dvasm=1 -Fbin \
      -L ${PROJECT_ROOT}/build/listing.txt \
      -o ${PROJECT_ROOT}/build/cart.rom
```

where `${PROJECT_ROOT}` is the location of this `msx` repository. The compiled rom file will be in the folder `${PROJECT_ROOT}/build/cart.rom`.

To run the rom file with openMSX, run the command:

```sh
openmsx -machine Canon_V-20 -cart ${PROJECT_ROOT}/build/cart.rom
```
