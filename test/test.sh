cat ONT.fastq.tar.bz2.aa ONT.fastq.tar.bz2.ab ONT.fastq.tar.bz2.ac ONT.fastq.tar.bz2.ad ONT.fastq.tar.bz2.ae ONT.fastq.tar.bz2.af|tar jxvf -
perl NanoStrTyping.pl -fq ONT.fastq -step_size 10 -configure str.bed -tmp_dir tmpdir -process 4
