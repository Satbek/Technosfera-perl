package myconst;

use strict;
use warnings;
use Scalar::Util 'looks_like_number';
use DDP;
#use Exporter 'import';
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

use parent "Exporter";
sub create_func($$) {
	my ($key, $value) = @_;
	$value = quotemeta($value);
	eval ("sub $key() { return \"$value\"; }");
	die $@ if $@;
}

our @EXPORT;
our %EXPORT_TAGS;
our @EXPORT_OK;
sub import {
	my $module_name = shift;
	if ($module_name ne __PACKAGE__) { #мы не в myconst, должны экспортировать все
		die "another package";
		unshift @_, $module_name;
		goto &Exporter::import;
		myconst->export_to_level(1, @EXPORT = qw/import/);
	}
	else {
		if (scalar @_ %2 != 0 ) {
			die "odd args";
		}
		if (@_) {
			my %args = @_;
			foreach (keys %args) {
				if (not ref $args{$_}) {
					create_func($_, $args{$_});
					push @EXPORT, $_;
				push @{$EXPORT_TAGS{all}}, $_;
				}
				elsif (ref $args{$_} eq "HASH") {
					my $group = $_;
					my %hash = %{$args{$_}};
					foreach (keys %hash) {
						die "incorrect args" if (ref $hash{$_}); 
						create_func($_, $hash{$_});
						push @EXPORT, $_;
						push @{$EXPORT_TAGS{$group}}, $_;
						push @{$EXPORT_TAGS{all}}, $_;
					}
				}
				else { die "incorrect args" };
			}
		}
	}
	@EXPORT_OK = @EXPORT;
	myconst->export_to_level(1,undef);
	#p @EXPORT;
	#p $_;
	#p @EXPORT_OK;
	#p %EXPORT_TAGS;
}

1;
