#!bin/perl
use strict;
use warnings;

open (OUTPUT_I_H, "<", shift) or die "Unable to open output-inter.txt for reading";
open (OUTPUT_F_H, ">", "output-final.txt") or die "Unable to write output-final.txt";

my @keyword_arr;
our @info_arr;
while (my $line=<OUTPUT_I_H>) {
  chomp ($line);
  $line =~ m/\*\*(\w+)\*\*/; # parse - **keyword** 
  push (@keyword_arr, $1);
  push (@info_arr, $line);
}
my @keyword_sort = &bubble_sort(@keyword_arr);
my $flag=0;
my $end_date;
for (my $i = 0; $i <scalar(@keyword_sort); $i++) {
  my $count = 1;
  my $curr_keyword = $keyword_sort[$i];
  $info_arr[$i]  =~ m/(\S+\s+\S+\s+)(.*) </;
  my $key_info   = $1;
  my $start_date = $2;
  $info_arr[$i] =~ m/:[\S+\s+]{5}(.*)/;
  my $info_1 = $1;
  for (my $j = $i+1; $j <scalar(@keyword_sort); $j++) { 
    $info_arr[$j] =~ m/:[\S+\s+]{5}(.*)/;
    my $info_2 = $1;
    if (($curr_keyword eq $keyword_sort[$j]) and ($info_1 eq $info_2)) {
      $info_arr[$j] =~ m/\S+\s+\S+\s+(.*) </;
      $end_date = $1;
      $count++;
      $flag = 1;
      $i = $j;
    }
  }
  if ($flag) {
    $flag = 0;
    print OUTPUT_F_H "$key_info#$count $start_date-$end_date$info_1\n";
  }
  else {
    print OUTPUT_F_H "$key_info$start_date$info_1\n";
  }
}

sub bubble_sort {
  my @arr = @_;
  for my $i (0..(scalar(@arr)-1)) {
    for my $j (0..$i) {
      if (($arr[$j] gt $arr[$i]) or ($arr[$j] eq $arr[$i])) {
        @arr[$i, $j] = @arr[$j, $i];
        @info_arr[$i, $j] = @info_arr[$j, $i];
      }
    }
  }
  return @arr;
}
#print join (" ", &bubble_sort(@sort));
#print "\n";
