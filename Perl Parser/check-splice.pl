  sub nary_print {
      my $n = shift;
      while (my @next_n = splice @_, 1, $n) {
        print "join q{ -- }, @next_n\n";
      }
    }
    nary_print(3, qw(a b c d e f g h));
