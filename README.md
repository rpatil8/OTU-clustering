OTU-clustering
==============

Scripts for benchmarking and comparison of short read OTU clustering tools available via QIIME 1.9.

Dependencies
------------

1. [QIIME 1.9](https://github.com/biocore/qiime/releases/tag/1.9.0)

Simulate reads:

2. [PrimerProspector (1.0.1)](http://pprospector.sourceforge.net)
3. [ART (VanillaIceCream-03-11-2014)](http://www.niehs.nih.gov/research/resources/software/biostatistics/art/)

Benchmark:

4. BLAST 2.2.29+
5. USEARCH Uchime (7.0.1090)
6. UPARSE (7.0.1090)

Install
-------

    git clone https://github.com/ekopylova/OTU-clustering.git

Datasets
--------

1. [Read datasets](ftp.microbio.me/pub/supplemental_otu_clustering_datasets.tar.gz)
2. [Greengenes 13.8](ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz) database
3. [SILVA 111](ftp://ftp.microbio.me/pub/QIIME_nonstandard_referencedb/Silva_111.tgz) database
4. [16S PyNAST template](http://greengenes.lbl.gov/Download/Sequence_Data/Fasta_data_files/core_set_aligned.fasta.imputed)
5. [18S PyNAST template](ftp.microbio.me/pub/core_Silva119_alignment.fna.gz)
6. For chimera checking 16S, [the gold database](http://drive5.com/uchime/uchime_download.html)
7. For chimera checking 18S, the SILVA 97% representative set from SILVA 111 (see above)

Scripts
-------

The benchmarking and analysis comparison can be executed using the following scripts (in given order).
The user must first edit all of file and directory paths in each script. 

1.  Even and staggered community reads were simulated using:<br/>
OTU-clustering/shell_scripts/simulate_reads.sh
2.  Launch all software (via QIIME’s pick_closed_reference_otus.py, pick_de_novo_otus.py and pick_open_reference_otus.py) on 16S datasets:<br/>
OTU-clustering/shell_scripts/commands_16S.sh
3.  Launch all software on 18S datasets:<br/>
OTU-clustering/shell_scripts/commands_18S.sh
4.  Remove singleton OTUs (OTUs consisting of only 1 read) from the final OTU tables generated in steps 2 and 3:
OTU-clustering/python_scripts/run_filter_singleton_otus.py
5.  Summarize taxonomy using filtered OTU tables:
OTU-clustering/python_scripts/run_summarize_taxa.py
6.  Summarize filtered OTU tables:
OTU-clustering/python_scripts/run_summarize_tables.py
7.  Compute true positive, false positive, false negative, precision, recall, F-measure and FP-chimera, FP-known, FP-other metrics using the summarized taxonomy results:
OTU-clustering/python_scripts/run_compute_precision_recall.py
8.  Generate alpha diversity plots:
OTU-clustering/python_scripts/run_single_rarefaction_and_plot.py
9.  Generate beta diversity plots:
OTU-clustering/python_scripts/run_beta_diversity_and_procrustes.py
10. Generate taxonomy comparison tables:
OTU-clustering/python_scripts/run_compare_taxa_summaries.py
11. Generate taxonomy stacked bar plots:
OTU-clustering/python_scripts/run_generate_taxa_barcharts.py
12. Plot TP, FP-chimera, FP-known and FP-other results:
OTU-clustering/python_scripts/plot_tp_fp_distribution.py

Citing
------

If you use any of the data or code included in this repository, please cite with the URL: https://github.com/ekopylova/OTU-clustering.git 
