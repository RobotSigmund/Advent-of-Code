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
	
	$dial += lc($direction) eq 'r' ? $value : -$value;
	
	while ($dial < 0) { $dial += 100; }
	while ($dial > 99) { $dial -= 100; }
	
	$dial_zero_count++ if ($dial == 0);
}

my $output = $dial_zero_count;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);
