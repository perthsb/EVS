#PBS -N jevs_global_det_wave_gfs_grid2obs_stats_00
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=00:20:00
#PBS -l place=vscatter,select=1:ncpus=25:mem=25GB
#PBS -l debug=true
#PBS -V

set -x 

cd $PBS_O_WORKDIR

export model=evs
export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS

export SENDCOM=YES
export SENDMAIL=YES
export KEEPDATA=YES
export job=${PBS_JOBNAME:-jevs_global_det_wave_gfs_grid2obs_stats}
export jobid=$job.${PBS_JOBID:-$$}
export SITE=$(cat /etc/cluster_name)
export cyc=00

source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/modulefiles/global_det/global_det_stats.sh

export machine=WCOSS2
export USE_CFP=YES
export nproc=25

export maillist='alicia.bentley@noaa.gov,mallory.row@noaa.gov'

export envir=prod
export NET=evs
export STEP=stats
export COMPONENT=global_det
export RUN=wave
export VERIF_CASE=grid2obs
export MODELNAME=gfs

export DATAROOT=/lfs/h2/emc/stmp/$USER/evs_test/$envir/tmp
export TMPDIR=$DATAROOT
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver
export COMROOT=/lfs/h2/emc/vpppg/noscrub/$USER

# CALL executable job script here
$HOMEevs/jobs/JEVS_GLOBAL_DET_STATS

#######################################################################
# Purpose: This does the statistics work for the global deterministic
#          wave grid-to-obs component for GFS
#######################################################################
