
rule download_chrom_sizes:
    output:
        'output/hg19/hg19.chrom.sizes'
    params:
        url='http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.chrom.sizes'
        output_dir='output/hg19/'
    shell:'''
    mkdir -p {params.output_dir}
    cd {params.output_dir}
    wget {params.url}
    '''

rule make_windows:
    conda:
        '../envs/bedtools'
    input:
        'output/hg19/hg19.chrom.sizes'
    output:
        'output/windows/hg19.windows.bed'
    shell:'''
    bedtools -g {input} -w 100 -s 75 > {output}
    '''

rule split_windows_by_chrom:
    input:
        'output/windows/hg19.windows.bed'
    output:
        dynamic('output/windows/chroms/{chrom_name}.bed')
    params:
        out_dir='output/windows/chroms/
    shell:'''
    mkdir -p {params.out_dir}
    awk '{{close(f);f=$1}}{{print > "{params.out_dir}"f".bed"}}'
    '''

rule map_windows:
    input:
        windows='output/windows/chroms/{chrom_name}.bed',
        energy='output/hybridEnergy/{chrom_name}.bed.gz'
    output:
        'output/map/{chrom_name}.mapped.windows.bed'
    shell:'''
    bedtools map -a {input.windows} -b {input.energy} -c 6 -o mean > {output}
    '''




