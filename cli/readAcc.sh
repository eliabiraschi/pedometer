#!/usr/bin/env bash

output="./output.csv"
tmp_file="/tmp/accel_data.csv"

while getopts o: option
do
case "${option}"
	in
	o) output=${OPTARG};;
esac
done

trap copy_result INT

function copy_result() {
	cp $tmp_file $output
}

function main() {
	echo "T,X,Y,Z" > $tmp_file

	while :
	do
		T=$(date +%s%N)
		X=$(cat /sys/bus/iio/devices/iio:device2/in_accel_x_raw)
		Y=$(cat /sys/bus/iio/devices/iio:device2/in_accel_y_raw)
		Z=$(cat /sys/bus/iio/devices/iio:device2/in_accel_z_raw)

		echo "$T,$X,$Y,$Z" >> $tmp_file
	done
}

main()
