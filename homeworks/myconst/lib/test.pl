#!/usr/bin/perl
use warnings;
use DDP;

#!/usr/bin/perl

use strict;
use warnings;




#####################################################

#####################################################
#####################################################
package nnn;
use myconst phys => {g => 9.81 , PI => 3.1416 };
BEGIN { $INC{"nnn.pm"} = "1"; } # fuck you you fucking fuck

package aaa;
use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';
BEGIN { $INC{"aaa.pm"} = "1"; } # fuck you you fucking fuck
use DDP;
#p @ISA;
#print "package aaa\n";
# @EXPORT_OK;
#p @EXPORT_TAGS;

#####################################################

#####################################################
package bbb1;
use aaa qw/PI STRING/;

package bbb2;
use aaa qw/:math STRING/;

package bbb3;
use aaa qw/:all/;
package bbb4;
use aaa qw/STRING :all :math/;

package mmm3;
use nnn qw/:phys/;
#####################################################

package main;

#####################################################

