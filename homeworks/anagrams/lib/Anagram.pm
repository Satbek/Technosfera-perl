package Anagram;

use 5.010;
use strict;
use warnings;
use Encode;
=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub is_anagram ($$) {
	my $first = CORE::fc decode('utf8',shift);
	my $second = CORE::fc decode('utf8',shift);
	return (join ('',sort split ('',$first))) eq 
			(join ('',sort split ('',$second)));
}

sub anagram {
	my $words_list = shift;
	my %result;
	my %buf_result;
	for (@$words_list) {
		$buf_result{sorted_word($_)} ||= [];
		push @{$buf_result{sorted_word($_)}}, CORE::fc decode('utf8', $_);
	}
	for my $key (keys %buf_result) {
		if (scalar @{$buf_result{$key}} == 1) {
			next;
		}
		my $new_key = encode('utf8', $buf_result{$key}[0]);
		$buf_result{$key} = [sort @{$buf_result{$key}}];
		$result{$new_key} = do {
			my %seen;
			[grep {!$seen{$_}++} map {encode('utf8', $_)} @{$buf_result{$key}}];
		};
	}
    #
    # Поиск анограмм
    #

	return \%result;
}

1;
