#!bin/perl
use strict;
use warnings;

my $report_mode = 0; # 0 - Comparison mode 1 - Full log copy mode
$report_mode = $ARGV[0] if (defined($ARGV[0]));
my $simulation_complete = 0;
my $spectre_res = 0;    # 0 - terminated 1 - completed
my $hspice_res = 0;     # 0 - terminated 1 - completed
my $age_file_spectre = 0;
my $age_file_hspice = 0;
my $out_file_spectre = 0;
my $out_file_hspice = 0;
my $cell_name = "inverter";
my @output_spectre_0;
my @output_spectre_1;
my @relx_spectre;
my @age_spectre;
my @test_spectre_0;
my @test_spectre_1;
my @cond_spectre;
my @std_dev_spectre;
my @status_spectre;
my @nominal_spectre;
my @output_hspice_0;
my @output_hspice_1;
my @relx_hspice;
my @age_hspice ;
my @test_hspice_0;
my @test_hspice_1;
my @cond_hspice;
my @std_dev_hspice;
my @status_hspice;
my @nominal_hspice;
open (OUTPUT_H, ">", "$ENV{'WARD'}/spectre_hspiceD_report.txt") or die "Unable to write spectre_hspiceD_report.txt";
#start the simulations in the two tools - 
if (system ("$ENV{'WARD'}/perl/my.csh")) {
#if (system ("perl $ENV{'WARD'}/perl/my.pl")) {
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
        if (open (SPECTRE_H, "$ENV{'WARD'}/adexl_spectre_ageing_eos.csv")) {
            $age_file_spectre = 1;
            if ($report_mode == 0) {
                my $i = 0;
                while (my $line=<SPECTRE_H>) {
                    if ($line =~ /,/ and $i != 0) {
                        my @tmp_arr = split /,/, $line;
                        push (@output_spectre_0   , $tmp_arr[0]);
                        push (@relx_spectre       , $tmp_arr[2]);
                        push (@age_spectre        , $tmp_arr[3]);
                        push (@test_spectre_0     , $tmp_arr[4]);
                        push (@cond_spectre       , $tmp_arr[5]);
                        push (@std_dev_spectre    , $tmp_arr[6]);
                        push (@status_spectre     , $tmp_arr[8]);
                    }
                    $i++;
                }
            }
            else {
                print OUTPUT_H "\n\nadexl_spectre_ageing_eos.csv file -\n";
                while (my $line=<SPECTRE_H>) {
                    print OUTPUT_H "$line";
                }
            }
            close (SPECTRE_H);
        }
        else {
            print OUTPUT_H "\n\nadexl_spectre_ageing_eos.csv file not found @ $ENV{'WARD'}/adexl_spectre_ageing_eos.csv\n";
        }
        if (open (SPECTRE_H, "$ENV{'WARD'}/adexl_spectre.csv")) {
            $out_file_spectre = 1;
            if ($report_mode == 0) {
                my $i = 0;
                my $j = 0;
                while (my $line=<SPECTRE_H>) {
                    if ($line =~ /,/ and $i != 0 and $line !~ /out_b/ and $line !~ /enable_b/) {
                        my @tmp_arr = split /,/, $line;
                        $test_spectre_1[$j]     = $tmp_arr[0];
                        $output_spectre_1[$j]   = $tmp_arr[1];
                        $nominal_spectre[$j]  = $tmp_arr[2];
                        $j++;
                    }
                    $i++;
                }
            }
            else {
                print OUTPUT_H "\n\nadexl_spectre.csv file -\n";
                while (my $line=<SPECTRE_H>) {
                    print OUTPUT_H "$line";
                }
            }
            close (SPECTRE_H);
        }
        else {
            print OUTPUT_H "\n\nadexl_spectre.csv file not found @ $ENV{'WARD'}/adexl_spectre.csv\n";
        }
    }
    if ($hspice_res == 1) {
        if (open (HSPICE_H, "$ENV{'WARD'}/adexl_hspice_ageing_eos.csv")) {
            $age_file_hspice = 1;
            if ($report_mode == 0) {
                my $i = 0;
                while (my $line=<HSPICE_H>) {
                    if ($line =~ /,/ and $i != 0) {
                        my @tmp_arr = split /,/, $line;
                        push (@output_hspice_0   , $tmp_arr[0]);
                        push (@relx_hspice       , $tmp_arr[2]);
                        push (@age_hspice        , $tmp_arr[3]);
                        push (@test_hspice_0     , $tmp_arr[4]);
                        push (@cond_hspice       , $tmp_arr[5]);
                        push (@std_dev_hspice    , $tmp_arr[6]);
                        push (@status_hspice     , $tmp_arr[8]);
                    }
                    $i++;
                }
            }
            else {
                print OUTPUT_H "\n\nadexl_hspice_ageing_eos.csv file -\n";
                while (my $line=<HSPICE_H>) {
                    print OUTPUT_H "$line";
                }
            }
            close (HSPICE_H);
        }
        else {
            print OUTPUT_H "\n\nadexl_hspice_ageing_eos.csv file not found @ $ENV{'WARD'}/adexl_hspice_ageing_eos.csv\n";
        }
        if (open (HSPICE_H, "$ENV{'WARD'}/adexl_hspice.csv")) {
            $out_file_hspice = 1;
            if ($report_mode == 0) {
                my $i = 0;
                my $j = 0;
                while (my $line=<HSPICE_H>) {
                    if ($line =~ /,/ and $i != 0 and $line !~ /out_b/ and $line !~ /enable_b/) {
                        my @tmp_arr = split /,/, $line;
                        $test_hspice_1[$j]     = $tmp_arr[0];
                        $output_hspice_1[$j]   = $tmp_arr[1];
                        $nominal_hspice[$j]    = $tmp_arr[2];
                        $j++;
                    }
                    $i++;
                }
            }
            else {
                print OUTPUT_H "\n\nadexl_hspice.csv file -\n";
                while (my $line=<SPECTRE_H>) {
                    print OUTPUT_H "$line";
                }
            }
        }
        else {
            print OUTPUT_H "\n\nadexl_hspice.csv file not found @ $ENV{'WARD'}/adexl_hspice.csv\n";
        }
    }
    print OUTPUT_H "\nComparison of different output values - \n";
    my $i = 0;
    my $prev_output;
    my $prev_relx;
    if ($age_file_spectre and $age_file_hspice) {
      print OUTPUT_H "\n\nComparing files adexl_spectre_ageing_eos.csv and adexl_hspice_ageing_eos.csv\n";
      foreach my $output (@output_spectre_0) {
          if ($i == 0) {
              $prev_output = $output;
              $prev_relx = $relx_spectre[$i];
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_0[$i], $relx_spectre[$i], 1);
              &print_table ($age_spectre[$i], $age_spectre[$i+1], 0, $age_spectre[$i + 2], 
                            $age_hspice[$i],  $age_hspice[$i+1],  $age_hspice[$i + 2],
                            $std_dev_spectre[$i],  $std_dev_spectre[$i+1],  $std_dev_spectre[$i + 2],
                            $std_dev_hspice[$i],  $std_dev_hspice[$i+1],  $std_dev_hspice[$i + 2]);
          }
          elsif (($prev_output eq $output) and ($prev_relx eq $relx_spectre[$i])) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_0[$i], $relx_spectre[$i], 1);
              &print_table ($age_spectre[$i], $age_spectre[$i+1], 0, $age_spectre[$i + 2], 
                            $age_hspice[$i],  $age_hspice[$i+1],  $age_hspice[$i + 2],
                            $std_dev_spectre[$i],  $std_dev_spectre[$i+1],  $std_dev_spectre[$i + 2],
                            $std_dev_hspice[$i],  $std_dev_hspice[$i+1],  $std_dev_hspice[$i + 2]);
          }
          $prev_output = $output;
          $prev_relx = $relx_spectre[$i];
          $i++;
      }
    }
    $i = 0;
    my $prev_test;
    if ($out_file_spectre and $out_file_hspice) {
      print OUTPUT_H "\n\nComparing files adexl_spectre.csv and adexl_hspice.csv\n";
      foreach my $test (@test_spectre_1) {
          if ($i == 0) {
              $prev_test = $test;
              print OUTPUT_H "\n\n";
              &print_table ($test_spectre_1[$i], "OUTPUT", 1);
              &print_table ($output_spectre_1[$i], $output_spectre_1[$i+1], 2, $output_spectre_1[$i + 2], 
                            $output_hspice_1[$i],  $output_hspice_1[$i+1],  $output_hspice_1[$i + 2],
                            $nominal_spectre[$i], $nominal_spectre[$i+1], $nominal_spectre[$i + 2],
                            $nominal_hspice[$i],  $nominal_hspice[$i+1],  $nominal_hspice[$i + 2]) if (($output_spectre_1[$i] !~ /out_b/));
          }
          elsif (($prev_test eq $test)) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_1[$i], "OUTPUT", 1);
              &print_table ($output_spectre_1[$i], $output_spectre_1[$i+1], 2, $output_spectre_1[$i + 2], 
                            $output_hspice_1[$i],  $output_hspice_1[$i+1],  $output_hspice_1[$i + 2],
                            $nominal_spectre[$i], $nominal_spectre[$i+1], $nominal_spectre[$i + 2],
                            $nominal_hspice[$i],  $nominal_hspice[$i+1],  $nominal_hspice[$i + 2]);
          }
          $prev_test = $test;
          $i++;
      }
    }
    $i = 0;
    if ($age_file_spectre and !$age_file_hspice) {
      print OUTPUT_H "\n\nResults from adexl_spectre_ageing_eos.csv file, adexl_hspice_ageing_eos.csv does not exist\n";
      foreach my $output (@output_spectre_0) {
          if ($i == 0) {
              $prev_output = $output;
              $prev_relx = $relx_spectre[$i];
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_0[$i], $relx_spectre[$i], 1);
              &print_table ($age_spectre[$i], $age_spectre[$i+1], 0, $age_spectre[$i + 2], 
                            "----", "----", "----",
                            $std_dev_spectre[$i],  $std_dev_spectre[$i+1],  $std_dev_spectre[$i + 2],
                            "----", "----", "----");
          }
          elsif (($prev_output eq $output) and ($prev_relx eq $relx_spectre[$i])) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_0[$i], $relx_spectre[$i], 1);
              &print_table ($age_spectre[$i], $age_spectre[$i+1], 0, $age_spectre[$i + 2], 
                            "----", "----", "----",
                            $std_dev_spectre[$i],  $std_dev_spectre[$i+1],  $std_dev_spectre[$i + 2],
                            "----", "----", "----");
          }
          $prev_output = $output;
          $prev_relx = $relx_spectre[$i];
          $i++;
      }
    }
    $i = 0;
    if ($out_file_spectre and !$out_file_hspice) {
      print OUTPUT_H "\n\nResults from adexl_spectre.csv file, adexl_hspice.csv does not exist\n";
      foreach my $test (@test_spectre_1) {
          if ($i == 0) {
              $prev_test = $test;
              print OUTPUT_H "\n\n";
              &print_table ($test_spectre_1[$i], "OUTPUT", 1);
              &print_table ($output_spectre_1[$i], $output_spectre_1[$i+1], 2, $output_spectre_1[$i + 2], 
                            "----", "----", "----",
                            $nominal_spectre[$i], $nominal_spectre[$i+1], $nominal_spectre[$i + 2],
                            "----", "----", "----");
          }
          elsif (($prev_test eq $test)) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_spectre_1[$i], "OUTPUT", 1);
              &print_table ($output_spectre_1[$i], $output_spectre_1[$i+1], 2, $output_spectre_1[$i + 2], 
                            "----", "----", "----",
                            $nominal_spectre[$i], $nominal_spectre[$i+1], $nominal_spectre[$i + 2],
                            "----", "----", "----");
          }
          $prev_test = $test;
          $i++;
      }
    }
    $i = 0;
    if (!$age_file_spectre and $age_file_hspice) {
      print OUTPUT_H "\n\nResults from adexl_hspice_ageing_eos.csv file, adexl_spectre_ageing_eos.csv does not exist\n";
      foreach my $output (@output_hspice_0) {
          if ($i == 0) {
              $prev_output = $output;
              $prev_relx = $relx_hspice[$i];
              print OUTPUT_H "\n\n";
              &print_table ($output_hspice_0[$i], $relx_hspice[$i], 1);
              &print_table ("----", "----", 0, "----", 
                            $age_hspice[$i],  $age_hspice[$i+1],  $age_hspice[$i + 2],
                            "----", "----", "----",
                            $std_dev_hspice[$i],  $std_dev_hspice[$i+1],  $std_dev_hspice[$i + 2]);
          }
          elsif (($prev_output eq $output) and ($prev_relx eq $relx_hspice[$i])) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_hspice_0[$i], $relx_hspice[$i], 1);
              &print_table ("----", "----", 0, "----", 
                            $age_hspice[$i],  $age_hspice[$i+1],  $age_hspice[$i + 2],
                            "----", "----", "----",
                            $std_dev_hspice[$i],  $std_dev_hspice[$i+1],  $std_dev_hspice[$i + 2]);
          }
          $prev_output = $output;
          $prev_relx = $relx_hspice[$i];
          $i++;
      }
    }
    $i = 0;
    if (!$out_file_spectre and $out_file_hspice) {
      print OUTPUT_H "\n\nResults from adexl_hspice.csv file, adexl_spectre.csv does not exist\n";
      foreach my $test (@test_hspice_1) {
          if ($i == 0) {
              $prev_test = $test;
              print OUTPUT_H "\n\n";
              &print_table ($test_hspice_1[$i], "OUTPUT", 1);
              &print_table (
                            "----", "----", 2, "----",
                            $output_hspice_1[$i],  $output_hspice_1[$i+1],  $output_hspice_1[$i + 2],
                            "----", "----", "----",
                            $nominal_hspice[$i],  $nominal_hspice[$i+1],  $nominal_hspice[$i + 2]) if (($output_hspice_1[$i] !~ /out_b/));
          }
          elsif (($prev_test eq $test)) {
          }
          else {
              print OUTPUT_H "\n\n";
              &print_table ($output_hspice_1[$i], "OUTPUT", 1);
              &print_table (
                            "----", "----", 2, "----",
                            $output_hspice_1[$i],  $output_hspice_1[$i+1],  $output_hspice_1[$i + 2],
                            "----", "----", "----",
                            $nominal_hspice[$i],  $nominal_hspice[$i+1],  $nominal_hspice[$i + 2]);
          }
          $prev_test = $test;
          $i++;
      }
    }
}

sub print_table {
    my $param_1 = $_[0];
    my $param_2 = $_[1];
    my $header = $_[2];
    my $param_3 = $_[3] if (defined($_[3]));
    my $param_4 = $_[4] if (defined($_[4]));
    my $param_5 = $_[5] if (defined($_[5]));
    my $param_6 = $_[6] if (defined($_[6]));
    my $param_7 = $_[7] if (defined($_[7]));
    my $param_8 = $_[8] if (defined($_[8]));
    my $param_9 = $_[9] if (defined($_[9]));
    my $param_10 = $_[10] if (defined($_[10]));
    my $param_11 = $_[11] if (defined($_[11]));
    my $param_12 = $_[12] if (defined($_[12]));
    
    my $head_print = sprintf
    "    |-------------------------------------------------------------------|
    |%35s -%6s                        |    
    |---------------------------------|---------------------------------|
    |            SPECTRE              |           HSPICE                |
    |---------------------------------|---------------------------------|\n", $param_1, $param_2;
    
    my $body_print = sprintf
    "    |%6s     |%6s  |%6s      |%6s   |%6s  |%6s        | 
    |           |        |            |         |        |              |    
    |           |        |            |         |        |              |    
    |-------------------------------------------------------------------|
    |%6s     |%6s  |%6s      |%6s   |%6s  |%6s        | 
    |           |        |            |         |        |              |    
    |           |        |            |         |        |              |    
    |-------------------------------------------------------------------|", $param_1, $param_2, $param_3, $param_4, $param_5, $param_6, $param_7, $param_8, $param_9, $param_10, $param_11, $param_12 if ($header == 0);

    my $body_print_2 = sprintf
    "    |%8s  |%8s  |%8s   |%8s   |%8s  |%8s  | 
    |          |          |           |           |          |          |    
    |          |          |           |           |          |          |    
    |-------------------------------------------------------------------|
    |%9s |%9s |%9s  |%9s  |%9s |%9s | 
    |          |          |           |           |          |          |    
    |          |          |           |           |          |          |    
    |-------------------------------------------------------------------|", $param_1, $param_2, $param_3, $param_4, $param_5, $param_6, $param_7, $param_8, $param_9, $param_10, $param_11, $param_12 if ($header == 2);
    print OUTPUT_H "$head_print" if ($header == 1);
    print OUTPUT_H "$body_print" if ($header == 0 );
    print OUTPUT_H "$body_print_2" if ( $header == 2);
}
