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
	ID: foreach my $id ($min..$max) {
		
		# We can compare lengths of up to half the size
		foreach my $str_cmp_length (1..int(length($id) / 2)) {
			
			# build a compare string, just repeat compare length until length > length($id)
			my $compare_string = '';
			while (length($compare_string) < length($id)) {
				$compare_string .= substr($id, 0, $str_cmp_length);
			}
			
			# compare $id with the comparestring, also check length is MOD comparelength
			if (($id eq substr($compare_string, 0, length($id))) && ((length($id) % $str_cmp_length) == 0)) {
				$invalid_id_sum += $id;
				
				# Only count once, so if match we skip to next $id
				next ID;
			}
		}	
	}
}

my $output = $invalid_id_sum;

# Write output into 'output.txt'
open(my $OUT, '>output2.txt');
print $OUT $output;
print $output;
close($OUT);
