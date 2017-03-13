#!/usr/bin/perl

use strict;
use warnings;
use 5.018;
use DDP;
use Time::Piece;
#* IP-адрес 1
#* метка времени 2
#* строка запроса 3
#* статус-код выполнения запроса 4
#* кол-во отданных по сети байт сжатых данных 5
#* refferer (URI, с которого был осуществлен вызов запроса) 6
#* user agent (метка браузера или робота, выполнившего запрос) 7
#* коэффициент сжатия данных перед передачей по сети 8

my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;
#03/Mar/2017:18:28:38
sub calculate_host_time (@){
	my @times = shift;
	$_ =~ m/^\d{2}.+\w{3}.+\d{4}:\d{2}:\d{2}:\d{2}$/;
	#my @time = map {Time::Piece->strptime($_, %d/%b/%Y)} @times;
}

sub parse_file {
    my $file = shift;

    # you can put your code here

    my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
	my %logs;
	my %statuses;
    while (my $log_line = <$fd>) {
        # you can put your code here
        # $log_line contains line from log file
		$log_line =~ m/^(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})\s*\[(.+)\]\s*"(.+?)"\s*(\d+)\s*(\d+)\s*"(.*?)"\s*"(.*?)"\s*"(\d+.\d+|.*)"/;
		my $ip = $1;
		$logs{$ip} ||= {};
		$logs{$ip}->{count} ||= 0;
		$logs{$ip}->{count}++;
		my $data = int($5);
		my $status = $4;
		$statuses{$status} = "";#to get the array of statuses
		$logs{$ip}->{"data_$status"} ||= 0;
		$logs{$ip}->{"data_$status"} += $data;
		my $real_data;
		my $coef = $8;
		$logs{$ip}->{"data"} ||= 0;
		unless ($coef eq "-") {
			$logs{$ip}->{"data"} += $data*$coef;
		}
		else {
			$logs{$ip}->{"data"} += $data;
		}
		$logs{$ip}->{"times"} ||= [];
		my $time = $2;
		push $logs{$ip}->{"times"}, $time;
    }
    close $fd;
	for my $ip(keys %logs) {
		for (keys %statuses) {
			$logs{$ip}->{"data_$_"} ||= 0
		}
	}
	p %logs;
    # you can put your code here
	$result = \%logs;
    return $result;
}

sub report {
    my $result = shift;
	my %logs = %{$result};
	my @a = sort {$logs{$b}->{count} <=> $logs{$a}->{count}} keys %logs;
	for my $i(0..9) {
		$logs{$a[$i]}->{data_200} = int($logs{$a[$i]}->{data_200}/1024);
		$logs{$a[$i]}->{data} = int($logs{$a[$i]}->{data}/1024);
		say "$a[$i]\t$logs{$a[$i]}->{count}\t$logs{$a[$i]}->{data_200}\t$logs{$a[$i]}->{data}";
	}
    # you can put your code here

}
