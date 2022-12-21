#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i18.txt';
my %block = ();
open(IN, "$input") || die "cant read $input: $!\n";

while (<IN>) {
	chomp;
	if (m/(\d+),(\d+),(\d+)/) {
		$block{xyz($1,$2,$3)} = 1;
	} else {
		print "Unparsable line $.: $_\n";
	}
}

my $exposed = 0;

foreach my $k (keys %block) {
	my ($x,$y,$z) = split/_/,$k;
	$exposed += 6;
	$exposed -= $block{xyz($x-1,$y,$z)};
	$exposed -= $block{xyz($x+1,$y,$z)};
	$exposed -= $block{xyz($x,$y-1,$z)};
	$exposed -= $block{xyz($x,$y+1,$z)};
	$exposed -= $block{xyz($x,$y,$z-1)};
	$exposed -= $block{xyz($x,$y,$z+1)};
}
printf("Total exposed sides is: %i\n", $exposed);
	
	


sub xyz () {
	return( sprintf("%i_%i_%i", @_));
}


__END__

