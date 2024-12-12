
use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

our(@LINES) = split(/[\r\n]+/, $input);

my $total_price = 0;

foreach my $y (0..$#LINES) {
	foreach my $x (0..length($LINES[$y])) {
		if (substr($LINES[$y], $x, 1) =~ /\w/) {
			$total_price += Calc($x, $y, @LINES);
		}
	}
}

print 'Total price=['.$total_price.']'."\n";



exit;



sub Calc {
	my($x, $y, @arr) = @_;
	
	# Type garden slot
	my $type = substr($arr[$y], $x, 1);
	
	my $mapsize_x = length($arr[$y]);
	my $mapsize_y = $#arr;

	my(@sametype);

	# Find all slots of this type
	foreach my $iy (0..$mapsize_y) {
		foreach my $ix (0..$mapsize_x) {
			if (substr($arr[$iy], $ix, 1) eq $type) {
				# Same type, store into type array + connected or not
				if (($ix == $x) && ($iy == $y)) {
					# Original spot is tagged
					push(@sametype, $ix.';'.$iy.';1');
				} else {
					push(@sametype, $ix.';'.$iy.';0');
				}
			}
		}
	}
	
	# sametype-array, loop and connect until all processed, tag anything connected
	my($loop) = 1;
	while ($loop) {
		$loop = 0;
		foreach my $i (0..$#sametype) {
			my($ix, $iy, $processed) = split(/;/, $sametype[$i]);
			# Check if spot was tagged as same type, and still is not connected
			if ($processed ne '1') {
				# yes, check if any adjacent tagged ones
				if ((grep($_ eq ($ix + 1).';'.$iy.';1', @sametype))
					|| (grep($_ eq ($ix - 1).';'.$iy.';1', @sametype))
					|| (grep($_ eq $ix.';'.($iy + 1).';1', @sametype))
					|| (grep($_ eq $ix.';'.($iy - 1).';1', @sametype))) {
					# This spot is part of the gardentype
					$sametype[$i] = $ix.';'.$iy.';1';
					$loop = 1;
				}
			}
		}
	}
	
	# Prune non-connected
	my $i = 0;
	while ($i <= $#sametype) {
		my(undef, undef, $processed) = split(/;/, $sametype[$i]);
		if ($processed eq '0') {
			splice(@sametype, $i, 1);
		} else {
			$i++;
		}
	}
	
	# Tag as processed
	foreach (@sametype) {
		my($ix, $iy, $processed) = split(/;/, $_);
		substr($LINES[$iy], $ix, 1, '.');
	}
	
	# Count scores
	my $area_score = 0;
	foreach my $i (@sametype) {
		my($ix, $iy, undef) = split(/;/, $i);
		my $score = 4;
		$score -= 1 if (grep($_ eq ($ix + 1).';'.$iy.';1', @sametype));
		$score -= 1 if (grep($_ eq ($ix - 1).';'.$iy.';1', @sametype));
		$score -= 1 if (grep($_ eq $ix.';'.($iy + 1).';1', @sametype));
		$score -= 1 if (grep($_ eq $ix.';'.($iy - 1).';1', @sametype));
		$area_score += $score;
	}
	
	print 'Region '.$type.' Price='.($#sametype + 1).' * '.$area_score.' = '.(($#sametype + 1) * $area_score)."\n";
	
	return (($#sametype + 1) * $area_score);
}


