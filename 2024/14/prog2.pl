


use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my $tiles_x_max = 101;
my $tiles_y_max = 103;
my @robots;

# parse input file into a robot array
foreach my $robot (split(/[\r\n]/, $input)) {
	if ($robot =~ /^p=([-\d]+),([-\d]+)\sv=([-\d]+),([-\d]+)/) {
		push(@robots, [$1, $2, $3, $4]);
	} else {
		print 'Failed to parse '.$robot."\n";
	}
}

# Loop forever, we will exit once frame is found
foreach my $i (1..1000000) {

	# Set up a new map
	my @map;
	foreach my $y (0..($tiles_y_max - 1)) {
		foreach my $x (0..($tiles_x_max - 1)) {
			$map[$y][$x] = '.';
		}
	}

	# Process/Move all robots
	foreach my $r (0..$#robots) {
		# Move robots
		$robots[$r][0] += $robots[$r][2];
		$robots[$r][1] += $robots[$r][3];
		# Teleport robots if necessary
		$robots[$r][0] += $tiles_x_max if ($robots[$r][0] < 0);
		$robots[$r][0] -= $tiles_x_max if ($robots[$r][0] >= $tiles_x_max);
		$robots[$r][1] += $tiles_y_max if ($robots[$r][1] < 0);
		$robots[$r][1] -= $tiles_y_max if ($robots[$r][1] >= $tiles_y_max);
		# Tag on the map
		$map[$robots[$r][1]][$robots[$r][0]] = '#';
	}

	# Tag robots on map, and count how many neighbouring robots on the same line
	my $count = 0;
	foreach my $y (0..($tiles_y_max - 1)) {
		my $line;
		foreach my $x (0..($tiles_x_max - 1)) {
			$line .= $map[$y][$x];
		}
		if ($line =~ /(#{20,})/) {
			$count = length($1) if (length($1) > $count);
		}
	}

	# print candidate to outfile for christmas tree
	if ($count > 0) {
		# Print map to output file
		open(my $OUT, '>output.txt');
		print $OUT 'After '.$i.' seconds'."\n";
		foreach my $y (0..($tiles_y_max - 1)) {
			foreach my $x (0..($tiles_x_max - 1)) {
				print $OUT $map[$y][$x];
			}
			print $OUT "\n";
		}
		close($OUT);
		print 'Christmas tree timeframe candidate:'.$i."\n";
		last;
	}
}



