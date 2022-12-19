#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i15.txt';
open(IN, "$input") || die "cant read $input: $!\n";

my $row = 2000000;
my %Row;
my @sensor;

while (<IN>) {
	chomp;
	if (m/Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/ ) {
		$Row{$1} |= 2 if ($2 == $row); #sensor
		$Row{$3} |= 4 if ($4 == $row); #beacon
			
		my $mdist = abs($1-$3) + abs($2-$4);
		push @sensor, [ $1, $2, $mdist ];
		print "doing mdist $mdist\n";
		for my $y ( $2-$mdist..$2+$mdist ) {
			next unless ($y == $row);
			for my $x ( $1-$mdist..$1+$mdist ) {
				if ( (abs($1-$x) + abs($2-$y)) <= $mdist ) {
					$Row{"${x}"} |= 1;
				}
			}
		}
	} else {
		print "Unparsable line $.: $_\n";
	}
}

my $cnt = 0;
foreach my $k ( sort { $a <=> $b } keys %Row ) {
	$cnt++ unless ($Row{$k} & 4 );
}
printf ("Places where a beacon can not be present in row %i: %i\n", $row, $cnt);
	
#as we know there is only one uncoverd spot, it must be on the perimeter
#of the sensor range

foreach my $s (@sensor) {
	
	my ($x, $y, $d) = @$s;
	print "sensor $x,$y -> $d\n";
	
	for my $dy ( -$d-1..$d+1 ) {
		foreach my $xlr ( $s->[0]-$d-1+abs($dy), $s->[0]+$d+1-abs($dy)) {
			unless ( iscovered($xlr, $y+$dy, \@sensor) ) {
				printf("Found distress beacon at (%i,%i) with frequency %i\n", $xlr, $y+$dy, 4000000*$xlr+$y+$dy);
				last;
			}

		}
	}
}
	

sub iscovered () {
	my $x = shift;
	my $y = shift;
	my $s = shift;
	my $cover = 0;

	#print "testing $x, $y -> ";
	#out of renge
	if ( $x < 0 || $x > 4000000 || $y < 0 || $y > 4000000 ) {
		#print "out of map\n";
		return 1;
	}

	my $id = 0;
	foreach (@$s) {
		#printf("testsensor %i,%i -> %i\n", $_->[0],$_->[1],$_->[2]);
		$id++;
		if ( (abs($x-$_->[0]) + abs($y-$_->[1])) <= $_->[2] ) {
			#print "covered by sensor $id\n";
			$cover = 1;
			last;
		}
	}
	return $cover;
}
 
__END__

