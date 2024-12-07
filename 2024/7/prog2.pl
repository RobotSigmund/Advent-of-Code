
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
	COMBINATION: while ($operators[0] <= 3) {
		
		my $text = $answer.': ';
		my $result = $values[0];
		$text .= $values[0];
		
		foreach my $i (0..$#operators) {
			if ($operators[$i] == 1) {
				$result += $values[$i + 1];
				$text .= '+'.$values[$i + 1];
			} elsif ($operators[$i] == 2) {
				$result *= $values[$i + 1];
				$text .= '*'.$values[$i + 1];
			} elsif ($operators[$i] == 3) {
				$result = $result.$values[$i + 1];
				$text .= '||'.$values[$i + 1];
			}
		}
		
		$text .= '='.$result;		
		if ($result == $answer) {
			$total += $answer;
			$text .= ' CORRECT'."\n";
			print $FILE $text;
			last COMBINATION;
		} else {
			my $i = $#operators;
			while ($i >= 0) {
				$operators[$i]++;
				if ($operators[$i] <= 3) {
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

