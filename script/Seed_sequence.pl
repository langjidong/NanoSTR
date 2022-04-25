#! /usr/bin/perl -w
use strict;
#Edit by Jidong Lang
#E-mail: langjidong@hotmail.com

unless(@ARGV>0)
{
    die "perl $0 <chr.fa> <start> <length> <output_title> <output-fa>\n";
}

open IN,$ARGV[0];
my $start = $ARGV[1];
my $length = $ARGV[2];
my $title  = $ARGV[3];
open OUT,">>$ARGV[4]";

my %hash;
my $chr;
while (<IN>){
    chomp;
    if (/>(\w+)/){
        chomp;
        $chr = ">".$title;
        $hash{$chr}="";
    }
    else{
        $hash{$chr} .= $_;
    }
}

foreach (keys %hash){
    my $hd = substr $hash{$_},$start-1,$length;
    print OUT $_,"\n";
    my @split = split //,$hd;
    my $j=0;
    my %hash;
    foreach (@split){
            my $key = int($j/50);
                $hash{$key} .=$_;
                    $j++;
    }
    foreach (sort {$a <=> $b} keys %hash){
            print OUT $hash{$_},"\n";
    }
}

