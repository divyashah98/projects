#!bin/perl
use strict;
use warnings;

my $option = shift;
my $text_file;
my $option2;
our @quota_book;
our @quota_user;
if ($option eq "-a" or $option eq "-f" or $option eq "-v") {
    $text_file = shift;
}
elsif ($option eq "-u" or $option eq "-q") {
    $option2 = shift;
    $text_file = shift;
}
else {
    die "Invalid command syntax\n";
}

open (TEXT_H, $text_file) or die "Unable to open $text_file for reading";
my %user_files;
my %book_pages;
my @user_name;
my $flag = 1;
my $count = 0;

while (my $line=<TEXT_H>) {
    $count++;
    chomp ($line);
    my @tmp_arr = split(/,/, $line);
    my $book = $tmp_arr[0];
    my $pages = $tmp_arr[1];
    my $name = $tmp_arr[2];
    if ($user_files{$name}) {
      $user_files{$name} = $user_files{$name} + 1;
      $book_pages{$name} = $book_pages{$name} + $pages;
    }
    else {
      $user_files{$name} = 1;
      $book_pages{$name} = $pages;
    }
    foreach my $tmp_user (@user_name) {
      if ($tmp_user eq $name) {
        $flag = 0;       
        last;
      }
      else {
        $flag = 1;
      }
    }
    push @user_name, $name if ($flag);
}
if ($option eq "-a") {
    if (scalar(@user_name)) {
      print "Printing users:\n";
      foreach my $user (@user_name) {
          print "$user\n";
      }
    }
    else {
        print "No printing users\n";
    }
}
if ($option eq "-f") {
    if ($count) {
      print "Total number of files printed: $count\n";
    }
    else {
      print "No files printed\n";
    }
}
if ($option eq "-u") {
    if ($user_files{$option2}) {
        print "User $option2:\n";
        print "Total number of files printed: $user_files{$option2}\n";
        print "Total number of pages printed: $book_pages{$option2}\n";
    }
    else {
        print "User $option2 not found\n";
    }
}
if ($option eq "-q") {
    my $quota_flag = 0;
    foreach my $user (@user_name) {
      if ($book_pages{$user} > $option2) {
        push @quota_book, $book_pages{$user};
        push @quota_user, $user;
        $quota_flag = 1;
      }
    }
    if ($quota_flag) {
      @quota_book = &bubble_sort(@quota_book);
      print "Users above quota:\n";
      foreach my $user (@quota_user) {
          print "$user\n";
      }
    }
    else {
        print "No user above quota\n";
    }
}

if ($option eq "-v") {
    print "raulbehl\n";
}

sub bubble_sort {
  my @arr = @_;
  for my $i (0..(scalar(@arr)-1)) {
    for my $j (0..$i) {
      if (($arr[$j] lt $arr[$i]) or ($arr[$j] eq $arr[$i])) {
        @arr[$i, $j] = @arr[$j, $i];
        @quota_user[$i, $j] = @quota_user[$j, $i];
      }
    }
  }
  return @arr;
}
