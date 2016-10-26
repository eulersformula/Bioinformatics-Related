#convert a bunch of gz'ed vcf files into plink format

base=6580
for i in $(seq 22); do
  num=$(echo $base+$i | bc)
  fname='/bscb/ak735_0001/data/XWAS/temp/alspac/_EGAZ0000101'$num'_'$i'.ALSPAC.beagle.anno.csq.shapeit.20131101.vcf.gz'
  #We can use vcftools with the following command but it's just significantly faster with PLINK2. But PLINK2 cannot work with gz files direclty.
  #vcftools --gzvcf $fname --plink --out 'alspac_'$i
  ~/tools/plink2 --vcf $fname --make-bed --maf 0.05 --snps-only --biallelic-only --out 'alspac_'$i 
done

#renaming name of SNPs without rsid
for i in $(seq 22); do
  cat 'alspac_'$i'.bim' | awk '{if ($2 == ".") $2 = "chr"$1"_"$4; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' > 'alspac_'$i'.new.bim'
  mv 'alspac_'$i'.bim' 'alspac_'$i'.old.bim'
  mv 'alspac_'$i'.new.bim' 'alspac_'$i'.bim'
done

#combine the 22 chromosomes
rm alspac_mergelist.txt
touch alspac_mergelist.txt
for i in $(seq 22); do
  echo 'alspac_'$i'.bed alspac_'$i'.bim alspac_'$i'.fam' >> alspac_mergelist.txt
done
~/tools/plink2 --make-bed --merge-list alspac_mergelist.txt --out alspac_all

#check MAF
~/tools/plink2 --bfile alspac_all --freq --out alspac_all

########################just another dataset##############################

base=6607
for i in $(seq 22); do
  num=$(echo $base+$i | bc)
  fname='/bscb/ak735_0001/data/XWAS/temp/twins/_EGAZ0000101'$num'_'$i'.TWINSUK.beagle.anno.csq.shapeit.20131101.vcf.gz'
  ~/tools/plink2 --bcf $fname --make-bed --maf 0.05 --snps-only --biallelic-only --out 'twins_'$i
done

for i in $(seq 22); do
  cat 'twins_'$i'.bim' | awk '{if ($2 == ".") $2 = "chr"$1"_"$4; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' > 'twins_'$i'.new.bim'
  mv 'twins_'$i'.bim' 'twins_'$i'.old.bim'
  mv 'twins_'$i'.new.bim' 'twins_'$i'.bim'
done

rm twins_mergelist.txt
touch twins_mergelist.txt
for i in $(seq 22); do
  echo 'alspac_'$i >> twins_mergelist.txt
done
~/tools/plink2 --make-bed --merge-list twins_mergelist.txt --out twins_all
