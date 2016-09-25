#!/usr/bin/perl -w

my $file = "$ARGV[0]";

my $name = '';
my $num = 0;
my $sname = '';
my @com;
my $type = '';
my $size = 0;
my $line;
my $count = 0;
my $flag = 0;


open (INPUT, "<", $ARGV[0]) || die "\nError: File Read \"$file\"\nError\n";
@line=<INPUT>;
close INPUT; 

  shift(@line);
	chomp $line[0];
	$line[0] =~ s/^\s+//; 
	$line[0] =~ s/\s+$//; 
  while($line[0]) {
      
      #name 
      chomp $line[0];
      $line[0] =~ m/\s*(\w+)\s*\{.*/;
      $name = $1;
      shift (@line);

      #num 
      chomp $line[0];
      if ($line[0] =~ /\@NUM/) {
        $line[0] =~ m/\s*\@NUM\s*=(.*);/i;
        $num = $1;
      }
      shift (@line);
      
SNAME:#SName
      chomp $line[0];
      $line[0] =~ m/\s*(\w+)\s*\{.*/i;
      $sname = $1;
      shift (@line);
        
      #Comment
      chomp $line[0];
      if ($line[0] =~ /\@COMMENT/i) {
        while (1) {
          chomp $line[0];
          if ($line[0] =~ /\@TYPE/i) {
            last;
          }
          $line[0] =~ s/^\s+//;
          $line[0] =~ s/\s+$//; 
          $line[0] =~ tr/,/|/;
          push(@com, $line[0]);
          shift(@line);
        }
      }
      
      #Type	
      if ($line[0] =~ /\@TYPE/i) {
        chomp $line[0];
        $line[0] =~ m/\s*\@TYPE\s*=(.*);/i;
        $type = $1;
        shift(@line);
      }
      
      #Size	
      chomp $line[0];
      $line[0] =~ m/\s*\}(.*);/;
      $size = $1;
      shift(@line);
      
      while ($line[0]) {
        chomp $line[0];
        $line[0] =~ s/^\s+//; 
        $line[0] =~ s/\s+$//; 
        $line[0] =~ m/(\w+)/;
        if ($1) {
          if ($count == 0) {
            $flag = 1;
            print "$name, $num, $sname, ";
            for (my $i = 0; $i < scalar(@com); $i++) {
              print "$com[$i] "; 
            }
            print "$type, $size\n";
            undef (@com);
            goto SNAME;
          }
          last;
        }
        else {
          $count++;
          shift(@line);
        }
      }
      if ($flag) {
        print "\t$sname, ";
        $flag = 0;
      }
      else {
        print "$name, $num, $sname, ";
      }
      for (my $i = 0; $i < scalar(@com); $i++) {
        print "$com[$i] "; 
      }
      print ",$type, $size\n";
      $count = 0;
      undef (@com);
  }
