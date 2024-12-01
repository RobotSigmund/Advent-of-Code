
use strict;



# Read input into $input

my($IN, $input);

open($IN, '<input.txt');
read($IN, $input, -s $IN);
close($IN);



# Open output file for logging and data verification

my($FILE);
open($FILE, '>output.txt');



# split $input into two arrays

my($lines, $i, $j);
my(@arr1, @arr2);

my(@lines) = split(/[\r\n]/, $input);
foreach $i (0..$#lines) {
	if ($lines[$i] =~ /(\d+)\s+(\d+)/) {
		push(@arr1, $1);
		push(@arr2, $2);
		print $FILE $arr1[$#arr1].';'.$arr2[$#arr2].';'."\n";
	}
}



# Sort the arrays

@arr1 = sort @arr1;
@arr2 = sort @arr2;



# Loop through array 1+2 and calculate data

my($distance, $arr2_count);
my($total_distance) = 0;
my($similarity_score) = 0;
foreach $i (0..$#arr1) {
	$distance = abs($arr1[$i] - $arr2[$i]);
	$arr2_count = 0;
	foreach $j (0..$#arr2) {
		if ($arr1[$i] == $arr2[$j]) {
			$arr2_count++;
		}
	}	
	$similarity_score += $arr1[$i] * $arr2_count;
	$total_distance += $distance;
	
	# Debug data	
	print $FILE 'Value1='.$arr1[$i].' Value2='.$arr2[$i].' Distance='.$distance.' AccDistance='.$total_distance.' Arr2Count='.$arr2_count.' SimScoreIncr='.($arr1[$i] * $arr2_count).' AccSimScore='.$similarity_score.''."\n";
}



# Print answers

print $FILE 'Output1: ['.$total_distance.']'."\n";
print $FILE 'Output2: ['.$similarity_score.']'."\n";



# Close outfile
close($FILE);
