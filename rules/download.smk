

rule get_hg19:
    # download hg19 fasta from UCSD
    output:
        temp('output/hg19/hg19.fa')
    params:
        url='http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.fa.gz',
        download_name = 'hg19.fa.gz',
        download_dir='output/hg19'
    shell:'''
    mkdir -p {params.download_dir}
    cd {params.download_dir}
    wget {params.url}
    gunzip {params.download_name}
    '''

rule split_hg19_chrom:
    conda:
        '../envs/Py.yml'
    # Split hg19 genome into chromosomes
    input:
        'output/hg19/hg19.fa'
    output:
        dynamic('output/hg19/hg19/chroms/{chrom_name}.fa')
    params:
        out_dir = 'output/hg19/hg19/chroms'
    shell:'''
    mkdir -p {params.out_dir}
    python scripts/splitFasta.py {input} {params.out_dir}
    '''







