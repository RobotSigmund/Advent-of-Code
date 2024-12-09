
use strict;
$| = 1;

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

my(@blocks_out) = @blocks;

my $i = $#blocks;
my $i_start = $#blocks;
my $j_start = 0;
while ($i_start > 0) {
	
	
	
	# Find last digit
	while ($blocks[$i] eq '.') {
		$i--;
	}
	my $i_last = $i;
	# Find start of identical blocks
	while ($blocks[$i] eq $blocks[$i_last]) {
		$i--;
	}
	$i_start = $i + 1;
	my $i_size = $i_last - $i_start + 1;
	
	print 'i_start='.$i_start.' i_size='.$i_size;
	
	
	
	# Find first empty pos large enough for full group
	my $j_size = 0;
	$j_start = 0;
	my $j = 0;
	# While to-size is smaller than from-size AND to-pos is smaller than from-pos
	while ($j < $i_start) {
		# Add j until we find '.'
		while ($blocks_out[$j] ne '.') {
			$j++;
			if ($j > $i_start) {
				$j_start = $#blocks_out;
				last;
			}
		}
		# This is the startposition
		$j_start = $j;
		# Find end, loop until not '.'
		while ($blocks_out[$j] eq '.') {
			$j++;
			if ($j > $i_start) {
				$j_start = $#blocks_out;
				last;
			}
		}
		# Last should be one back
		my $j_last = $j - 1;
		# Size is last-start+1
		$j_size = $j_last - $j_start + 1;
		last if ($j_size >= $i_size);
	}
	
	print ' j_start='.$j_start.' j_size='.$j_size;

	
	
	# Move blocks	
	if (($j_start < $i_start) && ($j_size >= $i_size)) {
		# Move
		foreach my $k (0..($i_size - 1)) {
			$blocks_out[$j_start + $k] = $blocks[$i_start + $k];
			$blocks[$i_start + $k] = '.';
			$blocks_out[$i_start + $k] = '.';
		}
	}
	
	
	
	print "\n";
}

my $checksum = 0;
foreach my $i (0..$#blocks_out) {
	$checksum += $i * $blocks_out[$i];
}
print $FILE 'Checksum: ['.$checksum,']'."\n";


# Close outfile
close($FILE);



