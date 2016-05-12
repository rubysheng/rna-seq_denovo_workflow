#!/bin/bash
#PBS -A userID
#PBS -N trimmomatic__BASE__
#PBS -o trimmomatic__BASE__.out
#PBS -e trimmomatic__BASE__.err
#PBS -l walltime=02:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

#pre-requis

module load compilers/gcc/4.8
module load apps/mugqic_pipeline/2.1.1
module load mugqic/java/jdk1.7.0_60
module load mugqic/trimmomatic/0.35

#Global variables
ADAPTERFILE="/path/to/file.fasta"

# Move to job submission directory
cd $PBS_O_WORKDIR

base=__BASE__

java -XX:ParallelGCThreads=1 -Xmx22G -cp $TRIMMOMATIC_JAR org.usadellab.trimmomatic.TrimmomaticSE \
        -phred33 \
        02_data/"$base".fastq.gz \
        03_trimmed/"$base"trimmed.fastq.gz \
        ILLUMINACLIP:"$ADAPTERFILE":2:20:7 \
        LEADING:20 \
        TRAILING:20 \
        SLIDINGWINDOW:30:30 \
        MINLEN:60 2>&1 | tee 98_log_files/"$TIMESTAMP"_trimmomatic_"$base".log