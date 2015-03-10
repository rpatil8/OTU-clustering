#!/usr/bin/python

import sys
import getopt

def clusters_from_uc_file(uc_lines, otu_id_field=9):
    """ Parses out hit/miss sequences from usearch uc file

    All lines should be 'H'it or 'N'o hit.  Returns a dict of OTU ids: sequence
    labels of the hits, and a list of all sequence labels that miss.

    uc_lines = open file object of uc file

    otu_id_field: uc field to use as the otu id. 1 is usearch's ClusterNr field,
     and 9 is usearch's TargetLabel field

    """

    hit_miss_index = 0
    cluster_id_index = otu_id_field
    seq_label_index = 8

    otus = {}
    unassigned_seqs = []

    for line in uc_lines:
        # skip empty, comment lines
        if line.startswith('#') or len(line.strip()) == 0:
            continue

        curr_line = line.split('\t')

        if curr_line[hit_miss_index] == 'N':
            # only retaining actual sequence label
            unassigned_seqs.append(curr_line[seq_label_index].split()[0])

        if curr_line[hit_miss_index] == 'H':

            curr_seq_label = curr_line[seq_label_index].split()[0]
            curr_otu_id = curr_line[cluster_id_index].split()[0]
            # Append sequence label to dictionary, or create key
            try:
                otus[curr_otu_id].append(curr_seq_label)
            except KeyError:
                otus[curr_otu_id] = [curr_seq_label]

    return otus, unassigned_seqs

def main(argv):
    usearch_file = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o",["ifile=","ofile="])
    except getopt.GetoptError: 
        print 'get_otu_map_usearch_ref.py -i <file.uc>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'get_otu_map_usearch_ref.py -i <file.uc>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            usearch_file = arg

    fo = open(usearch_file,"r")
    otu_id_field = 9
    clusters, unassigned_seqs = clusters_from_uc_file(fo,otu_id_field)
    for key, value in clusters.iteritems():
        sys.stdout.write(key + '\t')
        for x in value:
            sys.stdout.write(x + '\t')
        sys.stdout.write('\n')
    fo.close()

if __name__ == "__main__":
    main(sys.argv[1:])