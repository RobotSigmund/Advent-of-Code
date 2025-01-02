


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

foreach my $i (1..1000) {
	foreach my $r (0..$#robots) {
		# Move robots
		$robots[$r][0] += $robots[$r][2];
		$robots[$r][1] += $robots[$r][3];
		# Teleport robots if necessary
		$robots[$r][0] += $tiles_x_max if ($robots[$r][0] < 0);
		$robots[$r][0] -= $tiles_x_max if ($robots[$r][0] >= $tiles_x_max);
		$robots[$r][1] += $tiles_y_max if ($robots[$r][1] < 0);
		$robots[$r][1] -= $tiles_y_max if ($robots[$r][1] >= $tiles_y_max);
	}
}

my @quads;
foreach my $r (0..$#robots) {
	$quads[0] += 1 if (($robots[$r][0] < (($tiles_x_max - 1) / 2)) && ($robots[$r][1] < (($tiles_y_max - 1) / 2)));
	$quads[1] += 1 if (($robots[$r][0] > (($tiles_x_max - 1) / 2)) && ($robots[$r][1] < (($tiles_y_max - 1) / 2)));
	$quads[2] += 1 if (($robots[$r][0] < (($tiles_x_max - 1) / 2)) && ($robots[$r][1] > (($tiles_y_max - 1) / 2)));
	$quads[3] += 1 if (($robots[$r][0] > (($tiles_x_max - 1) / 2)) && ($robots[$r][1] > (($tiles_y_max - 1) / 2)));
}	

print 'Safety factor:'.($quads[0] * $quads[1] * $quads[2] * $quads[3])."\n";














