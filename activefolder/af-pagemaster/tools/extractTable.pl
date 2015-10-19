#!/usr/bin/perl
use strict;
use warnings;
my $payload = "";
my $state = 0;
while (<>) {
     if ($state == 0 && /<body>/) {
        $state++;
     } elsif ($state == 1) {
         unless (/<\/body>/) {
           $payload .= $_;
         } else {
             $state++;
         }
     }
}
print $payload;
