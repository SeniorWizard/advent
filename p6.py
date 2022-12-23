#!/usr/bin/python3

with open("i6.txt", "r") as fd:
    line = fd.read()

def getn(string,n):
	getn = None
	for i in range(len(string)):
    		window = string[i:i+n]
    		if len(window) == len(set(window)) and not getn:
        		getn = i + n
        		break
	return getn
			
print("Part 1:", getn(line,4))
print("Part 2:", getn(line,14))
