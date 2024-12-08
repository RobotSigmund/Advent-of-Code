
use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my(@map) = split(/[\r\n]+/, $input);

# Read all nodes
my(@nodes);
foreach my $y (0..$#map) {
	foreach my $x (0..(length($map[$y]) - 1)) {
		if (substr($map[$y], $x, 1) ne '.') {
			push(@nodes, substr($map[$y], $x, 1).';'.$x.';'.$y);
			print substr($map[$y], $x, 1).';'.$x.';'.$y."\n";
		}
	}
}

print 'Generating antinodes...'."\n";

# Loop through nodes and create antinodes
my(@map_antinodes) = @map;
foreach my $i (0..$#nodes) {
	my($n1_t, $n1_x, $n1_y) = split(/;/, $nodes[$i]);

	foreach my $j (0..$#nodes) {
		
		# Skip if the same antenna
		next if ($i == $j);

		my($n2_t, $n2_x, $n2_y) = split(/;/, $nodes[$j]);

		# Skip if not same type antenna
		next if ($n1_t ne $n2_t);

		print 'Type='.$n1_t.' 1X='.$n1_x.' 1Y='.$n1_y.' 2X='.$n2_x.' 2Y='.$n2_y;

		# Antinodes on top of nodes
		substr($map_antinodes[$n1_y], $n1_x, 1, '#');
		substr($map_antinodes[$n2_y], $n2_x, 1, '#');

		# Generate antinodes and mark them on the map
		my($a1_x) = $n1_x - ($n2_x - $n1_x);
		my($a1_y) = $n1_y - ($n2_y - $n1_y);
		while (WithinBounds($a1_x, $a1_y, @map)) {
			substr($map_antinodes[$a1_y], $a1_x, 1, '#');
			$a1_x -= ($n2_x - $n1_x);
			$a1_y -= ($n2_y - $n1_y);
		}

		my($a2_x) = $n2_x + ($n2_x - $n1_x);
		my($a2_y) = $n2_y + ($n2_y - $n1_y);
		while (WithinBounds($a2_x, $a2_y, @map)) {
			substr($map_antinodes[$a2_y], $a2_x, 1, '#');
			$a2_x += ($n2_x - $n1_x);
			$a2_y += ($n2_y - $n1_y);
		}
		
		print "\n";
	}
}

foreach (@map) {
	print $FILE $_."\n";
}
print $FILE "\n";

my $total = 0;
foreach (@map_antinodes) {
	my(@count) = $_ =~ /#/g;
	$total += ($#count + 1);
	print $FILE $_.' '.($#count + 1)."\n";	
}
print $FILE 'Total antinodes: ['.$total.']'."\n";

# Close outfile
close($FILE);



exit;



sub WithinBounds {
	my($x, $y, @map) = @_;
	
	# Check out of bounds
	return 0 if ($y < 0);
	return 0 if ($y > $#map);
	return 0 if ($x < 0);
	return 0 if ($x >= length($map[$y]));
	
	# Still on map	
	return 1;
}


