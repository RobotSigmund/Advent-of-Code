
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my($rules, $orders) = split(/[\r\n]{2}/, $input);
my(@rulesets) = split(/[\r\n]/, $rules);
my(@printorders) = split(/[\r\n]/, $orders);

# Find valid printorders
my $sum = 0;
foreach my $printorder (@printorders) {
	my $ordered = CheckValidAndReorder($printorder, @rulesets);
	if ($printorder eq $ordered) {
		# Ok
		print $FILE $printorder.', OK'."\n";
	} else {
		# Parse to array reordered
		my(@values) = split(/,/, $ordered);
		my $middlevalue = $values[int($#values / 2)];
		$sum += $middlevalue;
		print $FILE $printorder.', REORDERED, Middlevalue= '.$middlevalue.' AccSum='.$sum."\n";
	}
}

print $FILE 'Output: ['.$sum.']'."\n";

# Close outfile
close($FILE);



exit;



sub CheckValidAndReorder {
	my($printorder, @rulesets) = @_;
	
	# Loop until no rules are violated
	NEWREORDER: while (1) {
		foreach my $rule (@rulesets) {
			my($val1, $val2) = $rule =~ /(\d+)\|(\d+)/;
			if ($printorder =~ /$val2\D+$val1/) {
				# Wrong order, so switch and start over
				$printorder =~ s/$val1/-/;
				$printorder =~ s/$val2/$val1/;
				$printorder =~ s/-/$val2/;
				next NEWREORDER;
			}
		}
		# All rules are PASS
		return $printorder;
	}
}
