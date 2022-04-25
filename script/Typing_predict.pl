#! /usr/bin/perl -w
use strict;
use warnings;
#Edit by Jidong Lang
#E-mail: langjidong@hotmail.com

if(@ARGV!=4)
{
	print "perl $0 <result_dir> <unit_number> <step_size> <extra_bases>\n";
	exit;
}

open OUT, ">>$ARGV[0]/predict.result" or die;

my (@tmp);

for(my $i=0;$i<$ARGV[2];$i++)
{
	my $n=$i+1;
	open IN, "$ARGV[0]/Tmp$n\_result" or die;
	while(<IN>)
	{
		chomp;
		@tmp=split;
		my $type=($tmp[1]-$ARGV[3])/$ARGV[1]+0.5;
		$type=int($type);
		print OUT "Tmp$n:\t$type\tRead_Support:\t$tmp[0]\tSTR_Length:\t$tmp[1]\n";
	}
	close IN;
}
close OUT;
