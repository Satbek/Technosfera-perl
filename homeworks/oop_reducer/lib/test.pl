#!/usr/bin/perl
use warnings;
use strict;
use Local::Source::Array;
use Local::Source::Text;
use Local::Row::JSON;
use DDP;
use Local::Row::Simple;
#use diagnostics;
use 5.018;
my $var = Local::Row::Simple -> new (str => 'sended:1024,received:2048');
p $var;
