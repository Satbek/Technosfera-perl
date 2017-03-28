#!/usr/bin/perl
use strict;
use warnings;
use 5.018;
use DDP;
package aaa;

use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';
BEGIN { $INC{"aaa.pm"} = "1"; } # fuck you you fucking fuck
########################################################################
#say arr;

package bbb1;
use aaa qw/PI STRING/;
use Data::Dumper;
#print Dumper \%aaa::
