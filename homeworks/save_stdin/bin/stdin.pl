#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use 5.018;
=head1
Программа после запуска должна напечатать приглашение "Get ready\n" в STDOUT.

Далее читает стандартный ввод (STDIN) и перенаправляет всё его додержимое в файл имя которого указывается параметром --file при запуске.

Так же необходимо реализовать перехват сигнала (INT) с клавиатуры (Ctrl+C), после первого нажатия необходимо подтвердить выход из программы написав в STDERR строку: "Double Ctrl+C for exit"

Выход из программы может осуществляться двумя способами:
- двойным нажатием на Ctrl+C 
- по завершению ввода с клавиатуры (Ctrl+D)

При завершении программы в STDOUT должна быть выведена статистика работы программы: размер прочитанных данных, количество строк, стредняя длинна строки). 
=cut

my $sig_int_flag = 0;

$SIG{INT} = sub {
	if ($sig_int_flag) {
		exit(0);
	}
	else {
		$sig_int_flag++;
		print STDERR "Double Ctrl+C for exit";
	}
};

my $file_name;
GetOptions ('file=s' => \$file_name);
unless (defined $file_name) { die "no name for file!" }
open (my $fh, '>:encoding(UTF-8)', $file_name) or die $!;

STDIN->autoflush(1);

my %info;
$info{size_of_data} = 0;
$info{strings_count} = 0;
$info{all_str_length} = 0;

say "Get ready";
while (<STDIN>) {
	$sig_int_flag = 0;
	print $fh $_;
	$info{strings_count}++;
	$info{size_of_data} += do { use bytes; chomp ; length($_) };
	$info{all_str_length} += length($_);
}

END {
	close($fh);
	if ($info{strings_count}) {
		$info{avg_length} = $info{all_str_length}/$info{strings_count};
	}
	else {
		$info{avg_length} = 0;
	}
	say "$info{size_of_data} $info{strings_count} $info{avg_length}";
}
