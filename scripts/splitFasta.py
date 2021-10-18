# split one fasta file into individual records

from Bio import SeqIO
from pathlib import Path
from argparse import ArgumentParser

def get_args():

    parser = ArgumentParser('Split one fasta file into individual records')
    parser.add_argument('fasta', help='Path to fasta file to split.')
    parser.add_argument('out', help='Path to output directory')

    return parser.parse_args()


def split_fasta(fasta_path, output_dir):
    records = SeqIO.parse(str(fasta_path), 'fasta')
    for each_record in records:
        filename = Path(output_dir).joinpath(each_record.id).with_suffix('.fa')
        SeqIO.write([each_record], str(filename), 'fasta')


def main():

    args = get_args()
    files = split_fasta(args.fasta, args.out)
    return 0

if __name__ == '__main__':
    main()
    
