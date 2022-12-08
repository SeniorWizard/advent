#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i8.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my @tree = ();
my ($x, $y) = (0,0);

while (<IN>) {
	chomp;
	$x=0;
	foreach (split // ) {
		if (m/\d/) {
			$tree[$x++][$y] = $_;
		}
	}
	$y++;
}
my @visible;

my $max;
my ($i, $j) = (0,0);
for ($i = 0; $i < $x; $i++) {
	$max=-1;
	for ($j = 0; $j < $y; $j++) {
		#print "W $i, $j $tree[$i][$j] > $max\n";
		if ($tree[$i][$j] > $max) {
			$max = $tree[$i][$j];
			$visible[$i][$j] = 1; #West-bit
		} else {
			$visible[$i][$j] = 0; #init
		}
	}
}
for ($i = 0; $i < $x; $i++) {
	$max=-1;
	for ($j = $y-1; $j >= 0; $j--)  {
		#print "E $i, $j $tree[$i][$j] > $max\n";
		if ($tree[$i][$j] > $max) {
			$max = $tree[$i][$j];
			$visible[$i][$j] += 10; #East-bit
		}
	}
}
for ($j = 0; $j < $y; $j++) {
	$max=-1;
	for ($i = 0; $i < $x; $i++) {
		#print "N $i, $j $tree[$i][$j] > $max\n";
		if ($tree[$i][$j] > $max) {
			$max = $tree[$i][$j];
			$visible[$i][$j] += 100; #North-bit
		}
	}
}
for ($j = 0; $j < $y; $j++) {
	$max=-1;
	for ($i = $x-1; $i >= 0; $i-- ) {
		#print "S $i, $j $tree[$i][$j] > $max\n";
		if ($tree[$i][$j] > $max) {
			$max = $tree[$i][$j];
			$visible[$i][$j] += 1000; #South-bit
		}
	}
}
	
my $v = 0;
my $max = 0;

for ($i = 0; $i < $x; $i++) {
	for ($j = 0; $j < $y; $j++) {
		$v++ if ( $visible[$i][$j] );
		$max = senicscore($i,$j,\@tree) if ($max < senicscore($i,$j,\@tree));
	}
}

printf("Number of trees visible from some direction %i\n", $v);
printf("the tree with the best view has a secic score of %i\n", $max);


sub senicscore () {
	my $x = shift;
	my $y = shift;
	my $gridref = shift;

	my $score = 1;
	my $maxx = $#$gridref;
	my $maxy = $#{$gridref->[0]};
	my $h = $gridref->[$x][$y];
	#print "$maxx, $maxy, $h\n";

	my $s = 0;
	my $i = $x;
	while (--$i >= 0 ) {
		$s++; #left
		last if ( $h <= $gridref->[$i][$y]);
	}
	$score *= $s;
	$s = 0;
	$i = $x;
	while (++$i <= $maxx ) {
		$s++; #right
		last if ( $h <= $gridref->[$i][$y]);
	}
	$score *= $s;
	$s = 0;
	$i = $y;
	while (--$i >= 0) {
		$s++; #up
		last if ( $h <= $gridref->[$x][$i]);
	}
	$score *= $s;
	$s = 0;
	$i = $y;
	while (++$i <= $maxy ) {
		$s++; #right
		last if ($h <= $gridref->[$x][$i]);
	}
	$score *= $s;
	return $score;
	
}

__END__
print Dumper(@tree);
print Dumper(@visible);



