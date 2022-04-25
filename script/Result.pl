#! /usr/bin/perl -w
use strict;
use warnings;
use List::Util qw(min max);
#Edit by Jidong Lang
#E-mail: langjidong@hotmail.com

if(@ARGV!=5)
{
	print "perl $0 <clean_fq_dir> <filter_blastm8_dir> <step_size> <tmp_dir> <outputdir>\n";
	exit;
}

#`mkdir $ARGV[3]`;

for(my $i=0;$i<$ARGV[2];$i++)
{
	my $n=$i+1;
	`less $ARGV[0]/Tmp$n.fq|perl -e 'while(<>) {chomp; if(/^\@/) {\$seq=<>; \$tmp=<>; \$qual=<>; \$len=length(\$seq)-1; print \"\$len\\n\";}}'|sort|uniq -c|sort -rnk1 > $ARGV[3]/Tmp$n\_len.info`;
	`less $ARGV[1]/Tmp$n.filter.info|awk '{print \$8-\$7+1}'|sort|uniq -c|sort -rnk1 > $ARGV[3]/Tmp$n\_blastm8.info`;

open IN1, "$ARGV[3]/Tmp$n\_len.info" or die;
open IN2, "$ARGV[3]/Tmp$n\_blastm8.info" or die;
open OUT1, ">$ARGV[3]/Tmp$n\_tmp" or die;

my (@tmp1,@tmp2,@k1,@k2,@t1,@t2);

while(<IN1>)
{
	chomp;
	@tmp1=split;
	push @k1,$tmp1[0];
	push @k2,$tmp1[1];
}

while(<IN2>)
{
	chomp;
	@tmp2=split;
	push @t1,$tmp2[0];
	push @t2,$tmp2[1];
}

for(my $a=0;$a<@t1;$a++)
{
	for(my $b=0;$b<@k1;$b++)
	{
		if($k2[$b]==$t2[$a] && abs($b-$a)<3)	####Filter Condition####
		#if($k2[$b]==$t2[$a])
		{
			#print OUT "$k1[$a]\t$k2[$a]\t$t1[$b]\t$t2[$b]\t$a\t$b\n";
			my $num=$t2[$a]-2*$n*$ARGV[2];
			my $num1=$k2[$b]-2*$n*$ARGV[2];
			print OUT1 "$t1[$a]\t$num\t$k1[$b]\t$num1\t$a\t$b\n";
		}
		else
		{
			next;
		}
	}
}
close IN1;
close IN2;
close OUT1;

open IN3, "$ARGV[3]/Tmp$n\_tmp" or die;
open OUT2, ">$ARGV[4]/Tmp$n\_result" or die;

#`mkdir $ARGV[4]`;

my (@tmp3,@z1,@z2,@z3,$j);

while(<IN3>)
{
	chomp;
	@tmp3=split;
	push @z1,$tmp3[0];
	push @z2,$tmp3[1];
	push @z3,$tmp3[2];
}

my $number=@z1;

if($number==1)
{
	print OUT2 "@z1\t@z2\n";
}
else
{
	for($j=1;$j<$number;$j++)
	{
		my $ratio=$z1[$j-1]/$z1[$j];
		if($ratio>3)	####Filter Condition####
		{
			print OUT2 "$z1[$j-1]\t$z2[$j-1]\n";
			last;
		}
		else
		{
			print OUT2 "$z1[$j-1]\t$z2[$j-1]\n";
			print OUT2 "$z1[$j]\t$z2[$j]\n";
			last;
		}
	}
}
close IN3;
close OUT2;
}
