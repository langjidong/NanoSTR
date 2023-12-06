# NanoSTR: A method for detection of targeted short tandem repeats (STRs) based on nanopore sequencing data

NanoSTR is a method for STR typing based on nanopore sequencing data and the reads’ length-number-rank (LNR) information. NanoSTR not only improves the effective use of sequencing data but also shows higher accuracy compared with the existing genotypical methods. NanoSTR provides an alternative analytical method for the detection of STR loci by nanopore sequencing and adds to the related data analysis tools. We hope that NanoSTR can further expand the application of nanopore sequencing techniques in scientific research and clinical scenarios so that these techniques can better promote the development of the sequencing industry and serve the needs of precision medicine.

Option

        -fq             <Raw Fastq File>        Input nanopore sequencing raw data
        -step_size      <Step Size>             Extraction times
        -configure      <STR BED File>          STR bed file, the format likes: chr     start   end     str_name
        -tmp_dir        <Tmpfile Dir>           The tmpdir prefix
        -process        <Number of process used>        N processes to use, default is 1
        -help           print HELP message

Example:<br>
**perl NanoStrTyping.pl -fq nanopore.fastq -step_size 10 -configure STR.bed -tmp_dir tmpdir -process 1**

Usage tips:

1. Before running, users need to install some following dependencies, such as Porechop, NanoPlot and BLAST. BTW, BLAST can be found in the *bin* folder, and needs to run command “*__chmod -R 755 ./bin__*” to obtain execution permission. If users want to use the latest version of these software, please install them and need to make corresponding changes in the *NanoStrTyping.pl* program. For ease of installation, we suggest that users can select *conda* for environment configuration. <br />

2. Put chromosomal reference genome sequence into the *database/by_chr/* folder, and save them in the file format with the suffix _*.fa_. For example, the Y chromosome (*chrY.fa*). <br />

3. Prepare the information of the targeted STR loci, and regard the first four columns as the *bed* file input by the *NanoStrTyping.pl* program, such as *str.bed*. <br />
```
Chromosome	Start	End	Locus	Assembly	CE	Unit_Bases	Extra_Bases
chrY	20471987	20472025	DYS392	GRCh38.p12	13	3	0
chrY	12825889	12825948	DYS438	GRCh38.p12	12	5	0
chrY	22218923	22219078	DYS448	GRCh38.p12	19	6	42
chrY	12258860	12258951	DYS635	GRCh38.p12	23	4	0
```
And the *str.bed* format's example:<br />
```
chrY	20471987	20472025	DYS392
chrY	12825889	12825948	DYS438
chrY	22218923	22219078	DYS448
chrY	12258860	12258951	DYS635
```

4. Run the *NanoStrTyping.pl* program, the command line is for example “*perl NanoStrTyping.pl -fq ONT.fastq -step_size 10 -configure str.bed -tmp_dir tmpdir -process 4*”. <br />

5. After the program finished, run the *script/Typing_predict.pl* to generate the final typing result of the STR loci. For example, users can run the command line “*perl ./script/Typing_predict.pl Typing_Result/DYS448 6 10 42*” to get a file named *predict.result* in the *Typing_Result/DYS448* folder, which contains the following content: <br />
```
        (CE)            (Support Read Number)        (STR Length)
Tmp1:   19      Read_Support:   7643    STR_Length:     156
Tmp3:   19      Read_Support:   5049    STR_Length:     156
Tmp4:   19      Read_Support:   3044    STR_Length:     156
Tmp5:   19      Read_Support:   2393    STR_Length:     156
Tmp6:   19      Read_Support:   1876    STR_Length:     156
Tmp7:   19      Read_Support:   1563    STR_Length:     156
Tmp8:   19      Read_Support:   1125    STR_Length:     156
Tmp9:   19      Read_Support:   940     STR_Length:     156
Tmp10:  19      Read_Support:   791     STR_Length:     156
```

6. Finally, the results with the mode and supported read number are selected as the final genotype for each target STR locus, that is, for example, DYS448 is considered to be homozygous, and the allele1/allele2 is 19/19. <br />

Note:
1. Since different versions of BLAST have different commands to run, we suggest that users can change Line 107-109 in the *NanoStrTyping.pl* program by themselves! For example, the default BLAST version is 2.2.23, and the users’ version is 2.13.0+, then the users need to replace the commands of Line 107-109 in the *NanoStrTyping.pl* program with following commands. But it should be note that different software version and parameter settings may affect the result of supported read number and running time of the program, please pay attention and make adjustments based on the actual situations. <br />
```
`cat $configure|while read a b c d;do makeblastdb -in Blast/\${d}/reference.fa -dbtype nucl -parse_seqids;done`;
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do blastn -task blastn -query Blast/\${f}/\${a}.fa -db Blast/\${f}/reference.fa -outfmt 6 -num_threads $process -out Blast/\${f}/\${a}.m8.blast -evalue 1e-10 -dust no;done;done`;
`cat $configure|awk '{print \$4}'|while read f;do cat ./Seed/\${f}.seedlist|while read a b c;do blastn -task blastn -query Blast/\${f}/\${a}.fa -db Blast/\${f}/reference.fa -out Blast/\${f}/\${a}.blast -evalue 1e-10 -num_threads $process -dust no;done;done`;
```
2. The method is still under further optimization and development, please contact us if you have any good suggestions and questions.<br />
***Contact and E-mail: langjidong@hotmail.com***

**Publications**

Lang J, Xu Z, Wang Y, Sun J, Yang Z. NanoSTR: A method for detection of target short tandem repeats based on nanopore sequencing data. Front Mol Biosci. 2023 Jan 18;10:1093519. doi: 10.3389/fmolb.2023.1093519. PMID: 36743210; PMCID: PMC9889824.
