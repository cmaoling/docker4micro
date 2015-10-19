#!/usr/bin/perl
#-*- coding: utf-8 -*-
my $VERSION    = "0.4";
my $SCRIPTNAME = $0;
print STDERR "#==================================================================#\n";
print STDERR "# $SCRIPTNAME v$VERSION by Nicolas Mäding, (c) Nic-Services, 2012  #\n";
print STDERR "#==================================================================#\n";
use strict;
use warnings;
use utf8;
use encoding 'windows-1252';
use Spreadsheet::Read qw(row rows ReadData);
use Switch;
use Perl::Tidy;
use Data::Dumper;
use functions;
my $spreadsheet = shift;
my $tag         = shift;
my $commonID    = 0;
my $streamCnt   = 0;
#print STDERR "# (I) [data] Spreadsheet: <$spreadsheet>\n";
my @tableBase = ();

my $base   = "none";
my $format = "unknown";
if ( $spreadsheet =~ /\/?([a-z0-9_A-Z\s]+)\.([A-Za-z0-9\s]+)$/ ) {
      $base   = $1;
      $format = $2;
}
my $ref;
print STDERR "# (I) [data] Reading spreadsheet '$spreadsheet' with format <$format> and basename <$base>...";
switch ($format) {
      case "ods" { $ref = ReadData( $spreadsheet, strip => '0' ); last; }
      case "csv" { $ref = ReadData( $spreadsheet, sep => '»', quote => '`', strip => '0' ); last; }
      case "xls"  { $ref = ReadData($spreadsheet); last; }
      case "xlsx" { $ref = ReadData($spreadsheet); last; }
      default     { die "Unkown format: <$format>"; }
}
print STDERR "done.\n";
{
      my $feedback = `chgrp pagemaster $spreadsheet`;
      print STDERR "# (I) [data] Making $spreadsheet owned by pagemaster: $feedback.\n";
}
#print Dumper($ref);
#my $return=system("ls -la $spreadsheet");
if ( defined $ref->[0]{sheets} && $ref->[0]{sheets} > 0 ) {
      print STDERR "# (I) [data]  +-+- Sheetcount: " . $ref->[0]{sheets} . "\n";
      my @fileHnd   = ();
      my @fileData  = ();
      my @fileName  = ();
      my @fileLines = ();
      for ( my $i = 1 ; $i <= $ref->[0]{sheets} ; $i++ ) {
            print STDERR "#             | +-+- Tabelle No." . $i . " (" . $ref->[$i]{label} . ")\n";
            print STDERR "#             | | +- Maxrow : " . $ref->[$i]{maxrow} . "\n";
            print STDERR "#             | | +- Maxcol : " . $ref->[$i]{maxcol} . "\n";
            my $datei = "$base.$ref->[$i]{label}.raw";
            $fileName[$i] = $datei;
            my $count = 0;		  
            unless ( open( my $OUT, '>' . $datei ) ) {
                  print STDERR "#             | | +- (E) Unable to include $datei to HTML, because file could not be open because... $!\n";
                  $fileHnd[$i] = "deadbeef";
            } else {
                  $fileHnd[$i] = $OUT;
                  my $lineCnt  = 0;
                  my $code     = "";
                  my $startRow = 99999;
                  for ( my $row = 1 ; $row <= $ref->[$i]{maxrow} ; $row++ ) {
                        my @gotRow = row( $ref->[$i], $row );
                        #print STDERR Dumper(\@gotRow);			
                        my @useRow = ();
                        for ( my $column = 0 ; $column <= $ref->[$i]{maxcol} ; $column++ ) {
                              unless ( defined $gotRow[$column] ) {
                                    $useRow[$column] = "";
                              } else {
                                    #print  STDERR "CONVERT: $gotRow[$column] => ";
                                    $gotRow[$column] =~ s/\&lt;/\</g;
                                    $gotRow[$column] =~ s/\&gt;/\>/g;
                                    #print STDERR "$gotRow[$column]\n";
                                    if ( $gotRow[$column] =~ /^\s*\\?\'?\#/ ) {
                                          $column = $ref->[$i]{maxcol};
                                          #print STDERR "DONE.\n";
                                    } elsif ( $gotRow[$column] =~ /<!--\s+CONFIG\s+-->/ ) {
                                          for ( my $column = 0 ; $column <= $ref->[$i]{maxcol} ; $column++ ) {
                                                if ( defined $gotRow[$column] ) {
                                                      $gotRow[$column] =~ s/\&lt;/\</g;
                                                      $gotRow[$column] =~ s/\&gt;/\>/g;
                                                }
                                          }
                                          #print STDERR "CONFIG:". Dumper(\@gotRow)."\n";
                                          $gotRow[$column] = "";
                                          @tableBase = @gotRow;
                                          #print STDERR Dumper(\@tableBase );
                                          $startRow = $row + 1;
                                          print STDERR "#             | | +- (I) CONFIG line found in row $row, starting eval in row $startRow.\n";
                                          #die;
                                    } else {
                                          #print STDERR "ELSE.\n";
                                          $gotRow[$column] =~ s/\&lt;/\</g;
                                          $gotRow[$column] =~ s/\&gt;/\>/g;
                                          $gotRow[$column] =~ s/\&amp;/&/g;
                                          $useRow[$column] = $gotRow[$column];
                                    }
                              }
                        }
                        #print STDERR "PASSED.\n";
                        #print STDERR Dumper(\@gotRow);
                        #print STDERR Dumper(\@tableBase );
                        #print STDERR Dumper(\@useRow);
                        if ( $startRow <= $row ) {
                              my $k = 0;
                              foreach my $elem (@useRow) {
                                    my $str  = "";
                                    my $case = "unknown";
                                    if ( defined $tableBase[$k] ) {
                                          if ( ( $elem eq "" ) && ( $tableBase[$k] ne "" ) && ( $tableBase[$k] !~ /\{\}/ ) ) {
                                                $str  = $tableBase[$k];
                                                $case = "A";
                                          } elsif ( $tableBase[$k] =~ /\{\}/ ) {
                                                if ( $elem ne "_" ) {
                                                      #print STDERR Dumper(\@tableBase );
						      #print STDERR "elem: $elem\n";
                                                      $str = $tableBase[$k];
                                                      $str =~ s/\{\}/$elem/;
                                                      $case = "B";
                                                } else {
                                                      $case = "C";
                                                }
                                          } else {
                                                #$str = $elem;
                                                $case = "D";
                                          }
                                    } else {
                                          $case = "E";
                                    }
                                    $str =~ s/\r\n/ /g;
                                    if ( $str =~ /(.{10}([^a-zäüöÄÜÖA-Z 0-9:\-=\<\>\/\\\"\;\.\-\,\_\?\!\[\]\(\)\#\&\|\%\+\'\@]).{20})/ ) {
                                          $count += ( $str =~ s/Ã¤/ä/g );
                                          $count += ( $str =~ s/Ã¼/ü/g );
                                          $count += ( $str =~ s/Ã¶/ö/g );
                                          $count += ( $str =~ s/Ãŀ/Ä/g );
                                          $count += ( $str =~ s/Ã„/Ä/g );
                                          $count += ( $str =~ s/Ã�/Ä/g );
                                          $count += ( $str =~ s/Ãœ/Ü/g );
                                          $count += ( $str =~ s/Ã�/Ü/g );
                                          $count += ( $str =~ s/Ã–/Ö/g );
                                          $count += ( $str =~ s/Ã�/Ö/g );
                                          $count += ( $str =~ s/Ãŀ/Ö/g );
                                          $count += ( $str =~ s/ÃŸ/ß/g );
                                          $count += ( $str =~ s/�/_/g );
                                          $count += ( $str =~ s/�/_/g );
                                    }
                                    if ( $str =~ /(.{10}([^a-zäüöÄÜÖA-Z 0-9:\-=\<\>\/\\\"\;\.\-\,\_\?\!\[\]\(\)\#\&\|\%\+\'\@]).{20})/ ) {
                                          my $match = $1;
                                          #  if ($match =~ /[Ã¤Ã¼Ã¶ÃÃÃÃ]/) {
                                          print STDERR "#             | | +- (W) Unknown character found in code:\n";
                                          print STDERR "#             | | |        match: $match\n";
                                          print STDERR "#             | | |               ----------^----------\n";
                                          print STDERR "#             | | |             [$str]\n";
                                    }
                                    #print STDERR "[$row=$k] ($case) $str\n";
                                    $fileData[$i] .= $str;
                                    $k++;
                              }
                              $fileData[$i] .= "\n";
                              $lineCnt++;
                        }
                  }
                  $fileLines[$i] = $lineCnt;
            }
            print STDERR "#             | | +- (I) " . $count . " Unknown character found and replaced.\n";
            print STDERR "#             | +- Table completed.\n";
      }
      for ( my $i = 1 ; $i <= $ref->[0]{sheets} ; $i++ ) {
            my $OUT = $fileHnd[$i];
            #		print $OUT "\<div id=\"$ref->[$i]{label}\" name=\"$base\"\>";
            print $OUT "\<cite\>$base\<\/cite\>";
            print $OUT "$fileData[$i]";
            #		print $OUT "\<\/div\>";
            close $OUT;
            print STDERR "#             +- (I) Generated $fileName[$i] w/ $fileLines[$i] lines of HTML.\n";
            my $feedback = `chown :pagemaster $fileName[$i]`;
            print STDERR "#             +- (I) Making $fileName[$i] owned by pagemaster: $feedback.\n";
      }
}
