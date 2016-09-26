#!bin/perl
use strict;
use warnings;

our $test_file = shift;
open (FILE_H, $test_file) || print STDOUT "unable to open";
my $line = <FILE_H>;
my @y_string_arr;
my $num;
chomp ($line);
while (1) {
  my @RecArr = split(/:/, $line);
  my $tmp_field = $RecArr[2];
  my @tmp_y = split(/,/, $tmp_field);
  my $y_string = $tmp_y[0];
  my $count = -1;
  my @num_string_arr;
  push (@y_string_arr, $y_string);
  if ($y_string =~ m/\[(.*)\]/s) {
    @num_string_arr = split (/\[(.*)\]/, $y_string);
  }
  for (my $i = 0; $i < scalar (@y_string_arr); $i++) {
    if ($y_string =~ m/\[(.*)\]/) {
      if ($y_string_arr[$i] =~ m/\[(.*)\]/) {
        my @num_string_tmp =split (/\[(.*)\]/, $y_string_arr[$i]);
        if (($num_string_tmp[0] =~ $num_string_arr[0]) and ($num_string_tmp[1] =~ $num_string_arr[1])) {
          $count++;
        }
      }
    }
    elsif ($y_string_arr[$i] =~ $y_string) {
      $count++;
    }
    if ($count >= 1) {
      print "$y_string\n";
    }
  }
  if (eof(FILE_H)) {
    last;
  }
  $line = <FILE_H>;
  chomp($line);
}
