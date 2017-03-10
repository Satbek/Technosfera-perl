#!/usr/bin/perl
use 5.010;
use strict;
use DDP;
use warnings;
use Encode;
say "lets test you";

sub is_anagram ($$) {
	my $first = CORE::fc decode('utf8',shift);
	my $second = CORE::fc decode('utf8',shift);
	return (join ('',sort split ('',$first))) eq 
			(join ('',sort split ('',$second)));
}
sub sort_word ($) {
	my $result;
	$result = CORE::fc decode('utf8', shift);
	return join '',sort split ('',$result);
}
say is_anagram("пятаК","пяткА");
say sort_word("пятка");
