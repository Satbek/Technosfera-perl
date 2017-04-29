#!/usr/bin/perl
use warnings;
use strict;
use 5.018;
use DDP;
sub convert_bytes_to_big_endian {
	my @byte_array = @_;
	my $int = 0;
	while (@byte_array) {
		$int <<= 8;
		$int += shift @byte_array;
	}
	return $int;
}

sub convert_bytes_to_big_endian1 {
	my @arg = @_;
#	my $args = $arg[0].$arg[1];
#	$args+=0;
#	my $bin = pack "C", $arg[0];
#	my $bin1 = pack "C", $arg[1];
#	$bin = $bin.$bin1;
	my $bin = pack "C*", @arg;
	$bin = unpack "n", $bin;
	return $bin;
}
my @int = (23,32);

p convert_bytes_to_big_endian(@int);
p convert_bytes_to_big_endian1(@int);
