#!/usr/bin/perl
use strict;
use warnings;
#use WWW::Mechanize::Firefox;
use WWW::Mechanize;
use Data::Dumper;
#use utf8;
#use encoding 'utf8';
use encoding 'windows-1252';  

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

  $code =~ s/ä/&auml\;/g;
  $code =~ s/ü/&uuml\;/g;
  $code =~ s/ö/&ouml\;/g;
  $code =~ s/Ä/&Auml\;/g;
  $code =~ s/Ü/&Uuml\;/g;
  $code =~ s/Ö/&Ouml\;/g;
  $code =~ s/ /&nbsp\;/g;
 if ($code =~ /(.{10}[^äüöÄÜÖ a-zA-Z0-9\;\&\@\%\#\$\?\!=\"\(\)\[\]<>\-\+\.\,\/:\s\t\w].{10})/) {
	  print STDERR "Unknown character found in code:\n";
	  print STDERR "match: $1\n";
	  print STDERR "       ----------^----------\n";
  } else {
  	  print STDERR "Only characters found in code - done.\n";
   }
  print STDERR "New Browser Link ";
  my $browser = WWW::Mechanize->new(noproxy => 1);
  #my $browser = WWW::Mechanize::Firefox->new();
  print STDERR "- done.\n";
  print STDERR "Get page ";
  $browser->get('http://infohound.net/tidy');
  print STDERR "- done.\n";
  $browser->tick('output-xhtml', 'y','');
  $browser->submit_form(
    with_fields => {
      '_html' => $code,
      'wrap' => 150,
    }
  );  
  sleep(2);
  my $errorCnt = -1;
  my $warningCnt = -1;
  my $resultPage = $browser->content();
  if ($resultPage =~ /No\swarnings\sor\serrors\swere\sfound./) {
     $warningCnt = 0;
     $errorCnt = 0;
  } elsif ($resultPage =~ /([0-9]+)\swarnings?,\s([0-9]+)\serrors\swere\sfound!/) {
     $warningCnt = $1;
     $errorCnt = $2;
  } else {
     print STDERR "About to die";
     sleep(15);
     die "Unable to decode count of warnings and errors";
  }
  print STDERR "Warnings: $warningCnt ; Errors: $errorCnt\n";
  my @messages = ();
  if ($warningCnt + $errorCnt > 0) {
     my $cnt = 0;
     while ($resultPage =~ s/Warning:\s([a-zA-Z0-9\_\&\#\;\"\<\>\s\:\'\!]+?)\s*(<\/td>|\;\s+War)/WARNING $2/) {
	 my $message = $1;
	 my $remainer = $2;
         $message =~ s/&lt\;/</g;
         $message =~ s/&gt\;/>/g;
	 $message =~ s/&quot\;/"/g;
	 $message =~ s/&#39\;/'/g;
        push(@messages," (W) $message");
	print STDERR $messages[$cnt]."\n";
        $cnt++;
     }
     #print STDERR $resultPage;
  }
  if ($browser->follow_link( text => 'Download Tidied File' )) {
    print $browser->content();
  }
#  my $htmlCode = $browser->content();
#  print $htmlCode;
#  my @htmlCode = split(/\n/,$htmlCode);
#  my $payload = "";
#  my $state = 0;
#  foreach my $line (@htmlCode) {
#     if ($state == 0 && $line =~ /\&lt\;/) {
#        $payload .= $line."\n";
#        $state++;
#     } elsif ($state == 1) {
#         unless ($line =~ /</) {
#           $payload .= $line."\n";
#         } else {
#             $state++;
#         }
#     }
#  }
#  $payload =~ s/&lt\;/</g;
#  $payload =~ s/&gt\;/>/g;
#  print $payload."\n";
#   #sleep (15);


