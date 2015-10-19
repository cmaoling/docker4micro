#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Net::FTP;
my $host = "ev-kirche-holzgerlingen.de";
my %args;
my $DEBUG = 0;
my $FORCE = 0;
my $ftp = Net::FTP->new($host) || die "(E) Filed to start FTP client.";
if ($ftp->login("evkirche", 'm&t%v$k/a')) {
	print "(I) Connection to $host established\n";
        #print $ftp->pwd()."\n";
	while (<>) {
		if (/promote\s*,\s*([a-zA-Z0-9\_\.\/]+)/) {
			unless ($DEBUG) {
				my $promote = $1;
				print "(I) Promote file = $promote\n";
				if ($promote =~ /([a-zA-Z0-9\_\.\/]+\/)?([a-zA-Z0-9\_]+)\./) {
					my $dir = $1 || "";
					my $preview = $2;
					my $suffix = $' ;
					my $xfr = $ftp->retr( $promote);
					if (defined $xfr) {
						$xfr->abort;
						undef $xfr;					
						if ($preview =~ /([a-zA-Z0-9]+)_preview/) {
							my $base = $1;
							#print "promote: <$promote> dir: <$dir> base: <$base> suffix: <$suffix>\n";
							my $current = $dir.$base."\.".$suffix;
							print "(I) current file = $current\n";
							my $xfr = $ftp->retr( $current );
							my $needUndo = 0;
							my $previous = "";
							if (defined $xfr) {
								my $buf;
								$xfr->read( $buf, 50 );
								#print $buf."\n";
#								if ($buf =~ /\<div\s+id\=\"([a-zA-z0-9\_]+)\"/) {}
                                                                if ($buf =~ /\<cite\>([a-zA-z0-9\_]+)\<\/cite\>/) {
									$xfr->abort;
									undef $xfr;
									$previous = $dir.$1."\.".$suffix;
									print "(I) rename: <$current> => <$previous> - ";
									if ($ftp->rename("$current" , "$previous" )) {
										print "done";
										$needUndo = 1;
									} else {
										print "FAILED";
									}
									print "\n";
								} else {
									print "(E) Cannot determine tag of table ($current).\n";
								}
							} else {
								print "(E) Retrieval of file ($current) failed.\n";
							}
							print "(I) rename: <$promote> => <$current> - ";
							if ($ftp->rename($promote , $current)) {
								print "done";
							} else {
								print "FAILED";
								if ($needUndo) {
									print "(I) rename (undo): <$previous> => <$current> - ";
									if ($ftp->rename("$previous" , "$current" )) {
										print "done";
									} else {
										print "FAILED";
									}										
								}
							}
							#if ($ftp->rename("deadbeef","foo")) {
							#	print "done";
							#} else {
							#	print "FAILED";
							#}
							print "\n";
						} else {
							print "(W) Promotion of non-preview file <$preview> rejected.\n";
						}
					} else {
						print "(W) Unable to find file <$promote>, which is suppose to be promoted.\n";						
					}
				} else {
					print "(E) Failed to decode promote command.\n";
				}
			} else {
				print "1: $1 \n";
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
