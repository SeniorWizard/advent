#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i7.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my @pwd = ();
my $base = '' ;
my %Size;

while (<IN>) {
	chomp;
	my $line = $_;
	my $dir = join('/', @pwd);
	#print "$. - $dir - $line\n";
	if ( $line =~ m/^\$\s+(.*)/ ) {
		#command
		my $cmd = $1;
		if ($cmd =~ m/^cd\s+(\S+)/) {
			if ( $1 eq '/' ) {
				@pwd = ("$base");
			} elsif ( $1 eq '..' ) {
				pop @pwd;
			} else {
				push @pwd, $1;
			}
		}
	} elsif ( $line =~ m/^(\d+)\s+(.*)/ ) {
		#a file add it to all directories above
		my $d = '';
		foreach(@pwd) {
			$d .= $_;
			$Size{$d} += $1;
			$d .= '/';
		}
			
	}

}

my $size = 0;

while ( my ($key, $val) = each %Size ) {

	if ($val <= 100000) {
		$size += $val;
	}
}

printf("Sum of small dir sizes is %i\n", $size);

my $need = 30000000 - (70000000 - $Size{$base});
my $small = $Size{$base};

while ( my ($key, $val) = each %Size ) {

	if ($val >= $need && $val < $small) {
		$small = $val;
	}
}

printf("Small dir to delete has size %i\n", $small);

