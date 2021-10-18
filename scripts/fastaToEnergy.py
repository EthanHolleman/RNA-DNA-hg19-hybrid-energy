# From rlooper
# "enegy diffeence fo the descibed NA/DNA dinucleotide pais (NA/DNA - DNA/DNA) in kcal/mol as descibed in Huppet 2008
# note, enegies ae fo the NA stand in the 5' to 3' diection"
#
# original values are below.
# GG_dCC = -0.36;
# GC_dCG = -0.16;
# GA_dCT = -0.1;
# GU_dCA = -0.06;
# CG_dGC = 0.97;
# CC_dGG = 0.34;
# CA_dGT = 0.45;
# CU_dGA = 0.38;
# AG_dTC = -0.12;
# AC_dTG = -0.16;
# AA_dTT = 0.6;
# AU_dTA = -0.12;
# UG_dAC = .45;
# UC_dAG = .5;
# UA_dAT = .28;
# UU_dAA = .8;

# Here, in order to more easily consider energetic favoribility of DNA sequences I structured the
# dictionary to map 5'-3' DNA dinucleotide pairs to RNA/DNA energies over that dinucleotide.
import csv
from os import write
from Bio import SeqIO
import numpy as np


def read_dictionary(dict_path):
    d = {}
    with open(str(dict_path)) as handle:
        reader = csv.reader(handle)
        for row in reader:
            d[row[0]] = float(row[1])
    assert len(d) == 16  # number of possible dinucleotide pairs
    return d


def calculate_energies(energy_dict, seq):
    values = np.zeros(len(seq))
    for i in range(len(values) - 1):
        di_nuc = seq.seq[i] + seq.seq[i + 1].upper()
        if di_nuc not in energy_dict:
            values[i] = -1  # handle N values
        else:
            values[i] = energy_dict[di_nuc]

    return values


def make_bed_line(*args):
    return "\t".join([str(a) for a in args])


def write_bedfile(chr_name, values, output_path):
    with open(output_path, "w") as handle:
        for i in range(len(values)):
            handle.write(make_bed_line(chr_name, i, i + 1, i, values[i]))
            handle.write('\n')

def main():

    energy_dict = read_dictionary(snakemake.input["energy_dict"])
    fasta = SeqIO.read(snakemake.input["fasta"], 'fasta')
    hybrid = calculate_energies(energy_dict, fasta)
    write_bedfile(fasta.id, hybrid, str(snakemake.output))


if __name__ == "__main__":
    main()
