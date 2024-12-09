
use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

print $FILE $input."\n";

my(@blocks);

my $i = 0;
my $id = 0;
while ($i <= length($input)) {
	# Write file blocks
	foreach my $j (1..substr($input, $i, 1)) {
		push(@blocks, $id);
	}
	$id++;
	$i++;
	# Write empty blocks
	foreach my $j (1..substr($input, $i, 1)) {
		push(@blocks, '.');
	}
	$i++;	
}

my $i = $#blocks;
my $j = 0;
while ($i > $j) {
	print $i.' '.$j."\n";
	
	# Find last digit
	while ($blocks[$i] eq '.') {
		$i--;
	}
	# Find first empty
	while ($blocks[$j] ne '.') {
		$j++;
	}
	if ($i > $j) {
		# Move
		$blocks[$j] = $blocks[$i];
		$blocks[$i] = '.';
	}
}

my $checksum = 0;
foreach my $i (0..$#blocks) {
	$checksum += $i * $blocks[$i];
}
print $FILE 'Checksum: ['.$checksum,']'."\n";


# Close outfile
close($FILE);



