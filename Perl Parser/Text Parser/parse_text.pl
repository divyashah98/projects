#!bin/perl
use strict;
use warnings;

my $text_file = shift;
open (TEXT_H, $text_file) or die "Unable to open $text_file for reading";
open (OUTPUT_H, ">", "output-inter.txt") or die "Unable to write output-inter.txt";
my @user_data;
my @data_all;
my @ip_combined;
my @random_set;
my %seen;

while (my $line=<TEXT_H>) {
    chomp ($line);
    my @tmp_arr = split(/>>>/, $line);
    my $ip_addr = $tmp_arr[0];
    my $rest_data = $tmp_arr[1];
    @user_data = split (/\|/, $rest_data); 
    push (@data_all, @user_data);
    for (my $i = 0; $i < scalar(@user_data); $i++) {
      push (@ip_combined, $ip_addr);
    }
}
for (1..scalar(@data_all)) {
    my $candidate = int rand(scalar(@data_all));
    redo if $seen{$candidate}++;
    push @random_set, $candidate;
}
for (my $i = 0; $i < scalar(@data_all); $i++) {
  print OUTPUT_H "$ip_combined[$random_set[$i]]>>>$data_all[$random_set[$i]]|";
  print OUTPUT_H "\n";
}

