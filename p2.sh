#!/bin/bash
input="i2.txt"
sum=0
while IFS= read -r line
do
	case "$line" in
		"A X")
			point=4
			;;
		"A Y")
			point=8
			;;
		"A Z")
			point=3
			;;
		"B X")
			point=1
			;;
		"B Y")
			point=5
			;;
		"B Z")
			point=9
			;;
		"C X")
			point=7
			;;
		"C Y")
			point=2
			;;
		"C Z")
			point=6
			;;
		*)
			point=0
			echo "strange line $line"
			;;
	esac
	sum=$((sum + point))

done < "$input"
echo "Total points $sum"
