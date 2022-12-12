#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i11.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my @monkey = ();
#0: list of items
#1: operator
#2: factor
#3: divisor
#4: monkeyid for true
#5: monkeyid for false
#6: activity


my $mid = -1;

while (<IN>) {
	chomp;
	if (m/^Monkey\s+(\d+):/) {
		$mid = $1;
	} elsif ( m/^\s*$/ ) {
		#empty line
		$mid = -1;
	} elsif (m/Starting items:\s+(.*)\s*$/) {
		$monkey[$mid]->[0] = [ split(/\D+/, $1) ];
	} elsif (m/Operation: new = old ([-+\*\/]+)\s+(\d+)/) {
		$monkey[$mid]->[1] = $1;
		$monkey[$mid]->[2] = $2;
	} elsif (m/Operation: new = old \* old/) {
		$monkey[$mid]->[1] = '**';
		$monkey[$mid]->[2] = 2;
	} elsif (m/Test: divisible by (\d+)/) {
		$monkey[$mid]->[3] = $1;
	} elsif (m/If true: throw to monkey (\d+)/ ) {
		$monkey[$mid]->[4] = $1;
	} elsif (m/If false: throw to monkey (\d+)/ ) {
		$monkey[$mid]->[5] = $1;
	} else {
		print "Not parsable \"$_\"\n";
	}
}

my $item;
my $throwto = -1;
my $round = 0;
my $factor=1;
for ($mid = 0; $mid < scalar(@monkey); $mid++) {
	$factor *= $monkey[$mid]->[3];
}

#round1 is 20 rounds
#while (++$round <= 20 ) {
while (++$round <= 10000 ) {
	for ($mid = 0; $mid < scalar(@monkey); $mid++) {
		while ($item = shift @{$monkey[$mid]->[0]} ) {
			#activity
			$monkey[$mid]->[6]++;
			#operate
			$item = eval("$item $monkey[$mid]->[1] $monkey[$mid]->[2]");
			# unworry only in round1
			#$item = int($item / 3);
			#avoid going byond the product of the divisors
			$item = ($item % $factor);
			#test
			if ( $item % $monkey[$mid]->[3] == 0 ) {
				#true
				$throwto = $monkey[$mid]->[4];
			} else {
				#false
				$throwto = $monkey[$mid]->[5];
			}
			push @{$monkey[$throwto]->[0]}, $item;
		}
	}
}

my @actions = ();
for ($mid = 0; $mid < scalar(@monkey); $mid++) {
	push @actions, $monkey[$mid]->[6];
}

@actions = ( sort { $b <=> $a } @actions);

printf( "Total monkeybusiness: %i\n", $actions[0] * $actions[1]);
 
__END__

