#!/usr/bin/perl
use warnings;
use DDP;
package aaa;
use feature 'say';
use DDP;
use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';
BEGIN { $INC{"aaa.pm"} = "1"; } # fuck you you fucking fuck


########################################################################say arr;

package bbb1;
use aaa qw/PI STRING/;
say PI;
package bbb2;
use aaa qw/:math STRING/;
say PI;
#use Data::Dumper;
#print Dumper \%aaa::
