#!/bin/bash

sources=(proc_config.vhd addrDecoder.vhd aluCtrl.vhd bin2char.vhd dff.vhd leftShifter.vhd mipsAlu.vhd mipsCtrlFsm.vhd mipsCtrl.vhd regFile.vhd reg.vhd signExtend.vhd)

update() {
	if [[ -f "rorgprsimlib-obj08.cf" ]]; then
		src=$1
		hash=$(grep -F "vhdl/$src" rorgprsimlib-obj08.cf | cut -d" " -f4 | tr -d \")
		if [[ ! -z "$hash" ]]; then
			testHash=$(sha1sum vhdl/$src | cut -d" " -f1)
			if [[ "$hash" != "$testHash" ]]; then
				echo "Re-analyzing $src"
				ghdl analyse --std=08 --work=ROrgPrSimLib -Wno-hide vhdl/$src
			fi
		else
			echo "Analyzing $src"
			ghdl analyse --std=08 --work=ROrgPrSimLib -Wno-hide vhdl/$src
		fi
	else
		echo "Analyzing $src and creating library"
		ghdl analyse --std=08 --work=ROrgPrSimLib -Wno-hide vhdl/$src
	fi
}

for src in "${sources[@]}"
do
	update $src
done
