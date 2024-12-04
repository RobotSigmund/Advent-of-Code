
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my(@lines) = split(/[\r\n]/, $input);

# Loop through each do() section, each $enabled will then contain "<data>don't()<data>".
my $count = 0;
my($x, $y);
foreach $y (0..$#lines) {
	foreach $x (0..length($lines[0])) {
		$count++ if ((letter($x, $y, @lines) eq 'X') && (letter($x, ($y + 1), @lines) eq 'M') && (letter($x, ($y + 2), @lines) eq 'A') && (letter($x, ($y + 3), @lines) eq 'S'));
		$count++ if ((letter($x, $y, @lines) eq 'S') && (letter($x, ($y + 1), @lines) eq 'A') && (letter($x, ($y + 2), @lines) eq 'M') && (letter($x, ($y + 3), @lines) eq 'X'));
		$count++ if ((letter($x, $y, @lines) eq 'X') && (letter(($x + 1), $y, @lines) eq 'M') && (letter(($x + 2), $y, @lines) eq 'A') && (letter(($x + 3), $y, @lines) eq 'S'));
		$count++ if ((letter($x, $y, @lines) eq 'S') && (letter(($x + 1), $y, @lines) eq 'A') && (letter(($x + 2), $y, @lines) eq 'M') && (letter(($x + 3), $y, @lines) eq 'X'));
		$count++ if ((letter($x, $y, @lines) eq 'X') && (letter(($x + 1), ($y + 1), @lines) eq 'M') && (letter(($x + 2), ($y + 2), @lines) eq 'A') && (letter(($x + 3), ($y + 3), @lines) eq 'S'));
		$count++ if ((letter($x, $y, @lines) eq 'S') && (letter(($x + 1), ($y + 1), @lines) eq 'A') && (letter(($x + 2), ($y + 2), @lines) eq 'M') && (letter(($x + 3), ($y + 3), @lines) eq 'X'));
		$count++ if ((letter($x, ($y + 3), @lines) eq 'X') && (letter(($x + 1), ($y + 2), @lines) eq 'M') && (letter(($x + 2), ($y + 1), @lines) eq 'A') && (letter(($x + 3), $y, @lines) eq 'S'));
		$count++ if ((letter($x, ($y + 3), @lines) eq 'S') && (letter(($x + 1), ($y + 2), @lines) eq 'A') && (letter(($x + 2), ($y + 1), @lines) eq 'M') && (letter(($x + 3), $y, @lines) eq 'X'));
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
		
	return substr($data[$y], $x, 1);	
}
