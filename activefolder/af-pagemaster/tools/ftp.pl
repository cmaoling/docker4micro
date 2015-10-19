#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Net::FTP;
my $host = "ev-kirche-holzgerlingen.de";
my %args;

my $ftp = Net::FTP->new($host);
$ftp->login("evkirche", 'm&t%v$k/a');
print $ftp->pwd();
print $ftp->ls();
#$sftp->get("foo", "bar");

$ftp->put("bar", "baz");
$ftp->put("bar", "foo");
$ftp->put("test_/test_preview.dieseWoche.table", "veranstaltungen/test_preview.dieseWoche.table");
$ftp->rename("foo", "deadbeef");
$ftp->quit;