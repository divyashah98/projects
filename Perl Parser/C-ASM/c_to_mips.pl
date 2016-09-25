#!bin/perl
use strict;
use warnings;

  my $c_file = shift;
  open (CODE_H, $c_file) or die "Unable to open $c_file for reading";
  open (OUTPUT_H, ">", "mips_code.asm") or die "Unable to write mips_code.asm";

  my %var_hash;
  my $code_started = 0;
  my $count = 0;
  while (my $line=<CODE_H>) {
    chomp ($line);
    # Look for comments in the beginning of the file
    while ($line =~ /\/\//) {
      $line =~ m/\/\/(.*)/;
      my $tmp_comment = $1;
      print OUTPUT_H "#\t$tmp_comment";
      print OUTPUT_H "\n";
      $line=<CODE_H>
    }
    if ($line =~ /int main/) {
      $code_started = 1;
    }
    if ($code_started) {
      # Look for variable declaration
      while ($line =~ m/int\s+(\S+)\s+=\s+(\S+)/) {
        if ($count == 0) {
      print "makin";
          print OUTPUT_H "\t.data\n";
        }
        $count++;
        my $tmp_var = $1;
        my $tmp_val = $2;
        print OUTPUT_H "#\t$line\n";
        print OUTPUT_H "$tmp_var:\t.word\t$tmp_val\n";
        $line=<CODE_H>
      }
      if ($line =~ m/int\s+(\S+)\s+/) {
        my $tmp_var = $1;
      }
      # Look for updates made to a variable
      my @keys_arr = keys %var_hash;
      for (my $i = 0; $i < scalar( keys %var_hash); $i++) {
        if ($line =~ $keys_arr[$i]) {
          $line =~ m/\S+\s+=\s+(\S+)/;
          my $tmp_val = $1;
          $var_hash{$keys_arr[$i]} = $tmp_val;
          last;
        }
      }
      # Look for cout statement
      if ($line =~ /cout <</) {
        my @keys_arr = keys %var_hash;
        for (my $i = 0; $i < scalar( keys %var_hash); $i++) {
          if ($line =~ $keys_arr[$i]) {
            last;
          }
        }
      }
    }
  }
