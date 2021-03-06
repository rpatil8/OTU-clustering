#!/bin/bash

# purpose : launch all OTU picking methods (via QIIME, or run_uparse.sh for UPARSE) for 18S studies
#           in a qsub environment
# author  : Jose A. Navas-Molina (josenavasmolina@gmail.com), Jenya Kopylova (jenya.kopylov@gmail.com)
#           script generated using https://github.com/josenavas/QIIME-Scaling

########### USER EDIT PATHS #############

# Silva 97% OTUs
si_rep_set=$1

# Silva 97% OTUs taxonomy
si_tax=$2

# 18S database for chimera checking
chimera_fp=$3

# 18S PyNAST template
template_fp=$4

# studies path (QIIME filtered)
studies_path_qiime=$5
# studies path (QIIME formatted, not filtered)
studies_path_uparse=$6

# Define the output directory
output_dir=$7

# Define the parameter folder
param_dir=$8

# OTU-clustering shell scripts
shell_scripts=$9

# OTU-clustering python scripts
python_scripts=${10}

# Number of threads per job
procs=${11}

# Number of jobs 
num_jobs=${12}

# list of studies to analyze
studies=(${13})

# qsub parameters
qsub_params="${14}"


mkdir $output_dir/18S


# Run de-novo OTU picking on all the studies                      
out_denovo_dir=$output_dir/18S/de_novo
mkdir $out_denovo_dir
for i in ${studies[@]}
do
    # Run with SUMACLUST
    echo "pick_de_novo_otus.py -i $studies_path_qiime/$i/seqs.fna -o $out_denovo_dir/sumaclust_$i -a -O $num_jobs -p $param_dir/DN_sumaclust_params.txt" | qsub -N 18DN_SC_$i $qsub_params; sleep 2
    # Run with UCLUST                                                                                                                                
    echo "pick_de_novo_otus.py -i $studies_path_qiime/$i/seqs.fna -o $out_denovo_dir/uclust_$i -a -O $num_jobs -p $param_dir/DN_uclust_params.txt" | qsub -N 18DN_UC_$i $qsub_params; sleep 2
    # Run with USEARCH61                                                                                                                                                 
    echo "pick_de_novo_otus.py -i $studies_path_qiime/$i/seqs.fna -o $out_denovo_dir/usearch61_$i -a -O $num_jobs -p $param_dir/DN_usearch61_params.txt" | qsub -N 18DN_US61_$i $qsub_params; sleep 2
    # Run with Swarm
    echo "pick_de_novo_otus.py -i $studies_path_qiime/$i/seqs.fna -o $out_denovo_dir/swarm_$i -a -O $num_jobs -p $param_dir/DN_swarm_params.txt" | qsub -N 18DN_SW_$i $qsub_params; sleep 2
    # Run with USEARCH52 - no chimera detection            
    echo "pick_de_novo_otus.py -i $studies_path_qiime/$i/seqs.fna -o $out_denovo_dir/usearch_$i -a -O $num_jobs -p $param_dir/DN_usearch_params.txt" | qsub -N 18DN_US_$i $qsub_params; sleep 2
    # Run UPARSE q16
    echo "bash $shell_scripts/run_uparse.sh $studies_path_uparse/$i/seqs.fastq $out_denovo_dir/uparse_q16_$i $chimera_fp $procs $num_jobs $si_rep_set $si_tax $i $template_fp 16 $python_scripts" | qsub -N 18DN_UPQ16_$i $qsub_params; sleep 2
    # Run UPARSE_q3
    echo "bash $shell_scripts/run_uparse.sh $studies_path_uparse/$i/seqs.fastq $out_denovo_dir/uparse_q3_$i $chimera_fp $procs $num_jobs $si_rep_set $si_tax $i $template_fp 3 $python_scripts" | qsub -N 18DN_UPQ3_$i $qsub_params; sleep 2
done

# Run closed-reference OTU picking on all the studies
out_closed_dir=$output_dir/18S/closed_ref
mkdir $out_closed_dir
for i in ${studies[@]}
do
    # Run with SortMeRNA
    echo "pick_closed_reference_otus.py -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_closed_dir/sortmerna_$i -t $si_tax -s -p $param_dir/CR_sortmerna_params.txt" | qsub -N 18CR_SMR_$i $qsub_params; sleep 2
    # Run with UCLUST
    echo "pick_closed_reference_otus.py -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_closed_dir/uclust_$i -t $si_tax -s -p $param_dir/CR_uclust_params.txt -a -O $num_jobs" | qsub -N 18CR_UC_$i $qsub_params; sleep 2
    # Run with USEARCH52
    echo "pick_closed_reference_otus.py -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_closed_dir/usearch_$i -t $si_tax -s -p $param_dir/CR_usearch_params.txt -a -O $num_jobs" | qsub -N 18CR_US_$i $qsub_params; sleep 2
    # Run with USEARCH61
    echo "pick_closed_reference_otus.py -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_closed_dir/usearch61_$i -t $si_tax -s -p $param_dir/CR_usearch61_params.txt -a -O $num_jobs" | qsub -N 18CR_US61_$i $qsub_params; sleep 2
done

# Run open-reference OTU picking on all the studies
out_open_dir=$output_dir/18S/open_ref
mkdir $out_open_dir
for i in ${studies[@]}
do
    # Run with SortMeRNA and SUMACLUST
    echo "pick_open_reference_otus.py -m sortmerna_sumaclust -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_open_dir/sortmerna_sumaclust_$i -p $param_dir/OR_sortmerna_sumaclust_params.txt -a -O $num_jobs" | qsub -N 18OR_SMR_SC_$i $qsub_params; sleep 2
    # Run with UCLUST
    echo "pick_open_reference_otus.py -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_open_dir/uclust_$i -p $param_dir/OR_params.txt -a -O $num_jobs" | qsub -N 18OR_UC_$i $qsub_params; sleep 2
    # Run with USEARCH61
    echo "pick_open_reference_otus.py -m usearch61 -i $studies_path_qiime/$i/seqs.fna -r $si_rep_set -o $out_open_dir/usearch61_$i -p $param_dir/OR_params.txt -a -O $num_jobs" | qsub -N 18OR_US61_$i $qsub_params; sleep 2
done



