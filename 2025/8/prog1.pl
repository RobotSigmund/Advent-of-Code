#!/usr/bin/perl

use strict;


# Read input into $input
open(my $IN, '<input.txt');
read($IN, my $input, -s $IN);
close($IN);

my @junction_boxes = split(/\n/, $input);

# Loop through all juction boxes and figure out distance between them
my %connections;
foreach my $i (0..($#junction_boxes - 1)) {
	foreach my $j (($i + 1)..$#junction_boxes) {
		my ($i_x, $i_y, $i_z) = split(/,/, $junction_boxes[$i]);
		my ($j_x, $j_y, $j_z) = split(/,/, $junction_boxes[$j]);
		my $connection_id = $i . '-' . $j;
		my $connection_length = sqrt((($j_x - $i_x) ** 2) + (($j_y - $i_y) ** 2) + (($j_z - $i_z) ** 2));
		$connections{$connection_id} = $connection_length;
	}
}

# Sort distance array
my @connections_keys = sort {$connections{$a} <=> $connections{$b}} keys %connections;

# Remove connections not within the 1000 shortest ones
my $keep_connections = 1000;
splice(@connections_keys, $keep_connections) if ($#connections_keys >= $keep_connections);

# Make a circuit array. Add the first/shortest connection to circuit array
my @circuits = ( $connections_keys[0] );
my($from, $to) = split(/-/, $connections_keys[0]);
print '0 ' . $connections_keys[0];
print ' ' . $from . '(' . $junction_boxes[$from] . ')';
print '-' . $to . '(' . $junction_boxes[$to] . ')';	
print ' Dist:' . $connections{$connections_keys[0]} . "\n";

# Loop through all connections and add them to circuits in the circuitarray
foreach my $key (1..$#connections_keys) {
	
	my($from, $to) = split(/-/, $connections_keys[$key]);
	
	# Print debug info
	print $key;
	print ' ' . $connections_keys[$key];
	
	# Check if connection can be appended to an existing circuit
	my $circuit = 0;
	CIRCUIT: while ($circuit <= $#circuits) {
		my(@circuit_connections) = split(/,/, $circuits[$circuit]);
		foreach my $circuit_connection (0..$#circuit_connections) {
			my($cfrom, $cto) = split(/-/, $circuit_connections[$circuit_connection]);
			
			if (($from == $cfrom) || ($from == $cto) || ($to == $cfrom) || ($to == $cto)) {
				# Add to circuit
				
				$circuits[$circuit] .= ',' . $connections_keys[$key];
				last CIRCUIT;
			}
			
		}		
		$circuit++;
	}
	
	if ($circuit > $#circuits) {
		# Not added to any existing circuits, so we add another circuit
		push(@circuits, $connections_keys[$key]);
	} elsif ($circuit == $#circuits) {
		# Added to last circuit, so we need not check remaining ones
	} else {
		# It was added to existing circuit. However now we have to check remaining circuits if
		# they can be appended to the same circuit
		
		my $circuit_match = $circuit;
		
		$circuit++;
		CIRCUIT: while ($circuit <= $#circuits) {
			my(@circuit_connections) = split(/,/, $circuits[$circuit]);
			foreach my $circuit_connection (0..$#circuit_connections) {
				my($cfrom, $cto) = split(/-/, $circuit_connections[$circuit_connection]);
				
				if (($from == $cfrom) || ($from == $cto) || ($to == $cfrom) || ($to == $cto)) {
					# Add to the earlier found match to current connection
					
					# Move circuit to earlier match
					$circuits[$circuit_match] .= ',' . $circuits[$circuit];
					
					# Remove old one
					splice(@circuits, $circuit, 1);
					
					next CIRCUIT;
				}
				
			}		
			$circuit++;
		}		
		
	}
	
	# Print debug info
	print ' ' . $from . '(' . $junction_boxes[$from] . ')';
	print '-' . $to . '(' . $junction_boxes[$to] . ')';	
	print ' Dist:' . $connections{$connections_keys[$key]} . "\n";
}

my @circuit_sizes;

# Build an array of circuits and their sizes
print 'Circuits:' . "\n";
foreach my $circuit (0..$#circuits) {
	my(@circuit_connections) = split(/,/, $circuits[$circuit]);
	my %circuit_junction_count;
	foreach my $connection (@circuit_connections) {
		my($from, $to) = split(/-/, $connection);
		$circuit_junction_count{$from} = 1;
		$circuit_junction_count{$to} = 1;
	}
	push(@circuit_sizes, scalar keys %circuit_junction_count);
	print $circuit . ' ' . $circuits[$circuit] . ' ' . ($#circuit_connections + 1) . "\n";
}

# Sort to have the biggest first
@circuit_sizes = sort {$b <=> $a} @circuit_sizes;

print "\n" . 'Largest circuits:' . "\n";
print $circuit_sizes[0] . "\n";
print $circuit_sizes[1] . "\n";
print $circuit_sizes[2] . "\n";

my $product = $circuit_sizes[0] * $circuit_sizes[1] * $circuit_sizes[2];

my $output = $product;

# Write output into 'output.txt'
open(my $OUT, '>output1.txt');
print $OUT $output;
print $output;
close($OUT);


