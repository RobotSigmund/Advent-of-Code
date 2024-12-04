
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my(@lines) = split(/[\r\n]/, $input);

my $count = 0;
foreach my $y (0..$#lines) {
	foreach my $x (0..length($lines[0])) {
		$count++ if (
			(((letter($x, $y, @lines) eq 'M') && (letter(($x + 1), ($y + 1), @lines) eq 'A') && (letter(($x + 2), ($y + 2), @lines) eq 'S'))
			|| ((letter($x, $y, @lines) eq 'S') && (letter(($x + 1), ($y + 1), @lines) eq 'A') && (letter(($x + 2), ($y + 2), @lines) eq 'M')))
			&& (((letter(($x + 2), $y, @lines) eq 'M') && (letter(($x + 1), ($y + 1), @lines) eq 'A') && (letter($x, ($y + 2), @lines) eq 'S'))
			|| ((letter(($x + 2), $y, @lines) eq 'S') && (letter(($x + 1), ($y + 1), @lines) eq 'A') && (letter($x, ($y + 2), @lines) eq 'M')))
			);
	}
}

print $FILE 'Output: ['.$count.']'."\n";

# Close outfile
close($FILE);



exit;



sub letter {
	my($x, $y, @data) = @_;
	
	# Return junk if out-of-bounds
	return '-' if ($x > length($data[$y]));
	return '-' if ($y > $#data);
	
	return substr($data[$y],$x,1);	
}




