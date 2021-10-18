ENERGY_DICT_PATH='resources/RNA-DNA-energy-kcal-mol.csv'

include: 'rules/download.smk'
include: 'rules/energy.smk'
include: 'rules/window.smk'

rule all:
    input:
        dynamic('output/map/{chrom_name}.mapped.windows.bed')