#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my $invalid_id_sum = 0;

my @ranges = split(/,/, $input);
# Loop through all ranges
foreach my $range (@ranges) {
	my($min, $max) = $range =~ /(\d+)-(\d+)/;
	
	# Loop through each ID from given range
	foreach my $id ($min..$max) {
		
		# Skip to next if length($id) MOD 2 is non-zero
		next if (length($id) % 2);
		
		# Check both halves of $id
		$invalid_id_sum += $id if (substr($id, 0, (length($id) / 2)) eq substr($id, (length($id) / 2), (length($id) / 2)));
	}
}

my $output = $invalid_id_sum;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);
