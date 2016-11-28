#!bin/perl
use strict;
use warnings;
use Math::Complex;

my $hostname_file = shift;
open (HOSTNAME_H, "$hostname_file");

my @rtems_sys;
my @rtems_sys_old;

my @label_arr;
my @ip_arr;
my @node_arr;
my @os_arr;
my @rtems_arr;
my @agent_arr;
my @status_arr;

my $i = 0;
# Get the name of the RTEMSes connected to the environments
my @systems = `tacmd listsystems -t EM | grep REMOTE`;
my $num_sys = `tacmd listsystems -t EM | grep REMOTE | wc`;
#my @systems = `grep "REMOTE" list`;
#my $num_sys = `grep "REMOTE" list | wc`;
chomp ($num_sys);
chomp (@systems);
my @tmp = split / +/, $num_sys;
my $num_rtems = $tmp[1];
my @tmp_arr; 
for ($i = 0; $i < $num_rtems; $i++) {
    @tmp_arr = split / /, $systems[$i];
    push(@rtems_sys, $tmp_arr[0]);
}
my @label_rtems;
my @ip_rtems;
my @os_rtems;
my @status_rtems;
my @agents_count;
for ($i = 0; $i < $num_rtems; $i++) {
    $agents_count[$i] = 0;
}
my @agents_count_old;

# Get the number of agents connected to each of the RTEMSes
my $path_to_eplist = "/opt/IBM/NAS/eplist/";
#my $path_to_eplist = ".";
while (my $host = <HOSTNAME_H>) {
    chomp ($host);
    open (EPLIST_H, "$path_to_eplist/eplist_$host.csv");
    while (my $line = <EPLIST_H>) {
        chomp ($line);
        my @line_arr = split /;/, $line;
        my $label    = $line_arr[0];
        my $ip       = $line_arr[1];
        my $node     = $line_arr[2];
        my $os       = $line_arr[3];
        my $rtems    = $line_arr[4];
        my $agent    = $line_arr[5];
        my $status   = $line_arr[7];
        push (@label_arr,   $label);
        push (@ip_arr,      $ip);
        push (@node_arr,    $node);
        push (@os_arr,      $os);
        push (@rtems_arr,   $rtems);
        push (@agent_arr,   $agent);
        push (@status_arr,  $status);
    }
    my $j = 0;
    foreach my $rtems (@rtems_arr) {
        for ($i = 0; $i < $num_rtems; $i++) {
            if ($rtems eq $rtems_sys[$i]) {
                push (@{$label_rtems[$i]}, $label_arr[$j]); 
                push (@{$ip_rtems[$i]}, $ip_arr[$j]); 
                push (@{$os_rtems[$i]}, $os_arr[$j]); 
                push (@{$status_rtems[$i]}, $status_arr[$j]); 
                $agents_count[$i]++;
            }
        }
        $j++;
    }
    # Print the statistics in some file
    open (STAT_H, ">", "stat.txt");
    print STAT_H "HOSTNAME: $host\n";
    $i = 0;
    @agents_count = &bubble_sort (@agents_count);
    foreach my $rtems (@rtems_sys) {
        print STAT_H "Number of agents connected to $rtems -> $agents_count[$i]\n";
        $i++;
    }
    # caclulate mean - 
    my $mean = 0;
    my $std_dev = 101;
    my $i = 0;
    foreach my $rtems (@rtems_sys) {
        $mean = $mean + $agents_count[$i];
        $i++;
    }
    $mean = $mean/$num_rtems;
    # caclulate std deviation- 
STD_DEV:
    $i = 0;
    foreach my $rtems (@rtems_sys) {
        $std_dev = $std_dev + ($agents_count[$i] - $mean)**2;
        $i++;
    }
    $std_dev = $std_dev/$num_rtems;
    $std_dev = sqrt ($std_dev);
    while ($std_dev > 100) {
        # do reconfiguration
        # move few agents from the host under max stress to the host under least stress
        my $agents_to_move = int ($agents_count[0] - $agents_count[$num_rtems - 1])/2;
        my $i = 0;
        for ($i = 0; $i < $agents_to_move; $i++) {
            &reconfig_win ($ip_rtems[0][$i], $ip_rtems[$num_rtems-1][$i]) if ($os_rtems[0][$i] =~ /WIN/);
            &reconfig_aix ($ip_rtems[0][$i], $ip_rtems[$num_rtems-1][$i]) if ($os_rtems[0][$i] =~ /AIX/ or $os_rtems[0][$i] =~ /Linux/);
            $agents_count[0]--;
            $agents_count[$num_rtems - 1]++;
            push (@{$label_rtems[$num_rtems-1]},$label_rtems[0][$i]); 
            push (@{$ip_rtems[$num_rtems - 1]}, $ip_rtems[0][$j]); 
            push (@{$os_rtems[$num_rtems - 1]}, $os_rtems[0][$j]); 
            push (@{$status_rtems[$num_rtems - 1]}, $status_rtems[0][$j]); 
            sleep (60);
        }
        @agents_count = &bubble_sort (@agents_count);
        goto STD_DEV;
    }
    #if (open (STAT_OLD_H, "stat_old.txt")) {
    #    while (my $line = <STAT_OLD_H>) {
    #        chomp ($line);
    #        if ($line =~ /Number of agents connected to/) {
    #            $line =~ /Number of agents connected to (\S+) -> (\d+)/;
    #            push (@rtems_sys_old, $1);
    #            push (@agents_count_old, $2);
    #        }
    #    }
    #    @agents_count = &bubble_sort (@agents_count);
    #}
    #else {
    #    print "Could not find stat_old.txt - no reconfiguration would be done\n";
    #}
    #system ("mv stat.txt stat_old.txt");
    close (STAT_H);
}

sub bubble_sort {
  my @arr = @_;
  my @tmp_arr;
  for my $i (0..(scalar(@arr)-1)) {
    for my $j (0..$i) {
      if (($arr[$j] < $arr[$i])) {
        @arr[$i, $j] = @arr[$j, $i];
        @label_rtems[$i, $j] = @label_rtems[$j, $i];
        @ip_rtems[$i, $j] = @ip_rtems[$j, $i];
        @os_rtems[$i, $j] = @os_rtems[$j, $i];
        @status_rtems[$i, $j] = @status_rtems[$j, $i];
        @rtems_sys[$i, $j] = @rtems_sys[$j, $i];
      }
    }
  }
  return @arr;
}

sub reconfig_win {
    my $rtems_ip = $_[0];
    my $backup_rtems_ip = $_[1];
    system ("tacmd setagentconnection -n agentlabel:NT -a -p PROTOCOL1=IP.SPIPE IP_SPIPE_PORT=3660 SERVER=rtems_ip BPROTOCOL1=IP.SPIPE BIP_SPIPE_PORT=3660 BSERVER=backup_rtems_ip");
}

sub reconfig_aix {
    my $rtems_ip = $_[0];
    my $backup_rtems_ip = $_[1];
    system ("tacmd setagentconnection -n agentlabel:LZ -a -p SERVER=rtems_ip  BSERVER=backup_rtems_ip");
}
