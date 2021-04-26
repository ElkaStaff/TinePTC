#!/bin/bash

echo "win_size,avg_spd" > zad1_avg_spd.csv
sed -i -E "s/^set window_tcp1 +[0-9]+/set window_tcp1    1/" tcp.tcl
sed -i -E "s/^set capacity_R1R2 +[0-9]+/set capacity_R1R2 10/" tcp.tcl
sed -i -E "s/^set buffer_R1R2 +[0-9]+/set buffer_R1R2 5/" tcp.tcl
sed -i -E "s/^set delay_R1R2 +[0-9]+/set delay_R1R2 70/" tcp.tcl

ns tcp.tcl 2>/dev/null | grep -E "TCP1 Average Throughput = [0-9.]+" | sed -E "s/^TCP1 Average Throughput = ([0-9.]+) \[Mbps\]/1,\1/" >> zad1_avg_spd.csv
ns tcp.tcl 2>/dev/null | grep -E "TCP1 Stable Throughput = [0-9.]+" | sed -E "s/^TCP1 Stable Throughput = ([0-9.]+) \[Mbps\]/1,\1/" >> zad1_stable_spd.csv
mv out.csv zad1_1.csv
echo -ne "."

for win_size in {5..165..1}; do
	sed -i -E "s/^set window_tcp1 +[0-9]+/set window_tcp1    ${win_size}/" tcp.tcl
	ns tcp.tcl 2>/dev/null | grep -E "TCP1 Average Throughput = [0-9.]+" | sed -E "s/^TCP1 Average Throughput = ([0-9.]+) \[Mbps\]/${win_size},\1/" >> zad1_avg_spd.csv
  ns tcp.tcl 2>/dev/null | grep -E "TCP1 Stable Throughput = [0-9.]+" | sed -E "s/^TCP1 Stable Throughput = ([0-9.]+) \[Mbps\]/${win_size},\1/" >> zad1_stable_spd.csv
	mv out.csv zad1_${win_size}.csv
	echo -ne "."
done

echo
mkdir -p zad1
mv zad1_*.csv zad1/
