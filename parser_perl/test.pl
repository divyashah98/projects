my @system = `grep tee list`;
chomp (@system);
print "$system[0]$system[1]";
