
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

	my($first) = $calibration =~ /(\d|one|two|three|four|five|six|seven|eight|nine)/;
	# Invert string to find the first of combined digit-words, ex. nineight
	my($last) = stringInvert($calibration) =~ /(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/;
	
	# Combine and invert $last back to normal
	my $combined = $first.stringInvert($last);
	
	# Convert to actual digits
	$combined =~ s/one/1/g;
	$combined =~ s/two/2/g;
	$combined =~ s/three/3/g;
	$combined =~ s/four/4/g;
	$combined =~ s/five/5/g;
	$combined =~ s/six/6/g;
	$combined =~ s/seven/7/g;
	$combined =~ s/eight/8/g;
	$combined =~ s/nine/9/g;
	
	$sum += $combined;
	
	print $FILE $calibration.' '.$first.'-'.stringInvert($last).' Combined='.$combined.' AccSum='.$sum."\n";
	
}

print $FILE 'Output: ['.$sum.']'."\n";

# Close outfile
close($FILE);



exit;



sub stringInvert {
	my($string) = @_;
	my $out;
	foreach my $i (0..length($string)) {
		$out .= substr($string,length($string)-$i,1);
	}
	return $out;
}
