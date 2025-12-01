#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my $dial_zero_count = 0;
my $dial = 50;
my @rotations = split(/\n/, $input);
foreach my $rotation (@rotations) {
	my($direction, $value) = $rotation =~ /(\w)(\d+)/;
	
	foreach (1..$value) {
		$dial += lc($direction) eq 'r' ? 1 : -1;
		
		$dial = 99 if ($dial == -1);
		$dial = 0 if ($dial == 100);
		
		$dial_zero_count++ if ($dial == 0);
	}
}

my $output = $dial_zero_count;

# Write output into 'output.txt'
open(my $OUT, '>output2.txt');
print $OUT $output;
print $output;
close($OUT);
