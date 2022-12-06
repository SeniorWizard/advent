#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i6.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my $pkt = 0;
my $marker = '';

while (<IN>) {
	chomp;
	my $line = $_;
	for my $l (4,14) {
		my $pos = lookfor($line,$l);
		if ($pos) {
			printf ("marker of lenght %i: \"%s\" found at %i\n", $l, substr($line,$pos,$l), $pos + $l );
		}
	}
}

sub lookfor () {
	my $str = shift;
	my $len = shift;
	my $pkt = 0;
	my $found = 0;
	my $marker = '';
	while ($pkt < length($str)-$len){
		$marker = substr($str, $pkt++, $len);
		if (ismarker($marker)) {
			$found = $pkt-1;
			last;
		} else {
			next;
		}
	}
	return $found;
}

sub ismarker () {
	my $mark = shift;
	my $last = '';
	foreach (sort(split //, $mark)) {
		if ( $_ eq $last ) {
			return 0;
		} else {
			$last = $_;
		}
	}
	return 1;
}


