fname=alspac_all
npc=10

nsnps=$(wc -l ${fname}.map | awk '{print $1}')
thinamt=$(echo "scale=5;150000/${nsnps}" | bc)

#convert to ped/map format, with a subset of 150,000 SNPs
~/tools/plink2 --bfile $fname --thin $thinamt --recode12 --out ${fname}_sub

# convert to eigenstrat format
~/tools/convertf.perl ${fname}_sub

# now get the PC's using eigenstrat; assumes that smartpca is in the current dir; use the latest version from http://data.broadinstitute.org/alkesgroup/EIGENSOFT/ can solve the problem of missing libm.so.6 library.
~/tools/smartpca_loadings_mod.perl -i ${fname}_sub.eigenstratgeno -a ${fname}_sub.snp -b ${fname}_sub.ind -k $npc -o ${fname}_sub.pca -p ${fname}_sub.plot -e ${fname}_sub.eval -l ${fname}_sub.log -d ${fname}_sub.load -m 5 -t 10 -s 6.0 -g 1
