#!bin/perl
use strict;
use warnings;

my $keyword_file = shift;
my $syslog_file = shift;
open (KEYWORD_H, $keyword_file) or die "Unable to open $keyword_file for reading";
open (OUTPUT_H, ">", "output-inter.txt") or die "Unable to write output-inter.txt";

while (my $keyword=<KEYWORD_H>) {
  open (SYSLOG_H, $syslog_file) or die "Unable to open $syslog_file for writing";
  while (my $line=<SYSLOG_H>) {
    chomp ($keyword);
    chomp ($line);
    if ($line =~ /$keyword/i) {
      $line =~ m/(\w+\s+\w+\s+\S+)\s+(\w+)\s+(\S+)\s+(.*)/; 
      my $date_time   = $1;
      my $hostname    = $2;
      my $syslog_word = $3;
      my $rest_data   = $4;
      print OUTPUT_H "**$keyword** $hostname $date_time $rest_data $syslog_word";
      seek (OUTPUT_H, -1, 1);
      print OUTPUT_H "\n";
    }
  }
}
