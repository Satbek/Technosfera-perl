package myconst;

use strict;
use warnings;
use Scalar::Util 'looks_like_number';
use DDP;

=encoding utf8

=head1 NAME

myconst - pragma to create exportable and groupped constants

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS


package aaa;
use myconst math => {
        PI => 3.14,
        E => 2.7,A->export_to_level(1, @_);
    },
    ZERO => 0,
    EMPTY_STRING => '';

package bbb;

use aaa qw/:math PI ZERO/;

print ZERO;             # 0
print PI;               # 3.14
=cut

my $package = caller;

sub create_func($$) {
	my ($key, $value) = @_;
	die "invalid constant name" unless ($key =~ /[a-zA-z]/);
	die "invalid constant" unless ($value =~ /[a-zA-z0-9_]/);
	$value = quotemeta($value);
	eval ("sub ${package}::$key() { return \"$value\"; }");
	die $@ if $@;
}

my @EXPORT_OK;
my %EXPORT_TAGS;
sub import {
	no strict;
	@{"${package}::ISA"} = qw(Exporter); #"
	use strict;
	my $module_name = shift;
	if (scalar @_ %2 != 0 ) {
		die "odd args";
	}
	my %args = @_;
	foreach my $name (keys %args) {
		if (not ref $args{$name}) {
			create_func($name, $args{$name});
			push @EXPORT_OK, $name;
			push @{$EXPORT_TAGS{all}}, $name;
		}
		elsif (ref $args{$name} eq "HASH") {
			my $group = $name;
			my %hash = %{$args{$name}};
			foreach my $f_name (keys %hash) {
				die "incorrect args" if (ref $hash{$f_name}); 
				create_func($f_name, $hash{$f_name});
				push @EXPORT_OK, $f_name;
				push @{$EXPORT_TAGS{$group}}, $f_name;
				push @{$EXPORT_TAGS{all}}, $f_name;
			}
		}
		else { die "incorrect args" };
	}
	no strict;
	%{"${package}::EXPORT_TAGS"} = %EXPORT_TAGS; #"
	@{"${package}::EXPORT_OK"} = @EXPORT_OK; #"
	use strict;
}

1;

