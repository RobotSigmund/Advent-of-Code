


use strict;



# Read input into $input
open(my $IN, '<input.txt') or die 'File not found';
read($IN, my $input, -s $IN);
close($IN);

my($map, $moves) = split(/[\r\n]{2}/, $input);

our(@lines) = split(/[\r\n]/, $map);
our(@robot);

# Find robot
LOOP1: foreach my $y (0..$#lines) {
	foreach my $x (0..length($lines[$y])) {
		if (substr($lines[$y], $x, 1) eq '@') {
			@robot = ($x, $y);
			last LOOP1;
		}
	}
}

open(my $OUT, '>output.txt');

# Move through sequence
foreach my $i (0..length($moves)) {
	my $direction = substr($moves, $i, 1);
	
	# Move robot. Move function will recursively also move anything in the robots way.
	if ($direction eq '^') {
		@robot = ($robot[0], $robot[1] - 1) if (Move($robot[0], $robot[1], 0, -1));
	} elsif ($direction eq '>') {
		@robot = ($robot[0] + 1, $robot[1]) if (Move($robot[0], $robot[1], 1, 0));
	} elsif ($direction eq 'v') {
		@robot = ($robot[0], $robot[1] + 1) if (Move($robot[0], $robot[1], 0, 1));
	} elsif ($direction eq '<') {
		@robot = ($robot[0] - 1, $robot[1]) if (Move($robot[0], $robot[1], -1, 0));
	} else {
		next;
	}
	
	# Write current map to debug file
	print $OUT "\n".'Direction '.$direction."\n";
	foreach (@lines) {
		print $OUT $_."\n";
	}
}

close($OUT);

# Perform calculation for gps coord sum
my $sum = 0;
foreach my $y (0..$#lines) {
	foreach my $x (0..length($lines[$y])) {
		if (substr($lines[$y], $x, 1) eq 'O') {
			$sum += (100 * $y) + $x;
		}
	}
}

print 'Sum:'.$sum."\n";


exit;



sub Move {
	my($x, $y, $tx, $ty) = @_;
	
	# Move from x,y to x+tx,y+ty
	
	if (substr($lines[$y + $ty], $x + $tx, 1) eq '#') {
		# Not ok to move
		return 0;
	} elsif (substr($lines[$y + $ty], $x + $tx, 1) eq '.') {
		# Ok to move
		substr($lines[$y + $ty], $x + $tx, 1, substr($lines[$y], $x, 1));
		substr($lines[$y], $x, 1, '.');
		return 1;
	} elsif (substr($lines[$y + $ty], $x + $tx, 1) eq 'O') {
		# Need to push before move
		if (Move($x + $tx, $y + $ty, $tx, $ty)) {
			substr($lines[$y + $ty], $x + $tx, 1, substr($lines[$y], $x, 1));
			substr($lines[$y], $x, 1, '.');
			return 1;
		} else {
			return 0;
		}
	}
}


