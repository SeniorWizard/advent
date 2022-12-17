#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i13.txt';
open(IN, "$input") || die "cant read $input: $!\n";

my @list = ();
my @pair = ();
while (<IN>) {
	chomp;
	if ( m/^\s*$/ ) {
		push @list, [@pair];
		@pair = ();
	} else {
		push @pair, eval($_);
	}
}
push @list, [@pair];

my $idx = 0;
my $sum = 0;
foreach my $r (@list) {
	$idx++;
	#print $idx, compair(@$r), ":", "\n" ; #, Dumper(@pair);
	if (compair(@$r) > 0) {
		#print "Undorderd\n";
	} else {
		#print "Orderd\n";
		$sum += $idx;
	}
}
printf("Sum of indces of ordered pairs is: %i\n", $sum);


sub compair {
	my $left = shift;
	my $right = shift;

 	if (!ref($left) && !ref($right)) {
     		return $left <=> $right;
 	}
 	if (!ref($left)) {
     		return compair ([$left], $right);
 	}
 	if(!ref($right)) {
     		return compair ($left, [$right]);
 	}
 	if(!@$left && !@$right) {
     		return 0;
 	}
 	if(!@$left) {
     		return -1;
 	}
 	if(!@$right) {
     		return 1;
 	}
 	return compair ($$left[0], $$right[0]) || compair ([@$left[1..$#$left]], [@$right[1 .. $#$right]]); 
}


 
__END__

