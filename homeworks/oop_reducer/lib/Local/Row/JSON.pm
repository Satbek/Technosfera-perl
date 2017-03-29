package Local::Row::JSON;
use parent Local::Row;
use strict;
use warnings;
use JSON 'decode_json';
=encoding utf8

=head1 NAME

Параметры конструктора:
* `str` — строка из источника.

Методы:
* `get($name, $default)` — возвращает значение поля `$name` строки лога или `$default`, если таковое отсутствует.
* `Local::Row::JSON` — каждая строка — JSON-object (хеш в формате JSON).

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
	eval { $self = decode_json($args{str}); } or return undef; 
	unless ( ref $self eq "HASH" ) {
		return undef;
	}
	return bless $self;
}


1;
