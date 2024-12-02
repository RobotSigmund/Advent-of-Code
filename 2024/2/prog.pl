
use strict;



# Read input into $input

my($IN, $input);

open($IN, '<input.txt');
read($IN, $input, -s $IN);
close($IN);



# Open output file for logging and data verification

my($FILE);
open($FILE, '>output.txt');



# split $input into lines and loop through them

my(@lines) = split(/[\r\n]/, $input);
my($safe_count) = 0;
my($line, $i);
MAINLOOP: foreach $line (@lines) {
	print $FILE $line;

	# Generate array of values
	my(@values) = split(/\s+/, $line);

	# Check original array
	if (CheckArray(@values)) {
		# This input line is PASS, skip directly to next line
		print $FILE ' PASS'."\n";
		$safe_count++;
		next;
		
	} else {
		# Check with fail damper, generate new versions with one value removed
		
		# Loop through each value we want to remove
		foreach $i (0..$#values) {
			# Check remapped array
			if (CheckArray(map { $_ != $i ? $values[$_] : () } 0..$#values)) {
				# This input line is PASS, skip directly to next line
				print $FILE ' PASS'."\n";
				$safe_count++;
				next MAINLOOP;
			}				
		}		
		
		# Nothing generated PASS, so this is a fail
		print $FILE ' nopass'."\n";
	}
}



# Print answers

print $FILE 'Output: ['.$safe_count.']'."\n";



# Close outfile
close($FILE);



exit;



sub CheckArray {
	my(@values) = @_;
	
	# Check for increasing values withing ruleset, min +1 and max +3
	my($increasing) = 1;
	my($previous, $i);
	
	$previous = $values[0];
	foreach $i (1..$#values) {
		if (($values[$i] >= ($previous + 1)) && ($values[$i] <= ($previous + 3))) {
			# Ok
		} else {
			# Failed
			$increasing = 0;
			last;
		}
		$previous = $values[$i];
	}
	
	# If increasing values checks out, early exit since we know it is good
	return 1 if ($increasing == 1);

	# Check for decreasing values withing ruleset, min -1 and max -3
	my($decreasing) = 1;

	$previous = $values[0];
	foreach $i (1..$#values) {
		if (($values[$i] <= ($previous - 1)) && ($values[$i] >= ($previous - 3))) {
			# Ok
		} else {
			# Failed
			$decreasing = 0;
			last;
		}
		$previous = $values[$i];
	}
	
	# Whatever decreasing-values-check yields, this is the correct answer, since earlier exit would trigger otherwise.
	return $decreasing;
}
