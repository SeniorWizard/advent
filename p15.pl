#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i15.txt';
open(IN, "$input") || die "cant read $input: $!\n";

my $row = 2000000;
my %Row;

while (<IN>) {
	chomp;
	if (m/Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)/ ) {
		$Row{$1} |= 2 if ($2 == $row); #sensor
		$Row{$3} |= 4 if ($4 == $row); #beacon
		print "s $1,$2 b $3, $4\n";
			
		my $mdist = abs($1-$3) + abs($2-$4);

		#do the sensor range intersect with our row?
		if ( abs($2-$row) <= $mdist ) {
			# we can see mdist to each side, minus one for each row
			my $width = $mdist - abs($2-$row);
			for ($1-$width..$1+$width) {
				$Row{"$_"} |= 1;
			}
		}

	} else {
		"Unparsable line $.: $_\n";
	}
}

my $cnt = 0;
foreach my $k ( sort { $a <=> $b } keys %Row ) {
	$cnt++ unless ($Row{$k} & 4 );
}
printf ("Places where a beacon can not be present in row %i: %i\n", $row, $cnt);
	


 
__END__

