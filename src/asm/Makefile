ASM="vasmz80_oldstyle"
DIST_DIR="../../dist"
DOS1_DIR="../../dist/msxdos1"
DOS2_DIR="../../dist/msxdos2"
ROM_DIR="../../dist/rom"
CAS_DIR="../../dist/cas"
BIN_DIR="../../dist/bin"

ASM_FLAGS=-Fbin -chklabels -nocase
# ASM_FLAGS=-Fbin -chklabels -nocase -DDEBUG=1

# helloworld: 01_helloworld/helloworld_bin.asm
# 	$(ASM) -Fbin -o ${DIST_DIR}/helloworld.bin 01_helloworld/helloworld_bin.asm

all: helloworld helloscreen2 ifthenelse

folders:
	mkdir -p ${DIST_DIR}
	mkdir -p ${DOS1_DIR}
	mkdir -p ${DOS2_DIR}
	mkdir -p ${ROM_DIR}
	mkdir -p ${CAS_DIR}
	mkdir -p ${BIN_DIR}

helloworld: 
	$(ASM) ${ASM_FLAGS} 01_helloworld/$@.bin.asm -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin
	$(ASM) ${ASM_FLAGS} 01_helloworld/$@.cas.asm -L ${CAS_DIR}/$@.cas.sym -o ${CAS_DIR}/$@.cas
	$(ASM) ${ASM_FLAGS} 01_helloworld/$@.com.asm -L ${DOS1_DIR}/$@.com.sym -o ${DOS1_DIR}/$@.com
	$(ASM) ${ASM_FLAGS} 01_helloworld/$@.rom.asm -L ${ROM_DIR}/$@.rom.sym -o ${ROM_DIR}/$@.rom


helloscreen2:
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/$@_easy.rom.asm -L ${ROM_DIR}/$@_easy.rom.sym -o ${ROM_DIR}/$@_easy.rom
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/$@_opt.rom.asm -L ${ROM_DIR}/$@_opt.rom.sym -o ${ROM_DIR}/$@_opt.rom
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/$@_opt.bin.asm -L ${BIN_DIR}/$@_opt.bin.sym -o ${BIN_DIR}/hellos2.bin
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/$@_nobios.bin.asm -L ${BIN_DIR}/$@_nobios.bin.sym -o ${BIN_DIR}/hellos2n.bin


bitleveloperations:
	$(ASM) ${ASM_FLAGS} 03_bitleveloperations/bitleveloperations.bin.asm -o ${BIN_DIR}/bitleveloperations.bin
	$(ASM) ${ASM_FLAGS} 03_bitleveloperations/bitleveloperations.rom.asm -o ${ROM_DIR}/bitleveloperations.rom

interrupts:
	$(ASM) ${ASM_FLAGS} 05_interrupts/interrupts.bin.asm -o ${BIN_DIR}/interrupts.bin


fixedpoint:
	$(ASM) ${ASM_FLAGS} 06_fixedpoint/$@.bin.asm -o ${BIN_DIR}/$@.bin

ifthenelse: 
	$(ASM) ${ASM_FLAGS} 07_ifthenelse/ifthenelse.bin.asm -o ${BIN_DIR}/ifthenelse.bin

fp:
	$(ASM) ${ASM_FLAGS} 08_floatingpoint/$@.bin.asm -I ./binary16 -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin

sudoku: 
	$(ASM) ${ASM_FLAGS} 09_$@/$@.bin.asm -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin

control:
	$(ASM) ${ASM_FLAGS} 10_$@/$@.bin.asm -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin

matrix:
	$(ASM) ${ASM_FLAGS} 11_matrix/matrix.bin.asm -L ${BIN_DIR}/matrix.bin.sym -o ${BIN_DIR}/matrix.bin
	$(ASM) ${ASM_FLAGS} 11_matrix/matrix.dos.asm -L ${BIN_DIR}/matrix.dos.sym -o ${BIN_DIR}/matrix.com

doom:
	/usr/local/bin/rasm 12_$@/rasm2universal.asm -o 12_$@/doom_e1m1_universal -s -sl -sq
	/usr/local/bin/Disark 12_$@/doom_e1m1_universal.bin 12_$@/doom_e1m1_universal.asm --symbolFile 12_$@/doom_e1m1_universal.sym --sourceProfile vasm
	$(ASM) ${ASM_FLAGS} 12_$@/$@.dos.asm -L ${DOS1_DIR}/$@.dos.sym -o ${DOS1_DIR}/$@.com
	
nyancat:
	/usr/local/bin/rasm 13_$@/rasm2universal.asm -o 13_$@/nyancat_music_universal -s -sl -sq
	/usr/local/bin/Disark 13_$@/nyancat_music_universal.bin 13_$@/nyancat_music_universal.asm --symbolFile 13_$@/nyancat_music_universal.sym --sourceProfile vasm
	$(ASM) ${ASM_FLAGS} 13_$@/$@.dos.asm -L ${DOS1_DIR}/$@.dos.sym -o ${DOS1_DIR}/$@.com
	$(ASM) ${ASM_FLAGS} 13_$@/$@.dos.asm -L ${DOS2_DIR}/$@.dos.sym -o ${DOS2_DIR}/$@.com

slots:
	$(ASM) ${ASM_FLAGS} 14_$@/$@.bin.asm -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin

runrom:
	/Applications/openMSX.app/Contents/MacOS/openmsx -machine Canon_V-20 -carta `pwd`/../../dist/rom/helloworld.rom

runbin1:
	/Applications/openMSX-19-aarch64.app/Contents/MacOS/openmsx -machine Canon_V-20 -ext Philips_VY_0010 -diska `pwd`/../../dist/bin

runbin2:
	/Applications/openMSX.app/Contents/MacOS/openmsx -machine Philips_VG_8235-20 -diska `pwd`/../../dist/bin

rundos1:
	/Applications/openMSX.app/Contents/MacOS/openmsx -machine Canon_V-20 -ext Philips_VY_0010 -diska `pwd`/../../dist/msxdos1

clean:
	rm -rf ${BIN_DIR}/*
	rm -rf ${CAS_DIR}/*
	rm -rf ${ROM_DIR}/*
	rm -rf ${DOS1_DIR}/*
	rm -rf ${DOS2_DIR}/*
	cp -r ../../assets/msxdos1/* ${DOS1_DIR}/
