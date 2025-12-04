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

my $paper_roll_accessible = 0;

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
			
			$paper_roll_accessible++ if ($paper_roll_count < 4);
		}
	}
}

my $output = $paper_roll_accessible;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);
