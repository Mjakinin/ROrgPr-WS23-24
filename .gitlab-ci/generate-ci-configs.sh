#!/bin/bash

if ! command -v git &>/dev/null; then
	echo "<the_command> could not be found"
	exit 1
fi

echo 'image: ghdl/ghdl:ubuntu22-llvm-11'

for path in Blatt*/praxis/Aufgabe*; do
	task=$(echo $path | sed "s/\/praxis\//-/" | tr -d "./")
	echo $task":"
	echo "  script:"
	echo "    - make -C $path ghdl"
    echo "    - \"grep -F '(report note): CI: All good.' $path/transcript --quiet\""
done
