
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
	my @values = split(/,/, $printorder);
	my $failedrule = CheckValid($printorder, @rulesets);
	if ($failedrule == 0) {
		my $middlevalue = $values[int($#values / 2)];
		$sum += $middlevalue;
		print $FILE $printorder.', OK, Middlevalue= '.$middlevalue.' AccSum='.$sum."\n";
	} else {
		print $FILE $printorder.', failed by rule '.$failedrule."\n";
	}
}

print $FILE 'Output: ['.$sum.']'."\n";

# Close outfile
close($FILE);



exit;



sub CheckValid {
	my($printorder, @rulesets) = @_;
	
	foreach my $rule (@rulesets) {
		my($val1, $val2) = $rule =~ /(\d+)\|(\d+)/;
		if ($printorder =~ /$val2\D+$val1/) {
			# Wrong order, so return failed
			return $rule;
		} else {
			# ok, next
		}
	}
	
	return 0;
}
