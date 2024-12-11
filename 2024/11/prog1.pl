
use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my(@stones) = split(/[\s]/, $input);
our(%STONEHASH);

Solve(25, @stones);
Solve(75, @stones);



exit;



sub Solve {
	my($blinks, @input) = @_;

	my $stone_count = 0;
	
	foreach my $i (0..$#input) {
		my $count = getStone($input[$i], $blinks);
		$stone_count += $count;
		print 'Stone '.($i + 1).'/'.($#input + 1).' ('.$input[$i].') splits into '.$count.' stones'."\n";
	}

	print 'Sum count for '.$blinks.' blinks=['.$stone_count.']'."\n";
}



sub getStone {
	my($stone, $blink) = @_;
	
	return $STONEHASH{$stone.';'.$blink} if ($STONEHASH{$stone.';'.$blink} != 0);
	
	# Exit condition
	if ($blink == 1) {
		return 2 if (int(length($stone) / 2) == (length($stone) / 2));
		return 1;
	}
	
	if ($stone == 0) {
		# Change to 1
		$STONEHASH{$stone.';'.$blink} = getStone(1, $blink - 1);
		return $STONEHASH{$stone.';'.$blink};
		
	} elsif (int(length($stone) / 2) == (length($stone) / 2)) {
		# Split into two stones
		$STONEHASH{$stone.';'.$blink} = getStone(int(substr($stone, 0, length($stone) / 2)), $blink - 1) + getStone(int(substr($stone, length($stone) / 2, length($stone) / 2)), $blink - 1);
		return $STONEHASH{$stone.';'.$blink};
		
	}
	
	# Multiply by 2024
	$STONEHASH{$stone.';'.$blink} = getStone($stone * 2024, $blink - 1);
	return $STONEHASH{$stone.';'.$blink};
}


