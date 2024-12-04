#### Section 1 - Preprocessing ####

# Rule 1.1 - Run FastQC on merged runs
rule RawFastQC:
    input:
        ForRaw = "0-raw/{sample}_R1_downsampled.fastq.gz",
        RevRaw = "0-raw/{sample}_R2_downsampled.fastq.gz",
    output:
        CheckRawFastQC = "Checks/1.1-RawFastQC_{sample}.done"
    params:
        OutputDirectory = "1-Preprocessing/FastQC/Raw/",
        tag = "{sample}"
    threads: 8
    resources:
        mem_mb = 32000,
        partition = "high2"
    message:
        "Running FastQC on {wildcards.sample}"
    shell:'''
        mkdir -p {params.OutputDirectory} && \
        fastqc {input.ForRaw} -o {params.OutputDirectory} -t {threads} && \
        fastqc {input.RevRaw} -o {params.OutputDirectory} -t {threads} && \
        touch {output.CheckRawFastQC}
    '''