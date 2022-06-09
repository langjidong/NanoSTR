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

The STR.bed format's example:<br>
```
chrY    22633873        22633911        DYS392
chrY    14937824        14937873        DYS438
chrY    24365070        24365225        DYS448
chrY    14379564        14379655        DYS635
chrY    15278737        15278851        DYS447
```

The method is still under further optimization and development, please contact us if you have any good suggestions and questions.<br>
***Contact and E-mail: langjidong@hotmail.com***
