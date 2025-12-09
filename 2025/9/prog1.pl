#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my @tiles = split(/\n/, $input);

my $largest_area = 0;

foreach my $tile_1_i (0..($#tiles - 1)) {
	my($tile_1_x, $tile_1_y) = $tiles[$tile_1_i] =~ /(\d+),(\d+)/;
	foreach my $tile_2_i (($tile_1_i + 1)..$#tiles) {
		my($tile_2_x, $tile_2_y) = $tiles[$tile_2_i] =~ /(\d+),(\d+)/;
		
		my $area = (abs($tile_2_x - $tile_1_x) + 1) * (abs($tile_2_y - $tile_1_y) + 1);
		
		print $tile_1_i . '-' . $tile_2_i;
		print ', ' . $tile_1_x . 'x' . $tile_1_y . '-' . $tile_2_x . 'x' . $tile_2_y;
		print ', ' . (abs($tile_2_x - $tile_1_x) + 1) . '*' . (abs($tile_2_y - $tile_1_y) + 1);
		print ', ' . $area;
		
		if ($area > $largest_area) {
			$largest_area = $area;
		}
		print "\n";
	}
}

my $output = $largest_area;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);
