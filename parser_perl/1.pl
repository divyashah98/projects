#!usr/bin/perl

open (FH, "solar.txt") or die ("Error");												# open the solar.txt file
@array = <FH>; 																			# Read the file in array
print "1) Print all records that do not list a discoverer in the eigth field.\n";		# This is the part 1
foreach my $record (@array) { 															# Read the file line by line
	if($record =~ m/Voyager2/) { 														# Match with Voyager2
		print "$record\n";     															# Print when condition is true
	}
	if($record =~ m/- -/) {      														# Match with - - string
		print "$record\n";																# Print when condition is true
	}
}

print "\n2) Print every record omitting  the second field.\n";							# Part 2 of question 1	
@array2 = @array;  																		# Make a copy of original array
foreach $record (@array2) {
	@arr    = split(' ', $record);														# Use split function with delimeter as space 
	@temp = splice(@arr, 1, 1); 														# Splice the array A to remove second element
	print "\n@arr\n";  																	# Print the contents of @arr

print "\n3) Print the records for satellites that have negative orbitals\n";            # Part 3 of question 1
foreach $record (@array) {
	if($record =~ /-\d/) {  															# Look for any digit 0 - 9 starting with '-'
		print "$record\n"; 																# Print once find a negative number
	}
}

print "\n4) Print the data for the objects discovered by the Voyager2 space probe.\n";  # Part 4 of question 1
foreach $record (@array) {
	if($record =~ /Voyager2/) { 														# Search for Voyager2 in the string
		print "$record\n";    															# Print if condition is true
	}
}

print "\n5) Print record with the orbital period given seconds rather than days.\n";    # Part 5 of question 1
foreach $orbital (@array) {
	@arr = split(' ', $orbital);														# Split the orbital array on every space
	if(($arr[4] != "-") || ($arr[4] != "?")) {											# Search for negative
		$arr[4] *= 24 * 60 * 60;														# Convert into seconds
	}
	print "\n@arr\n";
}
close(FH); 