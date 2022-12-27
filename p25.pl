#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i25.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my $sum = 0;
while (<IN>) {
	chomp;
	if (m/([-=0-2]+)/) {
		my $num = $1;
		my $dec = 0;
		my $pos = 0;
		foreach (reverse(split//)) {
			my $factor = 5**$pos;
			if ( $_ eq '-' ){
				$dec -= $factor;
			} elsif ( $_ eq '=' ) {
				$dec -= 2 * $factor;
			} else {
				$dec += $_ * $factor;
			}
			$pos++;
		}
		#printf("%s becomes %i\n", $num, $dec);
		$sum += $dec;

	} else {
		print "Unparsable line $.: $_\n";
	}
}

my @snarf = ();
my $mente = 0;
while ($sum || $mente) {
	my $tal = $sum % 5 + $mente;
	$mente = 0;
	if ($tal > 2) {
		$tal -= 5;
		$mente = 1;
	}
	$sum = int($sum / 5);
	if ( $tal == -2 ) {
		push @snarf, '=';
	} elsif ( $tal == -1 ) {
		push @snarf, '-';
	} else {
		push @snarf, $tal;
	}
}

printf("Part 1: sum of fuel is: %i aka %s\n", $sum, join('', reverse(@snarf)));

__END__

