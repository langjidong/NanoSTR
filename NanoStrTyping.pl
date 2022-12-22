#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

sub USAGE
{
    my $usage=<<USAGE;

===============================================
Edit by Jidong Lang; E-mail: langjidong\@hotmail.com;
===============================================

Option
        -fq		<Raw Fastq File>	Input nanopore sequencing raw data
        -step_size	<Step Size>	Extraction times
        -configure	<STR BED File>	STR bed file, the format likes: chr\tstart\tend\tstr_name
	-tmp_dir	<Tmpfile Dir>	The tmpdir prefix
        -process	<Number of process used>	N processes to use, default is 1
        -help	print HELP message

Example:

perl $0 -fq nanopore.fq -step_size 10 -configure STR.bed -tmp_dir tmpdir -process 1

USAGE
}

unless(@ARGV>3)
{
    die USAGE;
    exit 0;
}


my ($fq,$step_size,$configure,$tmp_dir,$process);
GetOptions
(
    'fq=s'=>\$fq,
    'step_size=i'=>\$step_size,
    'configure=s'=>\$configure,
    'tmp_dir=s'=>\$tmp_dir,
    'process=i'=>\$process,
    'help'=>\&USAGE,
);

$process ||=1;

my $basename=basename($fq);
$basename=~s/(.*).fastq/$1/g;

####Data Pre-process and Quality Control####
my $time=`date`;
print "Process: 0%----Data Pre-process and Quality Control Start. Time: $time\n";

`mkdir clean_data`;
`porechop -t $process -i $fq -o ./clean_data/$basename.clean.fq`;
`mkdir QC`;
`NanoPlot -t $process --fastq ./clean_data/$basename.clean.fq --plots hex dot -o ./QC -p $basename`;

####Generate Seed Sequence List####
$time=`date`;
print "Process: 20%----Data Pre-process and Quality Control End and Generate Seed Sequence List Start. Time: $time\n";

open IN, "$configure" or die;

`mkdir Seed`;

my (@tmp);

while(<IN>)
{
    chomp;
    @tmp=split;
    for(my $i=0;$i<$step_size;$i++)
    {
	    my $tmp_start=$tmp[1]-($i+1)*$step_size;
	    my $tmp_end=$tmp[2]+1+$i*$step_size;
	    `perl $Bin/script/Seed_sequence.pl $Bin/database/by_chr/$tmp[0].fa $tmp_start $step_size $tmp[3] ./Seed/$tmp[3].tmp1`;
	    `perl $Bin/script/Seed_sequence.pl $Bin/database/by_chr/$tmp[0].fa $tmp_end $step_size $tmp[3] ./Seed/$tmp[3].tmp2`;
	    `paste ./Seed/$tmp[3].tmp1 ./Seed/$tmp[3].tmp2|grep -v \">\"|perl -e 'while(<>) {chomp; \$n+=1; \$_=~tr/[atcg]/[ATCG]/; print \"Tmp\$n\\t\$_\\n\";}' > ./Seed/$tmp[3].seedlist`;
	    #	    `rm -rf ./Seed/$tmp[3].tmp1 ./Seed/$tmp[3].tmp2`;
    }
    `rm -rf ./Seed/$tmp[3].tmp1 ./Seed/$tmp[3].tmp2`;
}

close IN;

####Pick Target Reads Based On Seed List####
$time=`date`;
print "Process: 40%----Generate Seed Sequence List End and Pick Target Reads Based On Seed List Start. Time: $time\n";

`mkdir Pick_Reads`;
`cat $configure|while read a b c d;do mkdir Pick_Reads/\${d};done`;
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do perl $Bin/script/Tagseq-fastq.pl ./clean_data/$basename.clean.fq \${b} \${c} ./Pick_Reads/\${f}/\${a}.fq;done;done`;

####Blast Alignment####
$time=`date`;
print "Process: 60%----Pick Target Reads Based On Seed List End and Blast Alignment Start. Time: $time\n";

`mkdir Blast`;
`cat $configure|while read a b c d;do mkdir Blast/\${d};done`;
`cat $configure|awk '{print \$1\"\\t\"\$2-500\"\\t\"\$3-\$2+1+1000\"\\t\"\$4}'|while read a b c d;do perl $Bin/script/Seed_sequence.pl $Bin/database/by_chr/\${a}.fa \${b} \${c} reference Blast/\${d}/reference.fa;done`;
`cat $configure|awk '{print \$4\"\\t\"501\"\\t\"501+\$3-\$2}'|while read a b c;do echo -e \"\${b}\\t\${c}\" > Blast/\${a}/reference.anchor.info;done`;	####There Is A Bug, Which "-e" Is In The Anchor File####
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do cat ./Pick_Reads/\${f}/\${a}.fq|perl -e 'while(<>) {chomp; if(/^\@/) {\$n+=1; \$seq=<>; \$tmp=<>; \$qual=<>; print \">query\$n\\n\$seq\";}}' > Blast/\${f}/\${a}.fa;done;done`;
`cat $configure|while read a b c d;do $Bin/bin/formatdb -i Blast/\${d}/reference.fa -p F -o T;done`;
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do $Bin/bin/blastall -p blastn -i Blast/\${f}/\${a}.fa -d Blast/\${f}/reference.fa -o Blast/\${f}/\${a}.m8.blast -e 1e-10 -F F -m 8 -a $process;done;done`;
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do $Bin/bin/blastall -p blastn -i Blast/\${f}/\${a}.fa -d Blast/\${f}/reference.fa -o Blast/\${f}/\${a}.blast -e 1e-10 -F F -a $process;done;done`;
`cat $configure|awk '{print \$4}'|while read a;do cat Blast/\${a}/reference.anchor.info|while read d b c;do perl $Bin/script/Filter-blastm8.pl Blast/\${a} \${b} \${c} $step_size;done;done`;	####There Is A Bug, Which "-e" Is In The Anchor File####

####Result Output####
$time=`date`;
print "Process: 80%----Blast Alignment End and Result Output Start. Time: $time\n";

`mkdir Typing_Result`;
`mkdir $tmp_dir`;
`cat $configure|awk '{print \$4}'|while read a;do mkdir Typing_Result/\${a};done`;
`cat $configure|awk '{print \$4}'|while read a;do mkdir $tmp_dir/\${a};done`;
`cat $configure|awk '{print \$4}'|while read a;do perl $Bin/script/Result.pl Pick_Reads/\${a}/ Blast/\${a} $step_size $tmp_dir/\${a} Typing_Result/\${a};done`;

$time=`date`;
print "Process: 100%----Result Output End and All tasks completed. Time: $time\n";
