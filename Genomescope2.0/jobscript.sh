#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mem=64GB
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --account=OD-230743

cd ${SLURM_SUBMIT_DIR}

N=GI
ls ${N}/*fq.gz > FILES
files=FILES

./bin/kmc @${files} ${N} . -k21 -t 6 -m64 -ci1

if [ -s "${N}.kmc_pre" ];then
        ./bin/kmc_tools transform $N histogram ${N}.histo -cx10000
else
        echo "please run KMC"
fi

if [ -s "${N}.histo" ];then
        module load R
        /scratch1/kar131/genomescope2.0/genomescope.R -i ${N}.histo -o genomescope_${N} -k 21
else
        echo "Please run KMC or Jellyfish to create k-mer histogram"
fi

exit 0
