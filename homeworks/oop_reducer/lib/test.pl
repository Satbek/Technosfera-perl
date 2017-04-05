#!/usr/bin/perl
use warnings;
use strict;
use Local::Source::Array;
use Local::Source::Text;
use Local::Row::JSON;
use DDP;
use Local::Row::Simple;
use Local::Reducer;
use Local::Reducer::Sum;
use Local::Reducer::MaxDiff;
#use diagnostics;
use 5.018;
my $var = Local::Reducer::Sum->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
        'not-a-json',
        '{"price": 0}',
        '{"price": 1}',
        '{"price": 2}',
        '[ "invalid json structure" ]',
        '{"price":"low"}',
        '{"price": 3}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

p $var;
p $var->reduce_all();
p $var->reduced;
