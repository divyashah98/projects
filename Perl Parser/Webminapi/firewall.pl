use Webmin::API;
foreign_require("firewall", "firewall-lib.pl");
use warnings;

my $COMMENT_PREFIX = 'autorule-';

$args = $#ARGV + 1;
if ($args != 3) {
    print "\nUsage: firewall.pl chainName add||delete ipaddress(multiple delimited by |)\n";
    exit;
}

my @tcpports = qw(ssh);
my @tables = firewall::get_iptables_save();

(my $filter) = grep { $_->{'name'} eq 'filter' } @tables;
if (!$filter) {
    my $filter = { 'name' => 'filter',
            'rules' => [ ] };
}

my @ipAddressList = (split /,/,$ARGV[2]);

foreach $ipAddress (@ipAddressList){
    my $comment = $COMMENT_PREFIX.'-'.$ipAddress;

    #remove existing rule before add
    for my $element (@{$filter->{'rules'}})
    {
        next unless defined $element->{'cmt'};

        if($element->{'cmt'} eq $comment){
            splice(@{$filter->{'rules'}}, 0, 1);
            print "Removing IP: $ipAddress\n";
        }
    }

    if($ARGV[1] eq 'add'){
        my $newrule = { 'chain' => $ARGV[0],
               's' => [ [ '', $ipAddress ] ],
               'j' => [ [ '', 'ACCEPT' ] ],
               'cmt' => $comment
              };
        splice(@{$filter->{'rules'}}, 0, 0, $newrule);
        print "Allowing IP: $ipAddress\n";
    }
}

firewall::save_table($filter);
firewall::apply_configuration();
