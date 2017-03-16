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
my %statuses;
sub parse_file {
    my $file = shift;

    # you can put your code here

    my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
	my %logs;
    while (my $log_line = <$fd>) {
        # you can put your code here
        # $log_line contains line from log file
		$log_line =~ m/^(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})\s*\[(\d{2}\/\w+\/\d{4}:\d{2}:\d{2}:\d{2} \+0300)\]\s*"(.+?)"\s*(\d+)\s*(\d+)\s*"(.*?)"\s*"(.*?)"\s*"(\d+.\d+|.*)"/;
		my $ip = $1;
		$logs{$ip} ||= {};
		$logs{$ip}->{count} ||= 0;
		$logs{$ip}->{count}++;
		my $data = $5;
		my $status = $4;
		$statuses{$status} = "";#to get the array of statuses
		$logs{$ip}->{"$status"} ||= 0;
		$logs{$ip}->{"$status"} += $data;
		my $coef = $8;
		$logs{$ip}->{"data"} ||= 0;
		if ($status eq "200") {
			if ($coef ne "-") {
				$logs{$ip}->{"data"} += int($data*$coef);
			}
			else {
				$logs{$ip}->{"data"} += $data;
			}
		}
		$logs{$ip}->{"times"} ||= [];
		my $time = $2;
		push $logs{$ip}->{"times"}, $time;
    }
    close $fd;
	for my $ip(keys %logs) {
		for (keys %statuses) {
			$logs{$ip}->{"$_"} ||= 0
		}
	}
    # you can put your code here
	$result = \%logs;
    return $result;
}

sub report {
    my $result = shift;
	my %logs = %{$result};
	my @a = sort {$logs{$b}->{count} <=> $logs{$a}->{count}} keys %logs;
	for my $k(keys %logs) {
		#03/Mar/2017:18:28:38 +0300
		my %seen;
		$logs{$k}->{uniq_minuets} = scalar grep {!$seen{$_}++} map {$_ =~ s/:\d{2}\s+\+0300//; $_;} @{$logs{$k}->{"times"}};
		$logs{$k}->{avg} = $logs{$k}->{count}/$logs{$k}->{uniq_minuets};
	}
	my %total;
	for my $k(keys %logs) {
		$total{count} ||= 0;
		$total{count} += $logs{$k}->{count};
		$total{data} ||= 0;
		$total{data} += $logs{$k}->{data};
		for (sort(keys %statuses)) {
			$total{$_} ||= 0;
			$total{$_} += $logs{$k}->{$_};
		}
		$total{minuetes} ||= [];
		push $total{minuetes}, @{$logs{$k}->{"times"}};
	}
	my %seen;
	$total{uniq_minuets} = scalar grep {!$seen{$_}++} @{$total{minuetes}};
	$total{avg} = $total{count}/$total{uniq_minuets};
	$total{data} = int($total{data}/1024);
	for (sort(keys %statuses)) {
			$total{$_} = int($total{$_}/1024);
	}
	#p %logs;
	p %total;
	print "IP\t\tcount\tavg\tdata\t200\t301\t302\t400\t403\t404\t408\t414\t499\t500\n";
	print "total\t\t$total{count}\t";
	printf("%.2f\t", $total{avg});
	print "$total{data}\t$total{200}\t$total{301}\t$total{302}\t$total{400}\t$total{403}\t$total{404}\t$total{408}\t$total{414}\t$total{499}\t$total{500}\t\n";
	for my $i(0..9) {
		$logs{$a[$i]}->{data} = int($logs{$a[$i]}->{data}/1024);
		print "$a[$i]\t$logs{$a[$i]}->{count}\t";
		printf("%.2f\t", $logs{$a[$i]}->{avg});
		print "$logs{$a[$i]}->{data}\t";
		for (sort(keys %statuses)) {
			$logs{$a[$i]}->{$_} = int($logs{$a[$i]}->{$_}/1024);
			print "$logs{$a[$i]}->{$_}\t";
		}
		print "\n";
	}
    # you can put your code here

}
