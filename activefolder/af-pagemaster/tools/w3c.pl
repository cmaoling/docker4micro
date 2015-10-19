#!/usr/bin/perl
use strict;
use warnings;
use WWW::Mechanize::Firefox;
use Money::common;
#my $browser = WWW::Mechanize->new();

sub _sleep {
  my $sleepcount = $_[0];
  my $width = $_[1] || $sleepcount;
  for (my $i = 1; $i <= $sleepcount; $i++) {
     print STDERR "\r".common::string4percent(sprintf("%0.2f",$i/$sleepcount), $width);
     sleep(1);
  }
}

  my $code = "";
  while (<>) {
   $code .= $_;
  }

  print STDERR "New Browser Link ";
  my $browser = WWW::Mechanize::Firefox->new();
  print STDERR "- done.\n";
  print STDERR "Get page ";
  $browser->get('http://validator.w3.org/#validate_by_input');
  print STDERR "- done.\n";
  $browser->submit_form(
    with_fields => {
      'fragment' => $code
    }
  );  
  sleep(5);
  my $errorCnt = -1;
  my $warningCnt = -1;
  my $resultPage = $browser->content();
  if ($resultPage =~ /<th>Result:<\/th>[\w\n\s]+<td(?:\scolspan=\"2\")?\sclass=\"(?:in)?valid\"(?:\scolspan=\"2\")?>[\w\n\s]+([\,\<\>\_EPa-z\"\=\s0-9]+?)\swarning/) {
     my $resultSection = $1;
     if ($resultSection =~ /(?:Passed)?[\,\<\>\_a-z\"\=\s]+?([0-9]+)/) {
       $warningCnt = $1;
       $errorCnt = 0;
     } elsif ($resultSection =~ /([0-9]+)\sErrors,\s([0-9]+)/) {
       $warningCnt = $2;
       $errorCnt = $1;
     } else {
       die "Unable to decode count of warnings and errors from result section <$resultSection>";
     }
  } else {
     die "Unable to decode count of warnings and errors";
  }
  if ($errorCnt == 0) {
    print STDERR "PASSED w/ ";
  } else {
    print STDERR "FAILED w/ $errorCnt error(s) and ";
  }
  print STDERR "$warningCnt warning(s).\n";
  print $resultPage ;
