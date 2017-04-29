#!/usr/bin/perl
use warnings;
use strict;
use 5.018;
use FSM::Simple;
use DDP;
use JSON::XS;
use Encode;
no warnings 'experimental::smartmatch';
use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);
#* other:
#  + execute => 1 бит
#  + write   => 2 бит
#  + read    => 4 бит
#* group
#  + execute => 8 бит
#  + write   => 16 бит
#  + read    => 32 бит
#* user
#  + execute => 64 бит
#  + write   => 128 бит
#  + read    => 256 бит
#         "execute" : true,
#         "write" : false
#         "read" : true,
#user" : {
#         "execute" : true,
#         "write" : true,
#         "read" : true
#      },
#      "group" : {
#         "execute" : true,
#         "write" : true,
#         "read" : true
#      }
sub mode2s {
	# Тут был полезный код для распаковки численного представления прав доступа
	# но какой-то злодей всё удалил.
	
}
open(my $fh, '<:raw', "data/example1.bin");
my $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
encode("utf8", $data);
say $data;

read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
#$data = decode("utf8", $data);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 4);
$data = unpack 'N', $data;
say $data;
read($fh, $data, 20);
$data = unpack 'H*', $data;
say $data;
read($fh, $data,1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
#$data = decode("utf8", $data);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 4);
$data = unpack 'N', $data;
say $data;
read($fh, $data, 20);
$data = unpack 'H*', $data;
say $data;
read($fh, $data,1);
say $data;
read($fh, $data,1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
encode("utf8", $data);
say $data;

read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
#$data = decode("utf8", $data);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 4);
$data = unpack 'N', $data;
say $data;
read($fh, $data, 20);
$data = unpack 'H*', $data;
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
#$data = decode("utf8", $data);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 4);
$data = unpack 'N', $data;
say $data;
read($fh, $data, 20);
$data = unpack 'H*', $data;
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 2);
$data = unpack 'n', $data;
say $data;
read($fh, $data, $data);
encode("utf8", $data);
say $data;

read($fh, $data, 2);
$data = unpack 'n', $data;
read($fh, $data, 1);
say $data;
read($fh, $data, 1);
say $data;

#say $data;
#say sha1($data);
