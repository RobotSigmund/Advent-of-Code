#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my $max_joltage = 0;

my @banks = split(/\n/, $input);
# Loop through all batterybanks
foreach my $bank (@banks) {
	# We check previous digit later, so index 0 will have -1. The first iteration will use substr pos 0
	my @digits = ( -1 );
	my $joltage = '';
	foreach my $i (1..12) {
		# Start eval string next to the previous value
		my $dig_start = $digits[$i - 1] + 1;
		# End eval string so that we do not select ones we need for later digits
		my $dig_length = length($bank) - $dig_start - (12 - $i);
		# Create eval string
		my $digit_string = substr($bank, $dig_start, $dig_length);
		# Find highest digit
		$digits[$i] = first_highest($digit_string);
		# Append value to bank-joltage
		$joltage .= substr($digit_string, $digits[$i], 1);
		# Adjust digit array index to reflect the $bank string (we us it on the next iteration)
		$digits[$i] += $dig_start;		
	}
	
	$max_joltage += $joltage;
}

my $output = $max_joltage;

# Write output into 'output.txt'
open(my $OUT, '>output2.txt');
print $OUT $output;
print $output;
close($OUT);



exit;



sub first_highest {
	my($string) = @_;
	
	my $highest_i = -1;
	my $highest_value = -1;
	
	foreach my $i (0..length($string)) {
		my $string_value = substr($string, $i, 1);
		if ($string_value > $highest_value) {
			$highest_value = $string_value;
			$highest_i = $i;
		}
	}
	
	return $highest_i;
}
