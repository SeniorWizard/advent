#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max);

my $input = 'i21.txt';
my %Monkey = ();
open(IN, "$input") || die "cant read $input: $!\n";

while (<IN>) {
	chomp;
	if (m/([a-z]{4}):\s*(.*)\s*/) {
		$Monkey{$1} = $2;
	} else {
		print "Unparsable line $.: $_\n";
	}
}

my @q = ('root');
while(my $m = shift @q) {
	#printf("%s -> %s\n", $m , $Monkey{$m});
	if ($Monkey{$m} =~ m/\d+/) {
		if ( $m eq 'root' ) {
			printf("Monkey root shouts: %i\n", $Monkey{$m});
			last;
		}
	} else {
		#push @q, $m;
		if ($Monkey{$m} =~ m/([a-z]{4})\s+(\S)\s+(([a-z]{4}))/) {
			my ($m1, $m2, $op) = ($1,$3,$2);
			#print "$Monkey{$m} => $m1,$op,$m2 => $Monkey{$m1} # $Monkey{$m2}\n";
			if ($Monkey{$m1} !~ m/\d+/) {
				#print "1add $m1\n";
				push @q, $m1;
			} elsif ($Monkey{$m2} !~ m/\d+/) {
				#print "3add $m2\n";
				push @q, $m2;
			} else {
				#print "Calculating for $m\n";
				$Monkey{$m} = eval("$Monkey{$m1} $op $Monkey{$m2}");
				push @q, 'root';
			}
		} else 	{
			print "Starnge monkey: $Monkey{$m}\n";
		}
	}
}

print Dumper(@q);



__END__

