#!/bin/bash

# Paso 1: Fusionar los archivos VCF de los padres
bcftools merge vep.EPID001-F.germline.vcf.gz vep.EPID001-M.germline.vcf.gz -o parents_EPID001.vcf

# Paso 2: Eliminar duplicados y ordenar el archivo VCF fusionado
cat parents_EPID001.vcf | sort | uniq > parents_EPID001_uniq.vcf

# Paso 3: Comprimir el archivo VCF fusionado y limpio
bgzip parents_EPID001_uniq.vcf

# Paso 4: Crear un archivo BED con las variantes del hijo
zcat vep.EPID001-P.germline.vcf.gz | grep -v "#" | awk '{print $1"\t"$2"\t"$2"\t"$4"\t"$5}' > child_variants_EPID001.bed

# Paso 5: Crear un archivo BED con las variantes de los padres
zcat parents_EPID001_uniq.vcf.gz | grep -v "#" | awk '{print $1"\t"$2"\t"$2"\t"$4"\t"$5}' > parent_variants_EPID001.bed

# Paso 6: Identificar las variantes de novo
bedtools intersect -v -a child_variants_EPID001.bed -b parent_variants_EPID001.bed > de_novo_variants_EPID001.bed

# Paso 7: Contar el número de variantes de novo
echo "Número de variantes de novo identificadas:"
cat de_novo_variants_EPID001.bed | wc -l

# Paso 8: Contar el número de variantes de los padres
echo "Número total de variantes de los padres:"
cat parent_variants_EPID001.bed | wc -l

# Generar README
echo "Este script realiza la fusión, limpieza y análisis de variantes genéticas para el estudio EPI"
