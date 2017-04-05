package Local::Reducer;

use strict;
use warnings;
use Scalar::Util 'blessed';
use Local::Source;
use Local::Row;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer
=cut
=head1 VERSION

Version 1.00
Reducer
-------

Каждый такой класс имеет префикс `Local::Reducer`. Отвечает за непосредственно схлопывания, но абстрагирован от способа получения и парсинга данных.

Параметры конструктора:
* `source` — объект, выдающий строки из лога (см. ниже);
* `row_class` — имя класса, с помощью которого создаются объекты из каждой строки логов (см. ниже);
* `initial_value` — инициализационое значение для операции схлопывания.

Методы:
* `reduce_n($n)` — схлопнуть очередные `$n` строк, вернуть промежуточный результат.
* `reduce_all()` — схлопнуть все оставшиеся строки, вернуть результат.
* `reduced` — промежуточный результат.

Минимум надо реализовать:
* `Local::Reducer` — базовый абстрактный класс.
* `Local::Reducer::Sum` — суммирует значение поля, указанного в параметре `field` конструктора, каждой строки лога. В случае, если соответствующее поле не содержит числовое значение, строка игнорируется.
* `Local::Reducer::MaxDiff` — выясняет максимальную разницу между полями, указанными в параметрах `top` и `bottom` конструктора, среди всех строк лога. В случае, если соответствующие поля не содержат числовые значения, строка игнорируется.

Также можно реализовать:
* `Local::Reducer::MinMaxAvg` — считает минимум, максимум и среднее по полю, указанному в параметре `field`. Результат (`reduced`) отдается в виде объекта с методами `get_max`, `get_min`, `get_avg`. В случае, если соответствующие поля не содержат числовые значения, строка игнорируется.

my $reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::Text->new(text =>"sended:1024,received:2048\nsended:2048,received:10240"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);

=cut

our $VERSION = '1.00';


sub reduce {
	my $self = shift;
	my $row = $self->{source}->next; 
	if ($row) {
		#...
	}
	else { return undef }
}
sub new {
	my ($class, %args) = @_;
	die "source field doesn't exist"
		unless ( exists $args{source} );
	die "row_class field doesn't exist"
		unless ( exists $args{row_class} );
	die "initial_value field doesn't exist"
		unless ( exists $args{initial_value} );
	eval {
		blessed( $args{source} ) and $args{source}->isa( "Local::Source" );
	} or die "source field is incorrect";
	eval {
		$args{row_class}->isa( "Local::Row" );
	} or die "row_class field is incorrect";
	die "initial_value is not scalar" 
		if ( ref $args{initial_value} );
	my $self = bless {};
	$self->{source} = $args{source};
	$self->{row_class} = $args{row_class};
	$self->{reduced} = $args{initial_value};
	return bless $self, $class;
}
sub reduce_n($) {
	my ($self, $n) = @_;
	for (1..$n) {
		$self->reduce();
	}
	return $self->reduced;
}
sub reduce_all() {
	my $self = shift;
	while(1) { last unless (defined $self->reduce()) }
	return $self->reduced;
}

sub reduced {
	my $self = shift;
	return $self->{reduced};
}

1;
