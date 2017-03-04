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
	for my $i(keys %pair) {
		my @variants = grep {$_ ne $pair{$i} and $all{$_} eq "" and $_ ne $i} keys %all;
		if (scalar @variants == 0) {
			next;
		}
		my $key = $variants[rand(scalar @variants)];
		$all{$key} = $i;
	}
	for (keys %all) {
		push @res,[$all{$_},$_];
	}
	return @res;
}

1;
