#! /usr/bin/perl

use Statistics::Basic qw(avg);
use strict;

our @data;
load_data();

srand(time);

our ($age, $dodds, $iodds, $rodds) = @ARGV;
$age = $age > 0 ? $age : 99;
$dodds = defined($dodds) ? $dodds : 1;
$rodds = defined($rodds) ? $rodds : 1;
$iodds = defined($iodds) ? $iodds : 1;

my $count = 1000;

# count_current();

print STDOUT "\"Dem/Ind Prob\",\"GOP Prob\",\"GOP Senators Number\",\"GOP Senators\"\n";
for my $dodds (qw(0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95)) {
    for my $rodds (qw(0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95)) {
        print STDERR ".";
        print STDOUT replace_by_age($count, $age, $dodds, $rodds, $dodds), "\n";
    }
}
print STDERR "\n";

sub load_data {
    open(F, "csv/senate.csv");
    <F>;
    while(<F>) {
        chomp;
        push @data, $_;
    }
}

sub count_current {
    my ($d, $r, $i);
    $d = 0; $i =  0; $r = 0;
    my %total = ( d => \$d, i => \$i, r => \$r );
    for my $l (@data) {
        my ($state, $govp, $party, $age, $name)  = split(/,/, $l);
        ${ $total{$party} }++;
    }
    print "Dem: $d, Ind: $i, GOP: $r\n";
}

sub died {
    my($p, $d_prob) = @_;

    if (rand() < ${ $d_prob->{$p} }) {
        return 1;
    }
    return 0;
}

sub replace_by_age  {
    my ($count, $age, $dodds, $rodds, $iodds) = @_;

    my ($d, $r, $i);
    my ($dd, $rd, $id);
    my ($dr, $rr, $ir);
    my @r;
    my %total = ( d => \$d, i => \$i, r => \$r );
    my %dead = ( d => \$dd, i => \$id, r => \$rd );
    my %replaced = ( d => \$dr, i => \$ir, r => \$rr );
    my %death_chances = ( d => \$dodds, i => \$iodds, r => \$rodds );

    for my $i (1..$count) {
        $d = 0; $i =  0; $r = 0;
        $dd = 0; $id =  0; $rd = 0;
        $dr = 0; $ir =  0; $rr = 0;
        for my $l (@data) {
            my ($state, $govp, $sp, $sa, $sn)  = split(/,/, $l);

            if ($sa < $age) {
                ${ $total{$sp} }++;
            } else {
                if (died($sp, \%death_chances)) {
                    ${ $dead{$sp} }++;
                    ${ $replaced{$govp} }++;
                    ${ $total{$govp} }++;
                } else {
                    ${ $total{$sp} }++;
                }
            }
        }
        # print "Dem died: $dd, Ind died: $id, GOP died: $rd\n";
        # print "Dem appointed $dr, Ind appointed $ir, GOP appointed $rr\n";
        # print "Dem: $d, Ind: $i, GOP: $r\n";
        push(@r, $r);
    }
    # print "@r\n";
    my $r_avg = avg(\@r);
    my $r_round = int($r_avg + 0.5);
    return join(',', $dodds, $rodds, $r_avg, $r_round);
}
