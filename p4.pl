#!/usr/bin/perl

use strict;

my $input = 'i4.txt';

open(IN, "$input") || die "cant read $input: $!\n";
my $inc = 0;
my $over = 0;


while (<IN>) {
	chomp;
	if (m/(\d+)-(\d+),(\d+)-(\d+)/) {
		my ($f1, $t1, $f2, $t2) = ($1, $2, $3, $4);
		if ($f1 <= $f2 && $t1 >= $t2) {
			#range2 included in r1
			#print "$_ elf2 is excused\n";
			$inc++;
		} elsif ( $f2 <= $f1 && $t2 >= $t1 ) {
			#print "$_ elf1 is excused\n";
			#r1 included in r2
			$inc++;
		}
		if ( ($f1 <= $f2 && $t1 >= $f2) || ($f2 <= $f1 && $t2 >= $f1 ) ) {
			#overlapping
			$over++;
		}
	}
}

printf("Number of elfs with surplus work: %i\n", $inc);
printf("Number of elfs with overlapping work: %i\n", $over);

