
rule fasta2energy:
    # Input fasta files and convert to dinucleotide RNA:DNA
    # hybrid energy bed files
    input:
        energy_dict=ENERGY_DICT_PATH,
        fasta='output/hg19/hg19/chroms/{chrom_name}.fa'
    output:
        'output/hybridEnergy/{chrom_name}.bed'
    script:'../scripts/fastaToEnergy.py'


rule compressEnergyBed:
    input:
        'output/hybridEnergy/{chrom_name}.bed'
    output:
        'output/hybridEnergy/{chrom_name}.bed.gz'
    shell:'''
    gzip -c {input} > {output}
    rm {input}
    '''






