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
my @lows = ();
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
		if ( $map[$i][$j] == 1 ) {
			push @lows, [ $i, $j ];
		}
	}
}

my $hike;
my $minhike = 2*$x*$y;
foreach (@lows) {
	@start = @{$_};
	$hike = dijkstra(@start);
	$minhike = $hike if ( $minhike > $hike );
	printf("Shortest path from (%i,%i): %i\n", @start, $hike );
}

printf("Shortest hike to the top is: %i\n", $minhike );


sub dijkstra () {
	my @s = ($_[0],$_[1]);
	my %Dist;
	my %Prev;

	foreach (keys %Graph) {
		$Dist{$_} =  2*$x*$y;
		$Prev{$_} = $_;
	}
	$Dist{ node(@s) } = 0;

	my $updates = 1;
	while ($Dist{ node(@end) } == 2*$x*$y && $updates > 0) {
		$updates = 0;
		foreach my $n1 ( sort keys %Graph ) {
			foreach my $n2 ( @{$Graph{$n1}} ) {
				if ( $Dist{$n2} > $Dist{$n1} + 1 ) {
					#shorter path
					$Dist{$n2} = $Dist{$n1} + 1;
					$Prev{$n2} = $n1;
					$updates++;
				}
			}
		}
	}
	return $Dist{ node(@end) };
}


sub node () {
	return sprintf("%i_%i", @_);
}


 
__END__

