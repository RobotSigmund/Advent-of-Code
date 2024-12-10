
use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

our(@LINES) = split(/[\r\n]+/, $input);
our(%tops);
my $score_sum = 0;

foreach my $y (0..$#LINES) {
	foreach my $x (0..(length($LINES[$y]) - 1)) {
		if (getValue($x, $y) == 0) {
			# Trailhead
			undef %tops;
			Trail($x, $y, 0);
			my @tops_keys = keys %tops;
			my $score = $#tops_keys + 1;
			$score_sum += $score;
			print $FILE 'X='.$x.' Y='.$y.' Score='.$score."\n";
		}
	}
}

print $FILE 'Score sum: ['.$score_sum.']'."\n";

# Close outfile
close($FILE);



exit;



sub Trail {
	my($x, $y, $elevation) = @_;
	
	if ($elevation == 9) {
		$tops{$x.';'.$y} = 1;
	}
	
	if (getValue($x + 1, $y) == ($elevation + 1)) {
		Trail($x + 1, $y, $elevation + 1);
	}
	if (getValue($x - 1, $y) == ($elevation + 1)) {
		Trail($x - 1, $y, $elevation + 1);
	}
	if (getValue($x, $y + 1) == ($elevation + 1)) {
		Trail($x, $y + 1, $elevation + 1);
	}
	if (getValue($x, $y - 1) == ($elevation + 1)) {
		Trail($x, $y - 1, $elevation + 1);
	}
}



sub getValue {
	my($x, $y) = @_;
	return 0 if ($y < 0);
	return 0 if ($y > $#LINES);
	return 0 if ($x < 0);
	return 0 if ($x >= length($LINES[0]));
	return substr($LINES[$y], $x, 1);
}

