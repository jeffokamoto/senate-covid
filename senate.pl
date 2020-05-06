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

# $d = 0; $i =  0; $r = 0;
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
    while(<DATA>) {
        chomp;
        push @data, $_;
    }
}

sub count_current {
    for my $l (@data) {
        my ($state, $govp, $s1p, $s1a, $s1n, $s2p, $s2a, $s2n)  = split(/:/, $l);
        # ${ $total{$s1p} }++;
        # ${ $total{$s2p} }++;
    }
    print_current();
}

sub print_current {
    # print "Dem: $d, Ind: $i, GOP: $r\n";
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
            my ($state, $govp, $s1p, $s1a, $s1n, $s2p, $s2a, $s2n)  = split(/:/, $l);

            if ($s1a < $age) {
                ${ $total{$s1p} }++;
            } else {
                if (died($s1p, \%death_chances)) {
                    ${ $dead{$s1p} }++;
                    ${ $replaced{$govp} }++;
                    ${ $total{$govp} }++;
                } else {
                    ${ $total{$s1p} }++;
                }
            }
            if ($s2a < $age) {
                ${ $total{$s2p} }++;
            } else {
                if (died($s2p, \%death_chances)) {
                    ${ $dead{$s2p} }++;
                    ${ $replaced{$govp} }++;
                    ${ $total{$govp} }++;
                } else {
                    ${ $total{$s2p} }++;
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

__DATA__
al:r:r:85:Shelby:d:65:Jones
ak:r:r:62:Murkosski:r:55:Sullivan
az:r:d:43:Sinema:r:54:McSally
ar:r:r:69:Boozman:r:42:Cotton
ca:d:d:86:Feinstein:d:55:Harris
co:d:d:55:Bennet:r:45:Gardner
ct:d:d:74:Blumenthal:d:46:Murphy
de:d:d:73:Carper:d:56:Coons
fl:r:r:48:Rubio:r:67:Scott
ga:r:r:70:Perdue:r:49:Loeffler
hi:d:d:47:Schatz:d:72:Hirono
id:r:r:68:Crapo:r:76:Risch
il:d:d:75:Durbin:d:52:Duckworth
in:r:r:47:Young:r:66:Braun
ia:r:r:86:Grassley:r:49:Ernst
ks:d:r:84:Roberts:r:65:Moran
ky:d:r:78:McConnell:r:57:Paul
la:d:r:62:Cassidy:r:68:Kennedy
me:d:r:67:Collins:i:76:King
md:r:d:76:Cardin:d:61:VanHollen
ma:r:d:70:Warren:d:73:Markey
mi:d:d:69:Stabenow:d:61:Peters
mn:d:d:59:Klobuchar:d:62:Smith
ms:r:r:68:Wicker:r:60:Hyde-Smith
mo:r:r:70:Blunt:r:40:Hawley
mt:d:d:63:Tester:r:57:Daines
ne:r:r:69:Fischer:r:48:Sasse
nv:d:d:56:Masto:d:62:Rosen
nh:r:d:73:Shaheen:d:62:Hassan
nj:d:d:66:Menendez:d:50:Booker
nm:d:d:71:Udall:d:48:Heinrich
ny:d:d:69:Schumer:d:53:Gillibrand
nc:d:r:64:Burr:r:59:Tillis
nd:r:r:63:Hoeven:r:59:Cramer
oh:r:d:67:Brown:r:64:Portman
ok:r:r:85:Inhofe:r:52:Lankford
or:d:d:70:Wyden:d:63:Merkley
pa:d:d:60:CaseyJr:r:58:Toomey
ri:d:d:70:Reed:d:64:Whitehouse
sc:r:r:64:GRaham:r:54:Scott
sd:r:r:59:Thune:r:65:Rounds
tn:r:r:79:Alexander:r:67:Blackburn
tx:r:r:68:Cornyn:r:49:Cruz
ut:r:r:48:Lee:r:73:Romney
vt:r:d:80:Leahy:i:78:Sanders
va:d:d:65:Warner:d:62:Kaine
wa:d:d:69:Murray:d:61:Cantwell
wv:r:d:72:Manchin:r:66:Capito
wi:d:r:65:Johnson:d:58:Baldwin
wy:r:r:76:Enzi:r:67:Barrasso
