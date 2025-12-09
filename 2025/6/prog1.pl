#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my @lines = split(/\n/, $input);
my @problems;
foreach my $line_i (0..$#lines) {
    $lines[$line_i] =~ s/^\s+//g;
    my @line_columns = split(/\s+/, $lines[$line_i]);
    foreach my $col_i (0..$#line_columns) {
        $problems[$col_i][$line_i] = $line_columns[$col_i];
    }
}

my $problem_answer_sum = 0;

foreach my $problem_i (0..$#problems) {
    my $operator = $problems[$problem_i][$#{$problems[$problem_i]}];

    # Start with first value
    my $problem_answer = $problems[$problem_i][0];

    foreach my $value_i (1..($#{$problems[$problem_i]} - 1)) {
        my $value = $problems[$problem_i][$value_i];
        $problem_answer += $value if ($operator eq '+');
        $problem_answer *= $value if ($operator eq '*');
    }

    $problem_answer_sum += $problem_answer;
}

my $output = $problem_answer_sum;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output . "\n";
close($OUT);
