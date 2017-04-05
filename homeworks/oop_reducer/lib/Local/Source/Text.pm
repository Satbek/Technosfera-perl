package Local::Source::Text;
use parent Local::Source;
use strict;
use warnings;
=encoding utf8

=head1 NAME

* `Local::Source::Text` — отдает построчно текст, который передается в конструктор в параметре `text`. Разделитель — `\n`, но можно изменить параметром конструктора `delimiter`.

source => Local::Source::Text->new(text =>"sended:1024,received:2048\nsended:2048,received:10240"),

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my ($self, %args) = @_;
	die "text param doesn't exixst"
		unless ( exists $args{text} );
	die "text is not scalar"
		if ( ref $args{text} );
	$self = bless {};
	$self->{text} = $args{text};
	if ( exists $args{delimiter} ) {
		$self->{delimiter} = $args{delimiter};
	}
	else {
		$self->{delimiter} = '\n';
	}
	die "delimiter is not a scalar"
		if ( ref $args{delimiter} );
	$self->{strings} = [split ( /$self->{delimiter}/, $self->{text} , -1 )];
	return $self;
}

sub next {
	my $self = shift;
	if (scalar @{$self->{strings}} ) { return shift @{$self->{strings}}; }
	else { return undef };
}
1;

