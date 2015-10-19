#!/usr/bin/perl
#-*- coding: utf-8 -*-
my $VERSION = "0.1";
my $SCRIPTNAME = $0; 
print	STDERR "#==================================================================#\n";
print	STDERR "# $SCRIPTNAME v$VERSION by Nicolas Mäding, (c) Nic-Services, 2012  #\n";
print	STDERR "#==================================================================#\n";
use strict;
use warnings;
#use utf8;
#use encoding 'utf8';  

sub includer{
	my $line = shift;
	if ($line =~ /<!--\s*#include\s+file=\"([a-z0-9A-Z\.\-\_]+)\"\s*-->/) {
		my $datei = $1;
		if (open(my $IN,'<'.$datei)) {
			$line = "";
			my $lineCnt = 0;
			while(<$IN>){
				next if ($_=~ /^#/);
				$line .= includer($_)."\n";
				$lineCnt++;
			}
			close $IN;
			print STDERR "(I) Included $datei w/ $lineCnt lines to HTML.\n";
		} else {
			print STDERR "(E) Unable to include $datei to HTML, because file could not be open because... $!\n";
		}
	}
	return $line;
}


while (<>) {
	print includer($_);
}