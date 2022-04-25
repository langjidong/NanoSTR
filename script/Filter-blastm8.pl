#! /usr/bin/perl -w
use strict;
use warnings;
#Edit by Jidong Lang
#E-mail: langjidong@hotmail.com

if(@ARGV!=4)
{
	print "perl $0 <blast_m8_dir> <target_ref_start_position> <target_ref_end_position> <step_size>\n";
	exit;
}
#open IN, "$ARGV[0]" or die;
#open OUT,">$ARGV[4]" or die;

my (@tmp,@k1,@k2,@k3,@k4,@k5,@k6,@k7,@k8,@k9,@k10,@k11,@k12);
my ($i,$j);

for($i=0;$i<$ARGV[3];$i++)
{
	my $n=$i+1;
	open IN, "$ARGV[0]/Tmp$n.m8.blast" or die;
	open OUT, ">$ARGV[0]/Tmp$n.filter.info" or die;
	while(<IN>)
	{
		chomp;
		@tmp=split;
		push @k1,$tmp[0];
        	push @k2,$tmp[1];
        	push @k3,$tmp[2];
        	push @k4,$tmp[3];
        	push @k5,$tmp[4];
        	push @k6,$tmp[5];
        	push @k7,$tmp[6];
        	push @k8,$tmp[7];
        	push @k9,$tmp[8];
        	push @k10,$tmp[9];
        	push @k11,$tmp[10];
        	push @k12,$tmp[11];
	}
	
	my $start=$ARGV[1]-($i+1)*$ARGV[3];
	my $end=$ARGV[2]+($i+1)*$ARGV[3];
	for($j=0;$j<@k1;$j++)
	{
		#if($k5[$j]==0 && $k9[$j]==$start && $k10[$j]==$end || $k5[$j]==0 && $k9[$j]==$end && $k10[$j]==$start)
		if($k5[$j]<3 && $k9[$j]==$start && $k10[$j]==$end || $k5[$j]<3 && $k9[$j]==$end && $k10[$j]==$start)
		#if($k9[$j]==$start && $k10[$j]==$end || $k9[$j]==$end && $k10[$j]==$start)
		{
			print OUT "$k1[$j]\t$k2[$j]\t$k3[$j]\t$k4[$j]\t$k5[$j]\t$k6[$j]\t$k7[$j]\t$k8[$j]\t$k9[$j]\t$k10[$j]\t$k11[$j]\t$k12[$j]\n";
		}
	}
	close IN;
	close OUT;
}
