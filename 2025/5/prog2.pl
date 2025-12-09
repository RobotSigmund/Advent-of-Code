#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my($ranges, undef) = split(/\n\n/, $input);
my @ranges = split(/\n/, $ranges);
my @range_values;

foreach my $range (@ranges) {
    my($min, $max) = split(/-/, $range);
    push(@range_values, $min . '[');
    push(@range_values, $max . ']');
}

@range_values = sort {$a <=> $b} @range_values;

my $total_id_count = 0;
my $depth = 0;
my $value_previous = 0;
foreach my $range (@range_values) {
    my($value, $type) = $range =~ /(\d+)([\[\]])/;

    if (($depth == 0) && ($type eq '[') && ($value > $value_previous)) {
        $total_id_count += 1;
    } elsif ($depth > 0) {
        $total_id_count += $value - $value_previous;
    }

    $depth++ if ($type eq '[');
    $depth-- if ($type eq ']');

    $value_previous = $value;
}

my $output = $total_id_count;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output . "\n";
close($OUT);
