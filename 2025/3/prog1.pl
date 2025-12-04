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
	# Find the first highest digit not including the last digit
	my $dig1 = first_highest(substr($bank, 0, (length($bank) - 1)));
	# Generate rest-string where we will search for the next digit
	my $bank_rest = substr($bank, ($dig1 + 1), (length($bank) - ($dig1 + 1)));
	# Find the second digit from the rest of the bank
	my $dig2 = first_highest($bank_rest);
	# Combine and add to sum
	my $joltage = substr($bank, $dig1, 1) . substr($bank_rest, $dig2, 1);
	
	$max_joltage += $joltage;
}

my $output = $max_joltage;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
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
