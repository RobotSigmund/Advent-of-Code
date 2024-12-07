
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

my(@lines) = split(/[\r\n]/, $input);

my $total = 0;

foreach my $line (@lines) {
	my($answer, $exp) = split(/:/, $line);
	$exp =~ s/\s+/ /g;
	$exp =~ s/(^\s|\s$)//g;
	my(@values) = split(/\s/, $exp);
	
	# Fill operator array
	my(@operators);
	foreach my $i (0..($#values - 1)) {
		$operators[$i] = 1;
	}
	
	# Loop through array combinations
	COMBINATION: while ($operators[0] <= 2) {
		
		print $FILE $answer.': ';
		my $result = $values[0];
		print $FILE $values[0];
		
		foreach my $i (0..$#operators) {
			if ($operators[$i] == 1) {
				$result += $values[$i + 1];
				print $FILE '+'.$values[$i + 1];
			} elsif ($operators[$i] == 2) {
				$result *= $values[$i + 1];
				print $FILE '*'.$values[$i + 1];
			}
		}
		
		print $FILE '='.$result;		
		if ($result == $answer) {
			$total += $answer;
			print $FILE ' CORRECT'."\n";
			last COMBINATION;
		} else {
			print $FILE ' incorrect'."\n";
			
			my $i = $#operators;
			while ($i >= 0) {
				$operators[$i]++;
				if ($operators[$i] <= 2) {
					last;
				} else {
					$operators[$i] = 1;
					$i--;
					last COMBINATION if ($i < 0);
				}
			}
			
		}
	}	
}

print $FILE 'Total calibration result: ['.$total.']'."\n";

close($FILE);

