
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

my $sum = 0;

# Loop through printorders
foreach my $printorder (@printorders) {

	# Check printorder, 0= success, otherwise we get failing rule
	if (my $failedrule = CheckValid($printorder, @rulesets)) {
		# Failed
		print $FILE $printorder.', failed by rule '.$failedrule."\n";
		next;
	}

	# Order is ok
	my @values = split(/,/, $printorder);
	my $middlevalue = $values[int($#values / 2)];
	$sum += $middlevalue;
	print $FILE $printorder.', OK, Middlevalue= '.$middlevalue.' AccSum='.$sum."\n";
	
}

print $FILE 'Output: ['.$sum.']'."\n";

# Close outfile
close($FILE);



exit;



sub CheckValid {
	my($printorder, @rulesets) = @_;
	
	foreach my $rule (@rulesets) {
		my($val1, $val2) = $rule =~ /(\d+)\|(\d+)/;
		# If wrong order, return failing rule
		return $rule if ($printorder =~ /$val2\D+$val1/);
	}

	# All rules passed so return 0 for success	
	return 0;
}
