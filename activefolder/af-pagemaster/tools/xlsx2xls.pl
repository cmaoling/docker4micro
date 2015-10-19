#!/usr/bin/perl
#-*- coding: utf-8 -*-
my $VERSION = "0.2";
my $SCRIPTNAME = $0; 
print	STDERR "#==================================================================#\n";
print	STDERR "# $SCRIPTNAME v$VERSION by Nicolas Mäding, (c) Nic-Services, 2012  #\n";
print	STDERR "#==================================================================#\n";
use strict;
use warnings;
use utf8;
use encoding 'windows-1252';  
use Spreadsheet::XLSX;
use Text::Iconv;
my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
#$\ = "\n"; $, = ";";
print STDERR "ARGV: $ARGV[0]\n";
#    my $workbook = Spreadsheet::XLSX->new()->parse($ARGV[0]);
#    my $worksheet = ($workbook->worksheets())[0];
#    my ($row_min, $row_max) = $worksheet->row_range();
#    my ($col_min, $col_max) = $worksheet->col_range();
#    for my $row ($row_min..$row_max) {
#        print map {$worksheet->get_cell($row,$_)->value()} ($col_min..$col_max);
#    }
my $excel = Spreadsheet::XLSX -> new ($ARGV[0]); #, $converter
 
 foreach my $sheet (@{$excel -> {Worksheet}}) {
 
        printf("Sheet: %s\n", $sheet->{Name});
        
        $sheet -> {MaxRow} ||= $sheet -> {MinRow};
        
         foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
         
                $sheet -> {MaxCol} ||= $sheet -> {MinCol};
                
                foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
                
                        my $cell = $sheet -> {Cells} [$row] [$col];
 
                        if ($cell) {
                            printf("( %s , %s ) => %s\n", $row, $col, $cell -> {Val});
                        }
 
                }
 
        }
 
 }
