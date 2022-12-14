#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i12.txt';

my %Height;
my $h = 0;
foreach ( 'a'..'z' ) {
        $Height{$_} = ++$h;
}
$Height{'S'} = $Height{'a'};
$Height{'E'} = $Height{'z'};

open(IN, "$input") || die "cant read $input: $!\n";

my $x = 0;
my $y = 0;
my @end = my @start = (-1,-1);
my @map;

while (<IN>) {
	chomp;
	$x = 0;
	foreach (split //) {
		@start = ($x, $y) if ( $_ eq 'S' );
		@end = ($x, $y) if ( $_ eq 'E' );
		$map[$x++][$y] = $Height{$_};
	}
	$y++;
}
my %Graph;
#lets make a graph
for (my $i=0; $i < $x; $i++) {
	for (my $j=0; $j < $y; $j++) {
		#west
		if ($i - 1 >= 0 && $map[$i-1][$j] <= $map[$i][$j] + 1 ) {
			push @{$Graph{ node($i, $j) }} , node($i-1, $j);
		}
		#east
		if ($i + 1 <= $x && $map[$i+1][$j] <= $map[$i][$j] + 1 ) {
			push @{$Graph{ node($i, $j) }} , node($i+1, $j);
		}
		#north
		if ($j - 1 >= 0 && $map[$i][$j-1] <= $map[$i][$j] + 1 ) {
			push @{$Graph{ node($i, $j) }} , node($i, $j-1);
		}
		#south
		if ($j + 1 <= $y && $map[$i][$j+1] <= $map[$i][$j] + 1 ) {
			push @{$Graph{ node($i, $j) }} , node($i, $j+1);
		}
	}
}


my %Dist;
my %Prev;

foreach (keys %Graph) {
	$Dist{$_} =  2*$x*$y;
	$Prev{$_} = $_;
}
$Dist{ node(@start) } = 0;

while ($Dist{ node(@end) } == 2*$x*$y) {
	foreach my $n1 ( sort keys %Graph ) {
		foreach my $n2 ( @{$Graph{$n1}} ) {
			if ( $Dist{$n2} > $Dist{$n1} + 1 ) {
				#shorter path
				$Dist{$n2} = $Dist{$n1} + 1;
				$Prev{$n2} = $n1;
			}
		}
	}
}

printf("Shortest path: %i\n", $Dist{ node(@end) } );

sub node () {
	return sprintf("%i_%i", @_);
}

sub nodesleft () {
	my $h = shift;
	my $cnt = 0;
	foreach (keys %{$h}) {
		$cnt++ if (${$h}{$_} == 2*$x*$y);
	}
	return $cnt;
}
			


 
__END__

