cat ONT.fastq.tar.bz2.aa ONT.fastq.tar.bz2.ab ONT.fastq.tar.bz2.ac ONT.fastq.tar.bz2.ad ONT.fastq.tar.bz2.ae ONT.fastq.tar.bz2.af|tar jxvf -
chmod -R 755 ../bin
gzip -dc ../database/by_chr/chrY.fa.gz > ../database/by_chr/chrY.fa
perl ../NanoStrTyping.pl -fq ONT.fastq -step_size 10 -configure str.bed -tmp_dir tmpdir -process 4
perl ../script/Typing_predict.pl Typing_Result/DYS392/ 3 10 0
perl ../script/Typing_predict.pl Typing_Result/DYS438/ 5 10 0
perl ../script/Typing_predict.pl Typing_Result/DYS448/ 6 10 42
perl ../script/Typing_predict.pl Typing_Result/DYS635/ 4 10 0
less Typing_Result/DYS392/predict.result
less Typing_Result/DYS438/predict.result
less Typing_Result/DYS448/predict.result
less Typing_Result/DYS635/predict.result
