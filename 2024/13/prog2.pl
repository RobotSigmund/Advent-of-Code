


use strict;



# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my(@machines) = split(/[\r\n]{2}/, $input);

my $tokens_sum = 0;

foreach my $machine (@machines) {
	my @machine_data = split(/[\r\n]/, $machine);
	my($btn_a_x, $btn_a_y) = $machine_data[0] =~ /X\+(\d+),\sY\+(\d+)/;
	my($btn_b_x, $btn_b_y) = $machine_data[1] =~ /X\+(\d+),\sY\+(\d+)/;
	my($prize_x, $prize_y) = $machine_data[2] =~ /X=(\d+),\sY=(\d+)/;
	
	$prize_x += 10000000000000;
	$prize_y += 10000000000000;
	
	print 'Btn A:'.$btn_a_x.','.$btn_a_y."\n";
	print 'Btn B:'.$btn_b_x.','.$btn_b_y."\n";
	print 'Prize:'.$prize_x.','.$prize_y."\n";

	my $tokens = Solve($btn_a_x, $btn_a_y, $btn_b_x, $btn_b_y, $prize_x, $prize_y);

	# If price is above zero we can reach target.	
	if ($tokens > 0) {
		$tokens_sum += $tokens;
		print 'Cost: '.$tokens.' tokens'."\n";
	} else {
		print 'Can not win on this machine.'."\n";
	}

	print "\n";
}
 
print 'Total tokens needed:['.$tokens_sum.']'."\n";



exit;



sub Solve {
	my($btn_a_x, $btn_a_y, $btn_b_x, $btn_b_y, $prize_x, $prize_y) = @_;
	
	# Black magic math for intersecting two linear graphs
	my $delta = (($btn_a_x * $btn_b_y) - ($btn_a_y * $btn_b_x));
	my $count_a = (($prize_x * $btn_b_y) - ($prize_y * $btn_b_x)) / $delta;
	my $count_b = (($btn_a_x * $prize_y) - ($btn_a_y * $prize_x)) / $delta;
	
	# Check if found integer count values match prize coords
	if ((($btn_a_x * int($count_a)) + ($btn_b_x * int($count_b)) == $prize_x)
		&& (($btn_a_y * int($count_a)) + ($btn_b_y * int($count_b)) == $prize_y)) {
		
		# Return price
		return ((3 * $count_a) + $count_b);
	} else {
		return 0;
	}
}


