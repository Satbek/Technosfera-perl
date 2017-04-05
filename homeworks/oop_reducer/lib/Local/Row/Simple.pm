package Local::Row::Simple;
use parent Local::Row;
use strict;
use warnings;
use 5.018;
use DDP;
=encoding utf8
=head1 NAME

Параметры конструктора:
* `str` — строка из источника.

Методы:
* `get($name, $default)` — возвращает значение поля `$name` строки лога или `$default`, если таковое отсутствует.
Минимум надо реализовать:
* `Local::Row::Simple` — каждая строка — набор пар `ключ:значение`, соединенных запятой. В ключах и значениях не может быть двоеточий и запятых.

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my ( $self, %args ) = @_;
	die "str doesn't exist"
		unless ( exists $args{str} );
	if ( ref $args{str} ) {
		return undef;
	}
	$self = bless {};
	my @pairs = split ( /,/, $args{str} );
	foreach my $key_value(@pairs) {
		return undef unless ( $key_value =~ m/^(?<key>[^:]+):(?<value>[^:]+)$/ );
		$self->{$+{key}} = $+{value};
	}
	return bless $self;
}

1;
