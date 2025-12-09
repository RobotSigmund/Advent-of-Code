#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my($fresh_ranges_all, $product_ids_all) = split(/\n\n/, $input);
my(@fresh_ranges) = split(/\n/, $fresh_ranges_all);
my(@product_ids) = split(/\n/, $product_ids_all);

my $fresh_id_count = 0;

ID: foreach my $id (@product_ids) {
	foreach my $range (@fresh_ranges) {
		my($min, $max) = split(/-/, $range);
		if (($id >= $min) && ($id <= $max)) {
			$fresh_id_count++;
			next ID;
		}
	}
}

my $output = $fresh_id_count;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);
