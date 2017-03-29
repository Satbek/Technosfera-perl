package Local::Row;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Row - base abstract parser

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new { };

sub get ($$) {
	my ( $self, $name, $default ) = @_;
	my $res;
	return $self->{$name} if ( exists $self->{$name} );
	return $default;
}

1;
