#!usr/bin/perl

open(FH, "electricity.txt") or die("Error");												# Open the input file electricity.txt
open(FILE, ">outputQ2.txt");																# Open the output file OutputQ2.txt
@array = <FH>; 																				# Read the file in @array
foreach $symbols (@array) {
	$symbols =~ s/\(/ /g;  																    # Replace ( with blank space.
	$symbols =~ s/\)/ /g;  																	# Replace ) with blank space.
	$symbols =~ s/\[/ /g;  																	# Replace [ with blank space.
	$symbols =~ s/\]/ /g;  																	# Replace ] with blank space.
	$symbols =~ s/[",':~\!\?\-\.\d\/]/ /g; 													# Replace other symbols with blank space. 
	push(@array2, split(' ', $symbols)); 													# Using the split function on space
}
@sorted_array = sort{ lc($a) cmp lc($b) } @array2; 											# Sort the elements using the sort function

print "1) Alphabetically (Ignoring Capitalization):\n";										# Part 1 question 2
print FILE "1) Alphabetically (Ignoring Capitalization):\n";								# Print to file		   
foreach $word1(@sorted_array) {
	print "$word1\n"; 																        # Print the word to the console
	print FILE "$word1\n";  															    # Write the output to the file
}

print "\n2) Alphabetically placing upper case words before lower case words:\n";			# Part 2 question 2
print FILE "\n2) Alphabetically placing upper case words before lower case words:\n";		# Print to file
@sorted2 = sort{ $a cmp $b } @sorted_array; 												# Sort the array keeping case in mind
foreach $word2 (@sorted2) {
	print "$word2\n"; 																		# Printing the word to console 
	print FILE "$word2\n"; 																	# Write the output to the file
}

print "\n3) By Frequency, from high to low (any order for equal frequency):\n";				# Part 3 question 2
print "Frequency\tWord\n";
print FILE "\n3) By Frequency, from high to low (any order for equal frequency):\n";		# Print to the file
print FILE "Frequency\tWord\n";																# Print to the file	
foreach $x(@array2) {
	$freq{$x}++; 																			# Keep a count of every seen word
}

foreach $y(sort {$freq{$b} <=> $freq{$a}} keys %freq) {										# Use "<=>" to sort keeping frequency in mind
	print "$freq{$y}\t\t$y\n"; 																# Print the freq - word hash
	print FILE "$freq{$y}\t\t$y\n"; 														# Print the freq - word hash to the output file
}

print "\n4) By Frequency, with alphabetical order for words with the same frequency:\n";	# part  4 question 2
print "Frequency\tWord\n";
print FILE "\n4) By Frequency, with alphabetical order for words the same frequency:\n";    # Print to file
print FILE "Frequency\tWord\n";
foreach $i(@array2) {
	$freq2{$i}++; 																			# Keep a count of every seen word
}
foreach $j(sort {$freq2{$b} <=> $freq2{$a} or lc("$a") cmp lc("$b")} keys %freq2) {			# Use the "<=>" operator to sort with freq and alphabetical order
 	print "$freq2{$j}\t\t$j\n"; 															# Print the freq - word hash
	print FILE "$freq2{$j}\t\t$j\n"; 														# Print the freq - word hash to the output file
}
close(FH);
close(FILE);
		