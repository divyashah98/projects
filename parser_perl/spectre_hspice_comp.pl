#!bin/perl
use strict;
use warnings;

my $simulation_complete = 0;
my $spectre_res = 0;    # 0 - terminated 1 - completed
my $hspice_res = 0;     # 0 - terminated 1 - completed
my $cell_name = "inverter";
my $period_spectre = 0;
my $tactive_spectre = 0;
my $freq_spectre = 0;
my $dutycycle_spectre = 0;
my $temper_spectre = 0;
my $alter_spectre = 0;
my $period_hspice = 0;
my $tactive_hspice = 0;
my $freq_hspice = 0;
my $dutycycle_hspice = 0;
my $temper_hspice = 0;
my $alter_hspice = 0;
open (OUTPUT_H, ">", "$ENV{'WARD'}/spectre_hspiceD_report.txt") or die "Unable to write spectre_hspiceD_report.txt";
#start the simulations in the two tools - 
if (system ("$ENV{'WARD'}/perl/my.csh")) {
    $simulation_complete = 0;
    die("System command failed to execute\n");
}
else {
    $simulation_complete = 1;
}
if ($simulation_complete) {
    my $res = `grep "spectre completes" $ENV{'WARD'}/simulation/$cell_name/spectre/schematic/psf/spectre.out`;
    if (($res)) {
        print OUTPUT_H "Spectre Passed!\n";
        $spectre_res = 1;
        goto NEXT;
    }
    $res = `grep "spectre terminated" $ENV{'WARD'}/simulation/$cell_name/spectre/schematic/psf/spectre.out`;
    if (($res)) {
        print OUTPUT_H "Spectre Failed!\n";
        $spectre_res = 0;
    }
NEXT:
    $res = `grep "hspice job concluded" $ENV{'WARD'}/simulation/$cell_name/hspiceD/schematic/psf/hspice.out`;
    if (($res)) {
        print OUTPUT_H "Hspice passed!\n";
        $hspice_res = 1;
        goto DONE;
    }
    $res = `grep "hspice job aborted" $ENV{'WARD'}/simulation/$cell_name/hspiceD/schematic/psf/hspice.out`;
    if (($res)) {
        print OUTPUT_H "Hspice Failed!\n";
        $hspice_res = 0;
    }
DONE:    
    if ($spectre_res == 1) {
        if (open (SPECTRE_H, "$ENV{'WARD'}/simulation/$cell_name/spectre/schematic/psf/spectreOut.mt0")) {
            while (my $line=<SPECTRE_H>) {
                chomp ($line);
                if ($line =~ /temper/) {
                    $line = <SPECTRE_H>;
                    chomp($line);
                    my @val_arr = split / +/, $line;
                    $period_spectre     = $val_arr[0];
                    $tactive_spectre    = $val_arr[1];
                    $freq_spectre       = $val_arr[2];
                    $dutycycle_spectre  = $val_arr[3];
                    $line = <SPECTRE_H>;
                    chomp ($line);
                    @val_arr = split / +/, $line;
                    $temper_spectre = $val_arr[0];
                    $alter_spectre = $val_arr[1];
                    last;
                }
            }
        }
        else {
            print "hello\n";
        }
    }
    if ($hspice_res == 1) {
        open (HSPICE_H, "$ENV{'WARD'}/simulation/$cell_name/hspiceD/schematic/psf/out.mt0") or die "Unable to open out.mt0 for reading";
        while (my $line=<HSPICE_H>) {
            chomp ($line);
            if ($line =~ /temper/) {
                $line = <HSPICE_H>;
                chomp($line);
                my @val_arr = split / +/, $line;
                $period_hspice     = $val_arr[0];
                $tactive_hspice    = $val_arr[1];
                $freq_hspice       = $val_arr[2];
                $dutycycle_hspice  = $val_arr[3];
                $line = <HSPICE_H>;
                chomp ($line);
                @val_arr = split / +/, $line;
                $temper_hspice = $val_arr[0];
                $alter_hspice = $val_arr[1];
                last;
            }
        }
    }
    if ($spectre_res and $hspice_res) {
        print OUTPUT_H "Spectre Ouput PERIOD: $period_spectre\nHspice Output PERIOD: $period_hspice\n\n" if (!($period_spectre eq $period_hspice));
        print OUTPUT_H "Spectre Ouput TACTIVE: $tactive_spectre\nHspice Output TACTIVE: $tactive_hspice\n\n" if (!($tactive_spectre eq $tactive_hspice));
        print OUTPUT_H "Spectre Ouput FREQ: $freq_spectre\nHspice Output FREQ: $freq_hspice\n\n" if (!($freq_spectre eq $freq_hspice));
        print OUTPUT_H "Spectre Ouput DUTYCYCLE: $dutycycle_spectre\nHspice Output DUTYCYCLE: $dutycycle_hspice\n\n" if (!($dutycycle_hspice eq $dutycycle_spectre));
        print OUTPUT_H "Spectre Ouput TEMPER: $temper_spectre\nHspice Output TEMPER: $temper_hspice\n\n" if (!($temper_spectre eq $temper_hspice));
        print OUTPUT_H "Spectre Ouput ALTER: $alter_spectre\nHspice Output ALTER: $alter_hspice\n\n" if (!($alter_hspice eq $alter_spectre));
    }
}
