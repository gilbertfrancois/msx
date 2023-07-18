ASM="vasmz80_oldstyle"
DIST_DIR="../../dist"
DOS_DIR="../../dist/msxdos1"
ROM_DIR="../../dist/rom"
CAS_DIR="../../dist/cas"
BIN_DIR="../../dist/bin"

ASM_FLAGS=-Fbin -chklabels -nocase

# helloworld: 01_helloworld/helloworld_bin.asm
# 	$(ASM) -Fbin -o ${DIST_DIR}/helloworld.bin 01_helloworld/helloworld_bin.asm

all: helloworld helloscreen2 ifthenelse

folders:
	mkdir -p ${DIST_DIR}
	mkdir -p ${DOS_DIR}
	mkdir -p ${ROM_DIR}
	mkdir -p ${CAS_DIR}
	mkdir -p ${BIN_DIR}

helloworld: 
	$(ASM) ${ASM_FLAGS} 01_helloworld/helloworld.bin.asm -L ${BIN_DIR}/$@.bin.sym -o ${BIN_DIR}/$@.bin
	$(ASM) ${ASM_FLAGS} 01_helloworld/helloworld.cas.asm -o ${CAS_DIR}/helloworld.cas
	$(ASM) ${ASM_FLAGS} 01_helloworld/helloworld.com.asm -o ${DOS_DIR}/helloworld.com
	$(ASM) ${ASM_FLAGS} 01_helloworld/helloworld.rom.asm -o ${ROM_DIR}/helloworld.rom

helloscreen2:
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/helloscreen2_easy.rom.asm -o ${ROM_DIR}/helloscreen2_easy.rom
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/helloscreen2_opt.rom.asm -o ${ROM_DIR}/helloscreen2_opt.rom
	$(ASM) ${ASM_FLAGS} 02_helloscreen2/helloscreen2_opt.bin.asm -o ${BIN_DIR}/helloscreen2_opt.bin

bitleveloperations:
	$(ASM) ${ASM_FLAGS} 03_bitleveloperations/bitleveloperations.bin.asm -o ${BIN_DIR}/bitleveloperations.bin
	$(ASM) ${ASM_FLAGS} 03_bitleveloperations/bitleveloperations.rom.asm -o ${ROM_DIR}/bitleveloperations.rom

interrupts:
	$(ASM) ${ASM_FLAGS} 04_interrupts/interrupts.bin.asm -o ${BIN_DIR}/interrupts.bin


fixedpoint:
	$(ASM) ${ASM_FLAGS} 06_fixedpoint/fixedpoint.bin.asm -o ${BIN_DIR}/fixedpoint.bin

ifthenelse: 
	$(ASM) ${ASM_FLAGS} 07_ifthenelse/ifthenelse.bin.asm -o ${BIN_DIR}/ifthenelse.bin

floatingpoint:
	# pasmo -I 08_floatingpoint/binary16_pasmo 08_floatingpoint/fpp.bin.asm ${BIN_DIR}/fpp.bin
	$(ASM) ${ASM_FLAGS} 08_floatingpoint/fp.bin.asm -I ./binary16 -L ${BIN_DIR}/fp.sym -o ${BIN_DIR}/fp.bin

runbin:
	# /Applications/openMSX.app/Contents/MacOS/openmsx -machine Canon_V-20 -ext Philips_VY_0010 -diska `pwd`/../../dist/bin
	# /Applications/openMSX.app/Contents/MacOS/openmsx -machine Canon_V-20 -ext Philips_VY_0010 -diska `pwd`/../../dist/bin
	/Applications/openMSX.app/Contents/MacOS/openmsx -machine Philips_VG_8235-20 -diska `pwd`/../../dist/bin

rundos:
	/Applications/openMSX.app/Contents/MacOS/openmsx -machine Canon_V-20 -ext Philips_VY_0010 -diska `pwd`/../../dist/dos

clean:
	rm -rf ${BIN_DIR}/*
	rm -rf ${CAS_DIR}/*
	rm -rf ${ROM_DIR}/*
	rm -rf ${DOS_DIR}/*
	cp -r ../../assets/msxdos1/* ${DOS_DIR}/
