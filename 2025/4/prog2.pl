#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my @diagram_rows = split(/\n/, $input);

# Add padding to prevent counting out-of-bounds
foreach my $row (@diagram_rows) {
	$row = '.' . $row . '.';
}
unshift(@diagram_rows, '.');
while (length($diagram_rows[0]) < length($diagram_rows[1])) {
	$diagram_rows[0] .= '.';
}
push(@diagram_rows, $diagram_rows[0]);

# Copy diagram to placeholder map
my @diagram_rows_placeholder = @diagram_rows;

my $paper_rolls_removed = 0;

while (1) {
	
	my $paper_rolls_accessible = 0;
	foreach my $row (1..($#diagram_rows - 1)) {
		foreach my $col (1..(length($diagram_rows[$row]) - 1)) {
			if (substr($diagram_rows[$row], $col, 1) eq '@') {
				my $paper_roll_count = 0;
				
				$paper_roll_count++ if (substr($diagram_rows[($row - 1)], ($col - 1), 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[($row - 1)], $col, 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[($row - 1)], ($col + 1), 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[$row], ($col - 1), 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[$row], ($col + 1), 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[($row + 1)], ($col - 1), 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[($row + 1)], $col, 1) eq '@');
				$paper_roll_count++ if (substr($diagram_rows[($row + 1)], ($col + 1), 1) eq '@');
				
				if ($paper_roll_count < 4) {
					$paper_rolls_accessible++;
					# Store removal in placeholder map
					substr($diagram_rows_placeholder[$row], $col, 1, '.');
				}
			}
		}
	}
	
	last if ($paper_rolls_accessible == 0);
	
	$paper_rolls_removed += $paper_rolls_accessible;
	
	# Copy all removals to actual map before next iteration
	@diagram_rows = @diagram_rows_placeholder;
}

my $output = $paper_rolls_removed;

# Write output into 'output.txt'
open(my $OUT, '>output2.txt');
print $OUT $output;
print $output;
close($OUT);
