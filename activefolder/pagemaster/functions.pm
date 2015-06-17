#-*- coding: utf-8 -*-
package functions;
require 5.001;
use strict;
my $VERSION = "0.2";
my $SCRIPTNAME = __PACKAGE__;
#print	STDERR "#==================================================================#\n";
#print	STDERR "# $SCRIPTNAME v$VERSION by Nicolas Mäding, (c) Nic-Services, 2012  #\n";
#print	STDERR "#==================================================================#\n";
use Data::Dumper;
use Exporter;
our @ISA = 'Exporter';
our @EXPORT;

my $SCRIPT; if ( $0 =~ /.*\/(.*)/ ) {$SCRIPT=$1; } else {  $SCRIPT="<DEADBEEF>"; }
push(@EXPORT, '$SCRIPT');

# BASH => PERL
our $USER=$ENV{USER};
push(@EXPORT, '$USER');

my $HOSTNAME=$ENV{HOSTNAME};
push(@EXPORT, '$HOSTNAME');

# this is a perl replica of the /etc/init.d/functions script including the inits
my $BOOTUP="color";
my $RES_COL=140;
my $MOVE_TO_COL="print \"\\e\[${RES_COL}G\"";
my $SETCOLOR_SUCCESS="print \"\\e\[1;32m\"";
my $SETCOLOR_FAILURE="print \"\\e\[1;31m\"";
my $SETCOLOR_WARNING="print \"\\e\[1;33m\"";
my $SETCOLOR_NORMAL="print \"\\e\[0;39m\"";
my $SETCOLOR_DEBUG="print \"\\e\[1;36m\"";

push(@EXPORT, 'echo_failure');
sub echo_failure {
  if ( $BOOTUP eq "color" ) { eval($MOVE_TO_COL) }
  print "[";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_FAILURE) }
  print "FAILED";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_NORMAL) }
  print "]";
  print "\r";
  return 0
}

push(@EXPORT, 'echo_passed');
sub echo_passed {
  if ( $BOOTUP eq "color" ) { eval($MOVE_TO_COL) }
  print "[";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_SUCCESS) }
  print "PASSED";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_NORMAL) }
  print "]";
  print "\r";
  return 0
}
push(@EXPORT, 'echo_warning');
sub echo_warning {
  if ( $BOOTUP eq "color" ) { eval($MOVE_TO_COL) }
  print "[";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_WARNING) }
  print " WARN ";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_NORMAL) }
  print "]";
  print "\r";
  return 0
}
push(@EXPORT, 'echo_success');
sub echo_success {
  if ( $BOOTUP eq "color" ) { eval($MOVE_TO_COL) }
  print "[";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_SUCCESS) }
  print "  OK  ";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_NORMAL) }
  print "]";
  print "\r";
  return 0
}
push(@EXPORT, 'echo_debug');
sub echo_debug {
  if ( $BOOTUP eq "color" ) { eval($MOVE_TO_COL) }
  print "[";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_DEBUG) }
  print "DEBUG";
  if ( $BOOTUP eq "color" ) { eval($SETCOLOR_NORMAL) }
  print "]";
  print "\r";
  return 0
}

# Run some action. Log its output.
push(@EXPORT, 'action');
sub action {									# action() {
  my ($STRING,$rc);								#  local STRING rc
  $STRING="$_[0]";								#  STRING=$1
  print "$STRING ";								#  echo -n "$STRING "
										shift;
  my $cmd = ""; foreach my $foo (@_) {$cmd .= $foo." ";}				#  "$@" && success $"$STRING" || failure $"$STRING"		
  my $return = `$cmd 2> /dev/null`; unless ($? == 0) {echo_failure;} else {echo_success;}	#    :
  $rc=$?;									#  rc=$?
  print "\n";									#  echo
  return $rc;									#  return $rc
}										# }

########################################################################################################
push(@EXPORT, '_action');
sub _action {									# action() {
  my ($STRING,$rc);								#  local STRING rc
  $STRING="$_[0]";								#  STRING=$1
  print "$STRING ";								#  echo -n "$STRING "
										shift;
  my $code = ""; foreach my $foo (@_) {$code .= $foo." ";}	 			#  "$@" && success $"$STRING" || failure $"$STRING"		
  eval($code); unless ($@) {echo_success; $rc=0; } else {echo_failure; $rc=-1;}	#    :
  										#  rc=$?
  print "\n";									#  echo
  return $rc;									#  return $rc
}										# }

# my function
push(@EXPORT, '__header');
sub __header {
  my $TIME=`date -R`; unless ($?) {chomp $TIME;} else {$TIME = "FAILED";}
  my $HEADER="[$TIME] $HOSTNAME $SCRIPT [$$-$USER]: ";
  return $HEADER;
}

push(@EXPORT, '_msg');
sub _msg {											#function _msg {
	my $MSG=shift || "No Message";								#    MSG=${1:-"No Message"}
	my $TYPE=shift || "";									#    TYPE=${2:-}
	if ($TYPE ne "") {$TYPE = "($TYPE) "}							#    if [ ! -z "$TYPE" ]; then TYPE=" ($TYPE)"; fi
	my $OPT=shift || "";									#    OPT=${3:-}
	#print "\n\nMSG: <$MSG>	 TYPE: <$TYPE> OPT: <$OPT>\n\n"; 				#    echo "MSG: <$MSG>	 TYPE: <$TYPE> OPT: <$OPT>"
	if ($OPT =~ /^-.*n.*/) {$OPT = "";} else {$OPT = "\n"}; print __header.$TYPE.$MSG.$OPT;	# echo  $OPT "$(__header)$TYPE $MSG"
}

push(@EXPORT, '_Imsg');
sub _Imsg {
  my $text=shift;										#   :
  my $OPT=shift || "";										#   OPT=" ${2:-}"
  _msg $text, "I";										#  _msg "$1" "I" "$OPT"
}
push(@EXPORT, '_Dmsg');
sub _Dmsg {											#function _Emsg {
  my $text=shift;										#   :
  my $OPT=shift || "";										#   OPT=" ${2:-}"
  _msg $text, "D", "-n"; echo_debug; 	print "\n";						#  _msg "$1" "D" "$OPT"
}												#}
push(@EXPORT, '_Pmsg');
sub _Pmsg {											#function _Emsg {
  my $text=shift;										#   :
  my $OPT=shift || "";										#   OPT=" ${2:-}"
  _msg $text, "C", "-n"; echo_passed; 	print "\n";						#  _msg "$1" "C" "$OPT"
}												#}
push(@EXPORT, '_Emsg');
sub _Emsg {											#function _Emsg {
  my $text=shift;										#   :
  my $OPT=shift || "";										#   OPT=" ${2:-}"
  _msg $text, "E", "-n"; echo_failure; 	print "\n";						#  _msg "$1" "E" "$OPT"
}												#}
push(@EXPORT, '_Wmsg');
sub _Wmsg {
  my $text=shift;										#   :
  my $OPT=shift || "";										#   OPT=" ${2:-}"
  _msg $text, "W", "-n"; echo_warning; 	print "\n";						#  _msg "$1" "W" "$OPT"
}

push(@EXPORT, '_mkdir');
sub _mkdir {  											# function _mkdir() {
  my $DIR=shift || "";										# DIR=${1:-}
  #_Dmsg "DIR: <$DIR>"
  if ($DIR eq "") {										# if [ -z "$DIR" ]; then
     _Emsg "_mkdir: Operand missing.";								#  _Emsg "_mkdir: fehlender Operand"
  } else {
    if ( -d $DIR ) { 										#   if [ -d "$DIR" ]; then 
	_Wmsg "_mkdir: Directory exists." 							#     _Imsg "Setup - Directory $DIR already exists. Will reuse it."
    } else {											#   else
      												#     _Imsg "Setup - Creating $DIR as $ACTIVEUSER in $RWD for future usage: " "-ne"
	action(__header."_mkdir: $DIR", "mkdir -p $DIR ");					#     sudo -u $ACTIVEUSER mkdir -p "$DIR" 
												#     if [ "$?" == "0" ]; then echo "DONE."; fi
    }												#   fi
  }												# fi
}

1;
