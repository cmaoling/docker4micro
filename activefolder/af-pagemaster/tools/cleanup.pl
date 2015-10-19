#!/usr/bin/perl
use strict;
use warnings;
my $troublemaker = 0;
while (<>) {
  my $original = $_;
  s/Monday/Montag/;
  s/Tuesday/Dienstag/;
  s/Wednesday/Mittwoch/;
  s/Thursday/Donnerstag/;
  s/Friday/Freitag/;
  s/Saturday/Samstag/;
  s/Sunday/Sonntag/;
  s/January/Januar/;
  s/February/Februar/;
  s/March/März/;
  s/May/Mai/;
  s/June/Juni/;
  s/July/Juli/;
  s/October/Oktober/;
  s/December/Dezember/;
  s/\x{A0}/\&ndash\;/g;
  s/\x{DF}/\&szlig\;/g;
  s/\x{C4}/\&Auml\;/g;
  s/\x{D6}/\&Ouml\;/g;
  s/\x{DC}/\&Uuml\;/g;
  s/\x{E4}/\&auml\;/g;
  s/\x{F6}/\&ouml\;/g;
  s/\x{FC}/\&uuml\;/g;
  s/ä/\&auml\;/g;
  s/ö/\&ouml\;/g;
  s/ü/\&uuml\;/g;
  s/Ä/\&Auml\;/g;
  s/Ö/\&Ouml\;/g;
  s/Ü/\&Uuml\;/g;
  s/„/"/g;
  s/“/"/g;
  if ($original ne $_) {
     s/([0-9]+)\/\s/$1. /;
  }
  print $_;
}
