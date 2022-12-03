#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i1.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my @max = (0,0,0);
my $maxnum = 0;
my $num = 1;
my $cal = 0;

while (<IN>) { 
	chomp;
	#printf("line %i, elf %i, cal %i \"$_\"\n", $., $num, $cal);
	if (m/^\s*$/) {
		#empty line
		if ($cal > $max[2]) {
			pop @max;
			@max = sort { $b <=> $a } ($cal, @max);
			#print Dumper( @max );
		}
		$cal = 0;
		$num++;
	} elsif ( m/(\d+)/ ) {
		$cal += $1;

	} else {
		print "Strange line \"$_\"\n";
	}
}

printf("Elf is carrying maximum %i calories\n", $max[0]);
printf("Top3 Elfs is carrying maximum %i calories\n", $max[0]+$max[1]+$max[2]);
