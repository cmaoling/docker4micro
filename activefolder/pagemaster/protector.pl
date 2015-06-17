#!/usr/bin/perl
#-*- coding: utf-8 -*-
use strict;
use warnings;
use functions;

my $file;

if (1==1) {
for $file (@ARGV) {
   _Imsg $file;
}
for $file (@ARGV) {

  my $clean=1;
  if ( -e $file ) {
    open (MYFILE, $file);
    while (<MYFILE>) {
        chomp;
        my $base=$_;
        my $line = "";
        if (/\#/) {
          $line=$`;
        } else {
          $line=$_;
        }
        if ($line ne "" && $line =~ /^\s*use\s+([a-zA-Z0-9\:]+)/) {
            my $module=$1;
            #print "<$base> => ";
            #print "$line  [$module]";
            if (_action(__header()."Checking module $module", "require $module;")) { $clean = 0; };
        }
    }
    close (MYFILE);
  } else {
     $clean = -1;
  }
  print __header."Check for $file ";
  if ($clean == 1) {
          echo_passed; print "\n";
          { # otherwise the @ARGV will be visible to the filed do-ed.
              local @ARGV = ();
              my $return = -1;
              if ($return = do $file) {
                  if ($return != 0) {
                    _Wmsg "run of $file returned RC=$return.";
                  } else {
                    _Pmsg "$file completed w/ RC=0";
                  }
              } else {
                  if ($@) {
                   _Wmsg "couldn't compule $file: $@";
                  } else {
                   _Pmsg "$file parsed w/o errors";
                  }
                  if (defined $return) {
                    if ($return != 0) {
                      _Wmsg "compile of $file returned RC=$return.";
                    } else {
                      _Pmsg "$file compiled w/ RC=0";
                    }
                  } else {
                    _Emsg "Unable to do $file. \@:<$@> !:<$!> ?:<$?>";
                }
              }
           }
  } elsif ($clean >= 0) {
       echo_warning; print "\n";
  } else {
       echo_failure; print "\n";
  }

}
}
