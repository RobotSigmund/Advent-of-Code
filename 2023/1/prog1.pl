
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my(@lines) = split(/[\r\n]/, $input);

my $sum = 0;

# Loop through calibration values
foreach my $calibration (@lines) {

	my($first) = $calibration =~ /^[^\d]*(\d)/;
	my($last) = $calibration =~ /(\d)[^\d]*$/;

	my($combined) = $first.$last;
	
	$sum += $combined;
	
	print $FILE $calibration.', '.$first.'-'.$last.' Combined='.$combined.' AccSum='.$sum."\n";
	
}

print $FILE 'Output: ['.$sum.']'."\n";

# Close outfile
close($FILE);
