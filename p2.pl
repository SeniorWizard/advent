#!/usr/bin/perl

use strict;

my $input = 'i2.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my %Piont = (
	'A X' => 3 + 1,
	'A Y' => 6 + 2,
	'A Z' => 0 + 3,
	'B X' => 0 + 1,
	'B Y' => 3 + 2,
	'B Z' => 6 + 3,
	'C X' => 6 + 1,
	'C Y' => 0 + 2,
	'C Z' => 3 + 3
);

my %Strat = (
	'A X' => 0 + 3,
	'A Y' => 3 + 1,
	'A Z' => 6 + 2,
	'B X' => 0 + 1,
	'B Y' => 3 + 2,
	'B Z' => 6 + 3,
	'C X' => 0 + 2,
	'C Y' => 3 + 3,
	'C Z' => 6 + 1
);


my $points = 0;
my $strats = 0;

while (<IN>) {
	chomp;
	#printf("line %i, points %i, total %i \"$_\"\n", $., $Piont{$_}, $points );
	if (m/^([ABC])\s+([XYZ])$/) {
		#game line
		$points +=  $Piont{$_};
		$strats +=  $Strat{$_};

	} else {
		print "Strange line $. \"\n";
	}
}

printf("Total points 1: %i\n", $points);
printf("Total points 2: %i\n", $strats);
