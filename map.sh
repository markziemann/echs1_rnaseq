#!/bin/bash
set -x

IDX=../ref/gencode.v37.transcripts.fa.idx

for FQZ1 in *_R1.fastq.gz ; do
  skewer -q 20 -t 16 $FQZ1
  FQT1=$(echo $FQZ1 | sed 's/fastq.gz/fastq-trimmed.fastq/')
  BASE=$(echo $FQZ1 | sed 's/_R1.fastq.gz//')
  kallisto quant --single -l 200 -s 50 -o $BASE -i $IDX -t 16 $FQT1
done

for TSV in */*abundance.tsv ; do
  NAME=$(echo $TSV | cut -d '/' -f1)
  cut -f1,4 $TSV | sed 1d | sed "s/^/${NAME}\t/"
done | pigz > 3col.tsv
