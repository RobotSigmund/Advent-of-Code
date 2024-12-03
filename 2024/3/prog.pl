
use strict;



# Read input into $input

open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);



# Open output file for logging and data verification

open(my $FILE, '>output.txt');

my $sum = 0;

# Split data up by do()
my(@enableds) = split(/do\(\)/, $input);

# Loop through each do() section
foreach my $enabled (@enableds) {
	# Split section so that any don't() sections will not be handled
	my($part1, undef) = split(/don\'t\(\)/, $enabled);

	# Match all mul(n,n)
	my(@matches) = $part1 =~ /mul\(\d{1,3},\d{1,3}\)/g;
	
	# Loop through all matches
	foreach my $match (@matches) {
		print $FILE $match;
		
		# Parse both values
		my($val1, $val2) = $match =~ /(\d+),(\d+)/;
		print $FILE ' Val1='.$val1.' Val2='.$val2;
		
		# Add to sum
		$sum += $val1 * $val2;
		print $FILE ' AccSum='.$sum."\n";
	}
}

print $FILE 'Output: ['.$sum.']'."\n";



# Close outfile
close($FILE);




