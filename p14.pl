#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i14.txt';
open(IN, "$input") || die "cant read $input: $!\n";
my @map;

while (<IN>) {
	chomp;
	my $i = 0;
	my $x;
	my $y;
	my $lastx;
	my $lasty;
	foreach ( split/->/ ) {
		if (m/\s*(\d+),(\d+)\s*/) {
			$x = $1;
			$y = $2;
			$map[$x][$y] = 1; #rock
			if ( $i++ > 0 ) {
				#make a line
				if ( $x == $lastx ) {
					for (min($y,$lasty)..max($y,$lasty)) {
						$map[$x][$_] = 1;
						#print "rock $x, $_\n";
					}
				} elsif ( $y == $lasty ) {
					for (min($x,$lastx)..max($x,$lastx)) {
						$map[$_][$y] = 1;
						#print "rock $_, $y\n";
					}
				}
			}
			$lastx = $x;
			$lasty = $y;
		}
	}
}

my $minx = 0;
my $maxy = 0;
my $maxx = $#map + 1;
foreach (@map) {
	if ( defined($_) ) {
		$maxy = max($maxy, $#{$_});
	} else {
		$minx++
	}
}

printf( "boundaries %i < x < %i, y < %i\n", $minx, $maxx, $maxy);

#part 2 add the floor
$maxy += 2;
$minx -= $maxy;
$maxx += $maxy;

foreach( $minx..$maxx ) {
	$map[$_][$maxy] = 1;
}


printmap(\@map);
my $sand = 0;
while ( dropsand(\@map) ) {
	$sand++;
}
printmap(\@map);
print "Sanddrop # $sand is last to settle\n";

sub isfree { 
	my $n = shift;
	if ( defined($n) ) {
		if ( $n > 0 ) {
			return 1;
		} else {
			return 0;
		}
	}	
	return -1;
}

sub dropsand {
	my $m = shift;
	my $x = 500;
	my $y = 0;
	my $drop = 1;
	while ($drop) {
		if ($x >= $minx && $x <= $maxx && $y <= $maxy ) { 
			if ($m->[$x][$y+1] == 0) {
				#free space down
				$y++;
			} elsif ( $m->[$x-1][$y+1] == 0) {
				#free space down left
				$y++;
				$x--;
			} elsif ( $m->[$x+1][$y+1] == 0) {
				#free space down right
				$y++;
				$x++;
			} else {
				#no movement possible
				$m->[$x][$y] = 2;
				$drop = 0;
				if ( $x==500 && $y==0) {
					return 0;
				}
			}
		} else {
			#free fall
			print "free falling\n";
			return 0;
		}
	}
	return 1;
}

sub printmap {
	my $m = shift;
	my $x = -1;
	foreach (@{$m}) {
		$x++;
		next unless (defined($_));
		printf("%03i ", $x);
		foreach my $val (@{$_}) {
			if ($val == 1) {
				print "#";
			} elsif ($val == 2) {
				print "o";
			} else {
				print ".";
			}
		}
		print "\n";
	}
}




 
__END__

