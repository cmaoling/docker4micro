#!/usr/bin/perl
use strict;
use warnings;
my $troublemaker = 0;
while (<>) {
  #if (/(.{10}[€ äüöÄÜÖß].{10})/) {
  if (/(.{10}([^a-zA-Z 0-9:\-=\<\>\/\"\;\.\-\,\_\?\!\[\]\(\)\#\&\|\%\+\'\@]).{10})/) {
	  my $match=$1;
	#  if ($match =~ /[äüöÄÜÖß]/) {
	    print STDERR "Unknown character found in code:\n";
	    print STDERR "match: $1\n";
	    print STDERR "       ----------^----------\n";
	    $troublemaker = 1;
        #  }
  }
}
if ($troublemaker) {
	exit 1
} else {
  	  print STDERR "Only characters found in code - done.\n";
	  exit 0
}
 
