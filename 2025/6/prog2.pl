#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my @lines = split(/\n/, $input);

# Build an array of elements from the operator line, will be used for "problem" lengths
my @col_widths = $lines[$#lines] =~ /([\*\+]\s+)/g;

# Build another array with info on $pos and $length of each "problem" in the @lines array
my @col_data;
my $pos = 0;
foreach my $data_i (0..$#col_widths) {
    # Chop off space-separator on all but the last element
    chop($col_widths[$data_i]) if ($data_i < $#col_widths);
    # Store data
    $col_data[$data_i] = $pos . ';' . length($col_widths[$data_i]);
    # Add $length to $pos for subsequent elements
    $pos += length($col_widths[$data_i]) + 1;
}

my $problem_answer_sum = 0;

foreach my $problem_i (0..$#col_data) {
    my($pos, $length) = split(/;/, $col_data[$problem_i]);

    # Find operator for current "problem"    
    my $operator = $col_widths[$problem_i];
    $operator =~ s/\s//g;

    # Start with first value
    my $problem_answer = FindValue($pos, $length, 0, @lines);

    # Loop through all values
    foreach my $value_i (1..($length - 1)) {
        my $value = FindValue($pos, $length, $value_i, @lines);

        $problem_answer += $value if ($operator eq '+');
        $problem_answer *= $value if ($operator eq '*');
    }

    $problem_answer_sum += $problem_answer;
}

my $output = $problem_answer_sum;

# Write output into 'output.txt'
open(my $OUT, '>output2.txt');
print $OUT $output;
print $output . "\n";
close($OUT);



exit;



sub FindValue {
    my($pos, $length, $digit, @lines) = @_;

    # Given array, position, length and which digit, we can extract the whole value

    my $value = '';
    foreach my $i (0..($#lines - 1)) {
        $value .= substr($lines[$i], ($pos + $length - 1 - $digit), 1);
    }
    $value =~ s/\s//g;

    return $value;
}


