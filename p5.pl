#!/usr/bin/perl

use strict;
use Data::Dumper;

my $input = 'i5.txt';

open(IN, "$input") || die "cant read $input: $!\n";

my $head = 1;
my @stacks;
my @stacks2;

while (<IN>) {
	chomp;
	if (m/^\s*$/) {
		$head = 0;
		#copy for 2nd challange
		next;
	}

	if ($head==1) {
		my $c;
		my $i = 0;
		foreach $c (split //) {
			if ($c =~ m/([A-Z])/ ) {
				my $stack = 1 + ($i - 1)/4;
				push @{$stacks[$stack]}, $c;
				#copy for 2nd challange
				push @{$stacks2[$stack]}, $c;

			}
			$i++;
		}
	} elsif ($head==0) {
		if (m/^move (\d+) from (\d+) to (\d+)/) {
			#print "$1 from $2 -> $3\n";
			#print Dumper(@{$stacks[$2]});
			#print Dumper(@{$stacks[$3]});
			#part1
			for my $m (1..$1) {
				my $c = shift(@{$stacks[$2]});
				unshift @{$stacks[$3]}, $c;
			}
			#part2
			my @buf = ();
			for my $m (1..$1) {
				my $c = shift(@{$stacks2[$2]});
				push @buf, $c;
			}
			@{$stacks2[$3]} =  (@buf, @{$stacks2[$3]});
			#last;
		}
	}
}
print "part 1: " . gettop(@stacks) . "\n";
print "part 2: " . gettop(@stacks2) . "\n";

sub gettop () {
	my @arr = @_;
	my $s = '';
	foreach (@arr) {
		$s .= shift(@{$_});
	}
	return $s;
}


