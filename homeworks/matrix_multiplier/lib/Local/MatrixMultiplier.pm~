package Local::MatrixMultiplier;

use strict;
use warnings;
use DDP;
use 5.018;
use JSON::XS;
use Parallel::ForkManager;
use Exporter 'import';
use POSIX ":sys_wait_h";

our @EXPORT = qw(mult);


=head1
Написать модуль производящий паралельное умножение квадратных матриц.

Функция на вход принимает 3 аргумента, матрица A, матрица B, максимальное количество потоков.

Если в модуль была передана не квадратная матрица или матрицы не правильных размеров, то модуль должен бросить исключение.

Local::MatrixMultiplier::mult([[1,3],[2,4]], [[1,2,3],[4,5,6],[7,8,9]], 1);
=cut

sub matrix_dim ($) {
	my $matrix = shift;
	die "matrix must be implemented as array of arrays!"
		unless (ref $matrix eq "ARRAY");
	my @rows = @{$matrix};
	my $row_dim = scalar @rows;
	for my $column(@rows) {
		die "matrix must be implemented as array of arrays!"
			unless (ref $column eq "ARRAY");
		die "matrix must be square!"
			unless (scalar @{$column} == $row_dim);
	}
	return $row_dim;
}

sub calc_row ($$) {
	my ($row_a, $mat_b) = @_;
	my $row_c = [];
	for my $i(0..scalar @{$row_a} - 1) {
		for my $k(0..scalar @{$row_a} - 1) {
			$row_c->[$i] += $row_a->[$k] * $mat_b->[$k]->[$i]
		}
	}
	return $row_c;
}

sub create_input ($$$) {
	my ($dim, $max_child, $mat_a) = @_;
	my %input;
	my $row_for_process = $dim / $max_child;
	if ($row_for_process < 1) {
		$max_child = $dim - 1;
		for(0..$max_child) {
			$input{$_} = {$_ => $mat_a->[$_]};
		}
	}
	else {
		$max_child = $max_child - 1;
		$row_for_process = int($row_for_process);
		my $row_num = 0;
		for (0..$max_child) {
			my %inp_for_proc;
			for (1..$row_for_process) {
				$inp_for_proc{$row_num} = $mat_a->[$row_num];
				$row_num++;
			}
			$input{$_} = \%inp_for_proc;
		}
		if ($row_num < $dim) {
			for ($row_num ..$dim - 1) {
				$input{$max_child}->{$_} = $mat_a->[$_];
			}
		}
	}
	return \%input;
}

sub mult {
	my ($mat_a, $mat_b, $max_child) = @_;
	die "matrixes must have equal dimentions!"
		unless ((my $dim = matrix_dim($mat_a)) == matrix_dim($mat_b));
	my $res = [];
	die "max_child must be >= 0"
		if ($max_child < 0);
	if ($max_child == 0) {
		for (0..$dim - 1) {
			push @{$res}, calc_row($mat_a->[$_], $mat_b);
		}
	}
	elsif ($max_child > 0) {
		my %input = %{create_input($dim, $max_child, $mat_a)};
		my %output;
		my @pipes;
		foreach my $proc(0..$max_child - 1){
			my ($w, $r);
			pipe ($r, $w);
			if (my $pid = fork()) {
				push @pipes, $r;
				close($w);
			}
			else {
				my %child_result;
				close ($r);
				for my $row(keys $input{$proc}) {
					$child_result{$row} = calc_row($input{$proc}->{$row}, $mat_b);
				}
				my $json_text = encode_json \%child_result;
				print $w $json_text;
				$w->autoflush();
				exit;
			}
		}
		wait();
		my $proc = 0;
		for my $r(@pipes) {
			while (<$r>) {
				my %child_result = %{decode_json $_};
				for my $row(sort keys %child_result) {
						$output{$proc}->{$row} = $child_result{$row};
				}
				$proc++;
			}
			close($r);
		}
		for my $proc( sort keys %output ) {
			for my $row( sort keys $output{$proc} ) {
				push @{$res}, $output{$proc}->{$row};
			}
		}
	}
	return $res;
}
1;
