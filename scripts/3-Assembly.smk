# Assembly of all samples by bucket using megahit
rule Assembly_megahit:
    input:
        For="2-QC/2.6-CatReads/{sample}_all_R1.fq.gz",
        Rev="2-QC/2.6-CatReads/{sample}_all_R2.fq.gz",
    output:
        CheckMegahitAssembly="Checks/3.1-Assembly_all_{sample}.done"
    params:
        tag="{sample}",
        output_folder="3-Assembly/Contigs",
        output_temp="3-Assembly/megahit_temp",
    threads: 16
    resources:
        mem_mb="100gb",
        partition="bmh",
        time="4-00:00:00"
    shell:'''
        mkdir -p {params.output_temp} && \
        megahit -1 {input.For} -2 {input.Rev} \
        -t {threads} --continue --k-min 27 --presets meta-large \
        --out-dir {params.output_temp}/{params.tag} \
        --out-prefix {params.tag} && touch {output.CheckMegahitAssembly}
        '''

# Rename coassembled contigs
rule RenameAssemblyContigs:
    input:
        CheckMegahitAssembly="Checks/3.1-Assembly_all_{sample}.done",
    output:
        renamed_contigs = "3-Assembly/Assembly_all/{sample}_renamed_contigs.fna",
        CheckRenameAssemblyContigs = "Checks/3.2-RenameContigs_{sample}.done"
    params:
        tag = "{sample}",
        contigs = "3-Assembly/megahit_temp/{sample}/{sample}.contigs.fa"
    shell:'''
    awk '/^>/{{print ">" "{params.tag}" "_contig_" ++i; next}}{{print}}' < {params.contigs} > {output.renamed_contigs} && \
    touch {output.CheckRenameAssemblyContigs}
    '''