package SecretSanta;
use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {
	my @members = @_;
	my @res;
	my %pair;
	my %all;
	for (@members) {
		if (ref $_ eq "ARRAY") {
			$pair{$_->[0]} = $_->[1];
			$pair{$_->[1]} = $_->[0];
			$all{$_->[0]} = "";
			$all{$_->[1]} = "";
		}
		elsif (not ref $_) {
			$pair{$_} = "";
			$all{$_} = "";
		}
		else {
			die "wrong input\n";
		}
	}
	my $success = 1;
	my @pairs = keys %pair;
	my %buf_pair = %pair;
	my %buf_all = %all;
	while (1) {
		@pairs = sort {int(rand(3)) - 1} @pairs;
		for my $i(@pairs) {
			my @variants = grep {$_ ne $pair{$i} and $all{$_} eq "" and $_ ne $i} keys %all;
			if (scalar @variants == 0) {
				$success = 0;
				last;
			}
			my $key = $variants[rand(scalar @variants)];
			$all{$key} = $i;
		}
		if (!$success) {
			%pair = %buf_pair;
			%all = %buf_all;
			$success = 1;
			redo;
		}
		for (keys %all) {
			push @res,[$all{$_},$_];
		}
		last;
	}
	return @res;
}

1;
