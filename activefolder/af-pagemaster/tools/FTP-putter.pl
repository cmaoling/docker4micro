#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Net::FTP;
my $host = "ev-kirche-holzgerlingen.de";
my %args;
my $DEBUG = 0;
my $ftp = Net::FTP->new($host) || die "(E) Filed to start FTP client.";
if ($ftp->login("evkirche", 'm&t%v$k/a')) {
	print "(I) Connection to $host established\n";
        #print $ftp->pwd()."\n";
	while (<>) {
		if (/put,([a-zA-Z0-9\_\.\/\-]+),([a-zA-Z0-9\_\-\.\/]+)/) {
			unless ($DEBUG) {
				my $source = $1;
				my $target = $2;
				if ($source =~ /([a-zA-Z0-9\_\.\/\-]+)\.([a-zA-Z]+)/) {
					my $ext = $2;
					if ($ext !~ /table/i && $ext !~ /html/i) {
						print "(I) change to binary transfer due to extention <$ext>" if $ftp->binary;
					}
				}
				if ($ftp->put($source,$target)) {
					print "(I) $source => $target - done."
				} else {
					print "(E) $source => $target - FAILED."
				}
				print "\n";
			} else {
				print "1: $1  2: $2\n";
				print "\n";
			}
		} else {
			print "(W) Line skipped: $_";
		}
	}
	if ($ftp->quit) {
		print "(I) Connection to host ($host) closed\n";
	} else {
		print "(E) Unable to close connection to host ($host).\n";
	}
} else {
	print "(E) Failed to login to host ($host).\n";	
}
