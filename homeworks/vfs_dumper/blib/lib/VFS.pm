package VFS;
use utf8;
use strict;
use warnings;
use 5.010;
use File::Basename;
use File::Spec::Functions qw{catdir};
use JSON::XS;
no warnings 'experimental::smartmatch';
use DDP;
use Encode;

sub mode2s {
	# Тут был полезный код для распаковки численного представления прав доступа
	# но какой-то злодей всё удалил.
	my $mode = shift;
	my @mode = @{$mode};
	my $mode_bin1 = sprintf("%b", $mode[0]);
	my $mode_bin2 = sprintf("%b", $mode[1]);
	my @mode_bin = reverse split(//, $mode_bin1.$mode_bin2);
	my $modes = {};
	my $true = JSON::XS::true;
	my $false = JSON::XS::false;
	for my $group ('other', 'group', 'user'){
		$modes->{$group} = {};
		for my $type ('execute', 'write', 'read'){
			$modes->{$group}{$type} = (shift @mode_bin);
		}
	}
	for my $group (keys %{$modes}) {
		for my $type(keys %{$modes->{$group}}) {
			if ($modes->{$group}{$type}) { 
				$modes->{$group}{$type} = JSON::XS::true;
			}
			else { $modes->{$group}{$type} = JSON::XS::false }
		}
	}
	return $modes;
}


sub parse {
	#Тут было готовое решение задачи, но выше упомянутый злодей добрался и
	# сюда. Чтобы тесты заработали, вам предстоит написать всё заново.
	my $buf = shift;
	my $res = {};
	my @data = unpack "C*", $buf;
	my $command = chr(shift @data);
	my @deep;
	if (not $command =~ m/D|Z/) {
		die "The blob should start from 'D' or 'Z'";
	}
	while (@data) {
		given ($command) {
			when ('D') {
				my $buf_res->{type} = "directory";
				my $len += join '', (splice (@data, 0, 2));
				my $dir_name = 
					join '', map {$_ = chr($_)} splice (@data, 0, $len);
				$dir_name = decode("utf8", $dir_name);
				$buf_res->{name} = $dir_name;
				my $mode = [splice (@data, 0, 2)];
				$buf_res->{mode} = mode2s($mode);
				$buf_res->{list} = [];
				if (!@deep) { $res = $buf_res; }
				else { push @{$deep[0]}, $buf_res }
				$res->{cur_dir} = $buf_res;
				$command = chr (shift @data);
			}
			when ('I') {
				unshift @deep, $res->{cur_dir}->{list};
				$command = chr (shift @data);
			}
			when ('F') {
				my $buf_res->{type} = "file";
				my @len = splice (@data, 0, 2);
					my @arg = @_;
				my $len = pack "C*", @len;
				$len = unpack "n", $len;
				my $file_name = 
					join '', map {$_ = chr($_)} splice (@data, 0, $len);
				$file_name = decode("utf8", $file_name);
				$buf_res->{name} = $file_name;
				my $mode = [splice (@data, 0, 2)];
				$buf_res->{mode} = mode2s($mode);
				my @size = splice (@data, 0, 4);
				my $size = pack "C*", @size;
				$size = unpack "N", $size;
				$buf_res->{size} = $size;
				my @hash = splice (@data, 0, 20);
				my $hash = pack "C*", @hash;
				@hash = unpack "H*", $hash;
				$buf_res->{hash} = join '', @hash;
				push @{$deep[0]}, $buf_res;
				$command = chr (shift @data);
			}
			when ('U') {
				shift @deep;
				$command = chr (shift @data);
			}
			when ('Z') {
				die "Garbage ae the end of the buffer" if @data;
				last;
			}
			default {
				die "Garbage ae the end of the buffer";
			}
		}
	}
	delete $res->{cur_dir};
	return $res;
}
1;

