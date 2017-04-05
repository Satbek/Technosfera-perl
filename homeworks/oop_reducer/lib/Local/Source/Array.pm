package Local::Source::Array;
use parent Local::Source;

use strict;
use warnings;
=encoding utf8

=head1 NAME

Минимум надо реализовать:
* `Local::Source::Array` — отдает поэлементно массив, который передается в конструктор в параметре `array`.
* `next` — возвращает очередную строку или `undef`, если лог исчерпан.
=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my ($self, %args) = @_;
	die "array doesn't exixst"
		unless ( exists $args{array} );
	die "array ref is not array_ref"
		unless (ref $args{array} eq 'ARRAY');
	$self = bless {};
	$self->{array} = $args{array};
	$self->{index_of_current} = 0;
	$self->{index_of_last} = scalar @{$args{array}} - 1;
	return $self;
}

sub next {
	my $self = shift;
	if ( $self->{index_of_current} <= $self->{index_of_last} ) {
		return $self->{array}->[$self->{index_of_current}++];
	}
	else { return undef }
}
1;

