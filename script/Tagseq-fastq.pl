#! /usr/bin/perl -w
use strict;
use warnings;
#Edit by Jidong Lang
#E-mail: langjidong@hotmail.com

if(@ARGV!=4)
{
	print "perl $0 <seq> <Seed-F> <Seed-R> <OUT>\n";
	exit;
}
open IN, "$ARGV[0]" or die;
open OUT,">$ARGV[3]" or die;
#open IN,"$ARGV[0]" or die;
#open IN,"gzip -dc $ARGV[0]|";

my ($seq,$tmp,$qual,$seq1,$qual1);
my ($primer1,$primer2,$primer1_rev,$primer2_rev,$tmp_len1,$tmp_len2,$primer1_len,$primer2_len,$seq_len);

while(<IN>)
{
	chomp;
	if($_=~/^\@/)
	{
        chomp;
#        print OUT "$_\n";
		$seq=<IN>;
        chomp $seq;
        $primer1=$ARGV[1];
        $primer1_rev=$ARGV[1];
        $primer1_rev=~tr/ATCG/TAGC/;
        $primer1_rev=reverse $primer1_rev;
        $primer1_len=length($primer1);
        $primer2=$ARGV[2];
        $primer2_rev=$ARGV[2];
        $primer2_rev=~tr/ATCG/TAGC/;
        $primer2_rev=reverse $primer2_rev;
        $primer2_len=length($primer2);
#        print "$primer1\tyes\t$primer2_rev\tyes\t$primer2\tyes\t$primer1_rev\n";
        if($seq=~/^(.*)$primer1(\S+?)$primer2(.*)$/)
        {
            $tmp_len1=length($1);
            $tmp_len2=length($3);
            $seq1=$primer1.$2.$primer2;
            $seq_len=length($seq1);
	    #print "$tmp_len1\t$tmp_len2\t$seq_len\n";
	    print OUT "$_\n$seq1\n+\n";
        }
        elsif($seq=~/^(.*)$primer2_rev(\S+?)$primer1_rev(.*)$/)
        {
            $tmp_len1=length($1);
            $tmp_len2=length($3);
            $seq1=$primer2_rev.$2.$primer1_rev;
            $seq_len=length($seq1);
            #print "$tmp_len1\t$tmp_len2\t$seq_len\n";
	    print OUT "$_\n$seq1\n+\n";
        }
		$tmp=<IN>;
#        print OUT "$tmp";
		$qual=<IN>;
        if($seq=~/^(.*)$primer1(\S+?)$primer2(.*)$/)
        {
            #print "$qual\n";
            $qual1=substr($qual,$tmp_len1,$seq_len);
	    print OUT "$qual1\n";
        }
        elsif($seq=~/^(.*)$primer2_rev(\S+?)$primer1_rev(.*)$/)
        {
            #print "$qual\n";
            $qual1=substr($qual,$tmp_len1,$seq_len);
	    print OUT "$qual1\n";
        }
	}
}
