#!/usr/bin/env bash

# better performances if /tmp is tmpfs
echo "T,X,Y,Z" >> /tmp/accel_data.csv

while :
do
	T=$(date +%s%N)
	X=$(cat /sys/bus/iio/devices/iio:device2/in_accel_x_raw)
	Y=$(cat /sys/bus/iio/devices/iio:device2/in_accel_y_raw)
	Z=$(cat /sys/bus/iio/devices/iio:device2/in_accel_z_raw)

	echo "$T,$X,$Y,$Z" >> /tmp/accel_data.csv

done
