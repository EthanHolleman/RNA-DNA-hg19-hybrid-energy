
rule download_chrom_sizes:
    output:
        'output/hg19/hg19.chrom.sizes'
    params:
        url='http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.chrom.sizes',
        output_dir='output/hg19/'
    shell:'''
    mkdir -p {params.output_dir}
    cd {params.output_dir}
    wget {params.url}
    '''

rule make_windows:
    conda:
        '../envs/bedtools.yml'
    input:
        'output/hg19/hg19.chrom.sizes'
    output:
        'output/windows/hg19.windows.bed'
    shell:'''
    mkdir -p output/windows
    bedtools makewindows -g {input} -w 100 -s 75 > {output}
    '''

rule split_windows_by_chrom:
    input:
        'output/windows/hg19.windows.bed'
    output:
        dynamic('output/windows/chroms/{chrom_bed}.bed')
    params:
        out_dir='output/windows/chroms'
    shell:'''
    mkdir -p {params.out_dir}
    awk '{{print $0 >> "output/windows/chroms/"$1".bed"}}' {input}
    '''

rule map_windows:
    input:
        windows='output/windows/chroms/{chrom_bed}.bed',
        energy='output/hybridEnergy/{chrom_bed}.bed.gz'
    output:
        'output/map/{chrom_bed}.mapped.windows.bed'
    shell:'''
    bedtools map -a {input.windows} -b {input.energy} -c 6 -o mean > {output}
    '''




