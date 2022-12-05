#!/usr/bin/perl

use strict;

my $input = 'i3.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my %Prio =();
my $p = 0;

foreach ( 'a'..'z', 'A'..'Z' ) {
	$Prio{$_} = ++$p;
}
my $sump = 0;
my $sumgp = 0;
my @group = ();

while (<IN>) {
	chomp;
	push @group, $_;
	my $len = length($_);
	if ($len % 2 == 1) {
		print "Uneven string $_ (length $len)\n";
		next;
	}
	my $c1 = substr($_,0,$len/2);
	my $c2 = substr($_,$len/2,$len/2);
	#print "$_ - $c1 - $c2\n";
	foreach (split //, $c1) {
		if ($c2 =~ m/$_/) {
			#printf("%s is in both strings wit prio %i\n", $_, $Prio{$_});
			$sump += $Prio{$_};
			last;
		}
	}
	if ($#group == 2) {
		#find common
		foreach my $i1 (split //, $group[0]) {
			if ( $group[1] =~ m/$i1/ && $group[2] =~ m/$i1/ ) {
				printf("%s is in all strings wit prio %i\n", $i1, $Prio{$i1});
				$sumgp += $Prio{$i1};
				last;
			}
				
		}
		@group = ();
	}
}

printf("Sum of priorities is %i\n", $sump);
printf("Sum of group badge priorities is %i\n", $sumgp);

