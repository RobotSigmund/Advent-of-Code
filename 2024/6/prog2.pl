
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

# Open output file for logging and data verification
open(my $FILE, '>output.txt');

# Split data up by lines
my(@map) = split(/[\r\n]/, $input);
my(@obstacles);
my($start_x, $start_y);
my $start_mx = 0;
my $start_my = -1;

# Find startposition
LOOP: foreach my $y (0..$#map) {
	foreach my $x (0..length($map[$y])) {
		if (substr($map[$y],$x,1) eq '^') {
			$start_x = $x;
			$start_y = $y;
			last LOOP;
		}
	}
}

my(@path);

# Generate map with path=X
my($result, @map_path) = SolvePath($start_x, $start_y, $start_mx, $start_my, @map);
# Copy map to mark obstacles
my(@map_obstacles) = @map;
# Loop through map, add an obstacle for each X and check if it generates a looping path or out-of-bounds
foreach my $y (0..$#map_path) {
	foreach my $x (0..length($map_path[$y])) {
		if (($x == $start_x) && ($y == $start_y)) {
			# Start-coords are skipped
		} else {
			if (substr($map_path[$y], $x, 1) eq 'X') {
				my(@map_test) = @map;
				substr($map_test[$y], $x, 1, '#');
				($result, undef) = SolvePath($start_x, $start_y, $start_mx, $start_my, @map_test);
				if ($result == 2) {
					substr($map_obstacles[$y], $x, 1, 'O');
				}
				print $x.'x'.$y.' '.int($y / $#map_path * 100).'%'."\n";
			}
		}
	}
}

# Gen output map and count steps
my $count = 0;

foreach (@map_path) {
	my(@linecount) = $_ =~ /X/g;
	$count += $#linecount + 1;
	print $FILE $_.' '.($#linecount + 1).' '.$count."\n";
}

print $FILE 'Path length: ['.$count.']'."\n";

# Gen output map and obstacles
$count = 0;

foreach (@map_obstacles) {
	my(@linecount) = $_ =~ /O/g;
	$count += $#linecount + 1;
	print $FILE $_.' '.($#linecount + 1).' '.$count."\n";
}

print $FILE 'Obstacles: ['.$count.']'."\n";

# Close outfile
close($FILE);



exit;



sub SolvePath {
	my($x, $y, $mx, $my, @map) = @_;
	# Move until out-of-bounds
	my(@path);
	while (NotOutOfBounds($x, $y)) {
		# Store current position on path
		push(@path, $x.';'.$y.';'.$mx.';'.$my);
		substr($map[$y], $x, 1, 'X');
		
		# Get next position on map
		($x, $y, $mx, $my) = NextPosition($x, $y, $mx, $my, @map);
		
		if (grep($_ eq $x.';'.$y.';'.$mx.';'.$my, @path)) {
			# Looping path
			return(2, @map);
		}
	}
	# Out-of-bounds
	return(1, @map);
}



sub NotOutOfBounds {
	my($x, $y) = @_;
	
	# Check out of bounds
	return 0 if ($x < 0);
	return 0 if ($x > length($map[0]));
	return 0 if ($y < 0);
	return 0 if ($y > $#map);
	
	# Still on map	
	return 1;
}



sub NextPosition {
	my($x, $y, $mx, $my, @map) = @_;

	while (1) {
		# if next pos is out-of-bounds, early exit
		if (NotOutOfBounds(($x + $mx), ($y + $my)) == 0) {
			return(($x + $mx), ($y + $my), $mx, $my);
		}
		
		# if next pos is NOT obstacle, exit
		if (substr($map[$y + $my], $x + $mx, 1) ne '#') {
			return(($x + $mx), ($y + $my), $mx, $my);
		}

		# Rotate		
		($mx, $my) = RotateR90($mx, $my);
	}
}



sub RotateR90 {
	my($x, $y) = @_;
	if (($x == 1) && ($y == 0)) {
		$x = 0;
		$y = 1;
	} elsif (($x == 0) && ($y == 1)) {
		$x = -1;
		$y = 0;
	} elsif (($x == -1) && ($y == 0)) {
		$x = 0;
		$y = -1;
	} elsif (($x == 0) && ($y == -1)) {
		$x = 1;
		$y = 0;
	}
	return($x, $y);
}
