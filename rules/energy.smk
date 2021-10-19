
rule fasta2energy:
    # Input fasta files and convert to dinucleotide RNA:DNA
    # hybrid energy bed files
    input:
        energy_dict=ENERGY_DICT_PATH,
        fasta='output/hg19/hg19/chroms/{chrom_name}.fa'
    output:
        temp('output/hybridEnergy/{chrom_name}.bed')
    script:'../scripts/fastaToEnergy.py'

rule remove_N_rows:
    input:
        'output/hybridEnergy/{chrom_name}.bed'
    output:
        'output/clean/{chrom_name}.clean.bed'
    shell:'''
    awk '!/-1/' {input} > {output}
    '''


rule compressEnergyBed:
    input:
        'output/clean/{chrom_name}.clean.bed'
    output:
        'output/hybridEnergy/{chrom_name}.bed.gz'
    shell:'''
    gzip -c {input} > {output}
    rm {input}
    '''






