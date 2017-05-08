#!usr/bin/perl

open(FH, "my_file.txt") or die("Error");								 # my_file.txt contains the input
@array = <FH>; 															 # Read the file in @array
print "Printing the content: \n";           							 # Print  to console
print "@array\n\n";
open(FILE, ">outputQ3.txt");											 # Open outputQ3 file
print "Printing the output: \n";
foreach $number (@array) {
	$number =~ s/0/zero/g;												 # Globally replace every occurrence of 0 with zero
	$number =~ s/1/one/g;												 # Globally replace every occurrence of 1 with one
	$number =~ s/2/two/g;                                                # Globally replace every occurrence of 2 with two
	$number =~ s/3/three/g;                                              # Globally replace every occurrence of 3 with three
	$number =~ s/4/four/g;                                               # Globally replace every occurrence of 4 with four
	$number =~ s/5/five/g;                                               # Globally replace every occurrence of 5 with five
	$number =~ s/6/five/g;                                               # Globally replace every occurrence of 6 with six
	$number =~ s/7/seven/g;                                              # Globally replace every occurrence of 7 with seven
	$number =~ s/8/eight/g;                                              # Globally replace every occurrence of 8 with eight
	$number =~ s/9/nine/g;                                               # Globally replace every occurrence of 9 with nine
	print "$number\n"; 													 # Print to console
	print FILE "$number\n"; 											 # Write output to file
}
close(FH);
close(FILE);
