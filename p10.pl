#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i10.txt';

open(IN, "$input") || die "cant read $input: $!\n";

#print Dumper(@head);
my @v = (1);
my $sum = 0;

while (<IN>) {
	chomp;
	if (m/^noop/) {
		$sum += addreg(0, \@v);
	} elsif (m/addx\s+([-0-9]+)/) {
		$sum += addreg(0, \@v);
		$sum += addreg($1, \@v);
	}
}
printf("sum of interesting frequencies %i\n", $sum);
my $cycle = 0;
foreach my $val (@v) {
	my $pos = $cycle++ % 40;
	if ( abs($val - $pos) < 2  ) {
		print "#";
	} else {
		print ".";
 	}
	if ($cycle%40 == 0) {
		print "\n";
	}
}

sub addreg () {
	my $add = shift;
	my $valref = shift;
	my $ret = 0;
	push @{$valref}, $add + $valref->[$#{$valref}];
	if ( $#{$valref} % 40 == 19 ) {
		#printf("cycle %i val %i\n", $#{$valref} + 1, $valref->[$#{$valref}]);
		$ret = ($#{$valref} + 1) * ( $valref->[$#{$valref}] );
	}
	return $ret;
}
	
	

__END__

