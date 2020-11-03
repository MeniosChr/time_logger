#!/usr/bin/perl

use 5.18.0;
use warnings;
use Time::Piece;

my $file = 'times.txt';
if (-e $file) {
    say "$file found!";
}
else{
    say $!;
}
my $count;
my $t1=0;#last time
my $t2;  #current time
my $x;   #last rection
my $y='Leasson';
my %hash = ();
open(my $ln,'<', $file) or die $!;
while (<$ln>) {
    #print $_;
    if ($_=~/^$/)
    {
        $t1=0;
        $x='';
        next;
    }
    
    if ($t1==0)
    {
        $t1=$1 if $_=~/([0-9]*:[0-9]*)/;
        $t1=Time::Piece->strptime( $t1, '%H:%M' ); 
        $x = $1 if($_=~/([a-z]+[^\n])/i);
    }
    else
    {
        $t2=$1 if ($_=~/([0-9]*:[0-9]*)/);
        $t2=Time::Piece->strptime( $t2, '%H:%M' );            
        if ($x=~/(Break)/i)
        {
            $count = $t2-$t1;
            $hash{$x}+=$count/60;
        }
        elsif ($x=~/(Exercises)/i)
        {
            $count = $t2-$t1;
            $hash{$x}+=$count/60;
         }
        else
        {
            $count = $t2-$t1;
            $hash{$y}+=$count/60;
        }
        $t1=$1 if $_=~/([0-9]*:[0-9]*)/;
        $t1=Time::Piece->strptime( $t1, '%H:%M' ); 
        $x = $1 if($_=~/([a-z]+[^\n])/i);
    }
}
my @val = values %hash;
my @ky = keys %hash;

for(my $i=0; $i<@val; $i++)
{
    my $hr = int($val[$i]/60);
    my $mn = $val[$i] % 60; 
    say "$ky[$i] : $hr hours and $mn minutes";
}
close $ln;
