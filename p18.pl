#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i18.txt';
my %block = ();
my %max = ();
my %min = ();
open(IN, "$input") || die "cant read $input: $!\n";

while (<IN>) {
	chomp;
	if (m/(\d+),(\d+),(\d+)/) {
		$block{xyz($1,$2,$3)} = 1;
		#record the bounding box
		$min{'x'} = min(defined($min{'x'})?$min{'x'}:$1, $1);
		$max{'x'} = max($max{'x'}, $1);
		$min{'y'} = min(defined($min{'y'})?$min{'y'}:$2, $2);
		$max{'y'} = max($max{'y'}, $2);
		$min{'z'} = min(defined($min{'z'})?$min{'z'}:$3, $3);
		$max{'z'} = max($max{'z'}, $3);
	} else {
		print "Unparsable line $.: $_\n";
	}
}

my $exposed = 0;
my $e = 0;
my ($x,$y,$z);

foreach my $k (keys %block) {
	($x,$y,$z) = split/_/,$k;
	$e += 6;
	$e -= $block{xyz($x-1,$y,$z)};
	$e -= $block{xyz($x+1,$y,$z)};
	$e -= $block{xyz($x,$y-1,$z)};
	$e -= $block{xyz($x,$y+1,$z)};
	$e -= $block{xyz($x,$y,$z-1)};
	$e -= $block{xyz($x,$y,$z+1)};

}
printf("Total exposed sides is (part 1): %i\n", $e);
	
#fill the cube with water
my @q = ([$min{'x'},$min{'y'},$min{'z'}]);
while(($x,$y,$z) = @{shift @q||[]} ) {
	#printf("(%i,%i,%i)\n", $x,$y,$z);
	#x-plane
	if ( $x >= $min{'x'} ) {
		if ( defined($block{xyz($x-1,$y,$z)}) ) {
			if ( $block{xyz($x-1,$y,$z)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x-1,$y,$z)} = 2;
			push @q, [$x-1,$y,$z];
		}
	}
	if ( $x <= $max{'x'} ) {
		if ( defined($block{xyz($x+1,$y,$z)}) ) {
			if ( $block{xyz($x+1,$y,$z)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x+1,$y,$z)} = 2;
			push @q, [$x+1,$y,$z];
		}
	}
	#y-plane
	if ( $y >= $min{'y'} ) {
		if ( defined($block{xyz($x,$y-1,$z)}) ) {
			if ( $block{xyz($x,$y-1,$z)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x,$y-1,$z)} = 2;
			push @q, [$x,$y-1,$z];
		}
	}
	if ( $y <= $max{'y'} ) {
		if ( defined($block{xyz($x,$y+1,$z)}) ) {
			if ( $block{xyz($x,$y+1,$z)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x,$y+1,$z)} = 2;
			push @q, [$x,$y+1,$z];
		}
	}
	#z-plane
	if ( $z >= $min{'z'} ) {
		if ( defined($block{xyz($x,$y,$z-1)}) ) {
			if ( $block{xyz($x,$y,$z-1)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x,$y,$z-1)} = 2;
			push @q, [$x,$y,$z-1];
		}
	}
	if ( $z <= $max{'z'} ) {
		if ( defined($block{xyz($x,$y,$z+1)}) ) {
			if ( $block{xyz($x,$y,$z+1)} == 1 ) {
				#rock
				$exposed++;
			}
		} else {
			#fill with water and add to que
			$block{xyz($x,$y,$z+1)} = 2;
			push @q, [$x,$y,$z+1];
		}
	}
}

printf("Total exposed sides is (part 2): %i\n", $exposed);

sub xyz () {
	return( sprintf("%i_%i_%i", @_));
}

	





__END__

